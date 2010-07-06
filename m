Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0GFO1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 10:27:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:53721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GFO1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 10:27:45 -0400
Message-ID: <4C333D09.10204@kernel.org>
Date: Tue, 06 Jul 2010 16:26:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au, dhowells@redhat.com,
       arjan@linux.intel.com, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere> <4C2A145E.8030608@kernel.org> <20100629154738.GJ5318@nowhere> <4C2A1672.20700@kernel.org> <20100629160100.GL5318@nowhere> <4C2A1ABF.8050504@kernel.org> <alpine.DEB.2.00.1007060921350.3627@router.home>
In-Reply-To: <alpine.DEB.2.00.1007060921350.3627@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 14:26:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 04:22 PM, Christoph Lameter wrote:
> On Tue, 29 Jun 2010, Tejun Heo wrote:
> 
>> What alignment maintenance?  Are you talking about the UP code?  If
>> you're talking about the UP code, the ugliness there is because the
>> current UP __alloc_percpu() can't honor the alignment parameter.
> 
> Why do we need alignment on UP? Cachelines typically dont bounce if a
> single processor accesses the data.

Because work->data is multiplexed with pointer and flag bits, so the
targets of the pointer (cwq's) need to be aligned so that the lower
part of the pointer always stays zero.

Thanks.

-- 
tejun
