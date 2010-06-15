Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0FOSly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:41:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab0FOSlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:41:51 -0400
Message-ID: <4C17C938.4040703@kernel.org>
Date: Tue, 15 Jun 2010 20:40:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <4C17C671.3020605@s5r6.in-berlin.de>
In-Reply-To: <4C17C671.3020605@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 18:40:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 08:29 PM, Stefan Richter wrote:
> Tejun Heo wrote:
>> This is the fifth take of cmwq (concurrency managed workqueue)
>> patchset.  It's on top of v2.6.35-rc3 + sched/core patches.  Git tree
>> is available at
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq
> 
> A comment and a question:
> 
> As a driver maintainer, I would find it helpful if the WQ_flags in
> include/linux/workqueue.h and/or __create_workqueue_key() in
> kernel/workqueue.c (or its wrappers in include/linux/workqueue.h) were
> better documented.

Sure, it can definitely be improved.

> How about the global workqueue, i.e. schedule_work() and friends?  At
> your current review-cmwq head, they use system_wq, not system_nrt_wq.
> But doesn't have the present global workqueue WQ_NON_REENTRANT
> semantics?  In fact, don't have _all_ workqueues WQ_NON_REENTRANT
> semantics presently?  If so, a good deal of existing users probably
> relies on non-reentrant behaviour.  Or am I thoroughly misunderstanding
> the meaning of WQ_NON_REENTRANT?

Yeah, it's a bit confusing. :-( The current workqueue semantics is
non-reentrant on the same cpu but reentrant on different cpus.
WQ_NON_REENTRANT is non-reentrant regardless of cpu, so it's stronger
guarantee than before.  To summarize,

 current MT == !WQ_NON_REENTRANT < WQ_NON_REENTRANT <
	WQ_SINGLE_CPU < current ST == WQ_SINGLE_CPU + max in_flight of 1.

> (Sorry if this had been discussed before; I followed the discussions of
> some of your previous submissions but not all.  And PS, I am eagerly
> awaiting for this to go into the mainline.)

Ah, yeah, after ten month, I'm pretty eager too.  :-)

Thanks.

-- 
tejun
