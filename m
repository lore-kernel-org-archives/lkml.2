Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1CXJyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:54:14 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:38924 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1CXJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:54:12 -0400
Message-ID: <4D8B14BD.2060602@de.ibm.com>
Date: Thu, 24 Mar 2011 10:54:05 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        stefanha@gmail.com, kwolf@redhat.com, prerna@linux.vnet.ibm.com
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au> <4D8AB514.5020306@us.ibm.com>
In-Reply-To: <4D8AB514.5020306@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.03.2011 04:05, schrieb Anthony Liguori:
>> ie. lguest and S/390 don't trap writes to config space.
>>
>> Or perhaps they should?  But we should be explicit about needing it...
> I don't think we ever operated on the assumption that config space writes would trap.
> 
> I don't think adding it is the right thing either because you can do byte access to the config space which makes atomicity difficult.

There is the additional problem, that s390 has no MMIO and,therefore,
there is no real HW support for trapping writes to an area. You can
use page faults, or read-only faults on newer systems, but this is 
expensive. In addition, page faults only deliver the page frame, but
not the offset within a page.
> 
> Any reason not to use a control queue to negotiate dynamic features? 

Sounds reasonable.
