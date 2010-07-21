Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab0GUPwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0GUPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:52:31 -0400
Message-ID: <4C471768.5090108@kernel.org>
Date: Wed, 21 Jul 2010 17:51:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C4712B4.9040706@kernel.org> <4C470B46.4040604@kernel.org> <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com> <15189.1279725944@redhat.com> <15482.1279727125@redhat.com>
In-Reply-To: <15482.1279727125@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 15:51:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 05:45 PM, David Howells wrote:
> That's fine.  Better that than risk unexpected reentrance.  You could add a
> function to allow an executing work item to yield the hash entry to indicate
> that the work_item that invoked it has been destroyed, but it's probably not
> worth it, and it has scope for mucking things up horribly if used at the wrong
> time.

Yeah, I agree, it's going too far and can be easily misused.  Given
that there are very few users which actually do that, I think it would
be best to leave it alone.

> I presume also that if a work_item being executed on one work queue is queued
> on another work queue, then there is no non-reentrancy guarantee (which is
> fine; if you don't like that, don't do it).

Right, there is no non-reentrancy guarantee.

Thanks.

-- 
tejun
