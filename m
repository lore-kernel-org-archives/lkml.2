Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2IHReb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:34:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43971 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:34:30 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 13:34:29 EDT
MIME-Version: 1.0
In-Reply-To: <CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
Date: Sun, 9 Sep 2012 01:34:29 +0800
Message-ID: <CACvQF50C+uGjPSn8y7JVcwK52T3Fj8vExgTMHLefbL_h5J97qQ@mail.gmail.com>
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
From: Lai Jiangshan <eag0628@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:27 AM, Lai Jiangshan <eag0628@gmail.com> wrote:
> On Sun, Sep 9, 2012 at 1:12 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> The patch set is based on 3b07e9ca26866697616097044f25fbe53dbab693 of wq.git
>>
>> Patch 1,2 are accepted. Patch 1 goes to 3.6. tj has a replacement goes
>> to 3.6 instead of Patch 2. so Patch2 will go to 3.7. Patch2 will need
>> to be rebased if the replacement is still in 3.7.
>> (tj, could you help me do the rebase if I don't need to respin the patchset
>> as V7 ?)
>>
>> Patch3,4 fix depletion problem, it is simple enough. it goes to 3.6.
>
> sorry.
> 3.6 is synchronous idles when we use tj's replacement for patch2.
> and maybe_rebind_manager() don't wait for idles rebind. so it can't go to 3.6.
>
> Choice1: also push Patch 2(async idle rebinding) to 3.6? thus patch 4
> can goto 3.6 too.
> Choice2: add workaroud and make patch4 and make it go to 3.6. (add some code.)
>

Sorry again. the above worry is incorrect.
maybe_rebind_manager() **DO** wait for idles rebind via
mutex_lock(manager_lock).
so it is safe to 3.6.

sorry. don't worry anything. I just think it without code.

Thanks
Lai

>
>>
>> Patch 5,6,7 are clean up. -> 3.7
>>
>>
>> Lai Jiangshan (7):
>>   workqueue: ensure the wq_worker_sleeping() see the right flags
>>   workqueue: async idle rebinding
>>   workqueue:  add manager pointer for worker_pool
>>   workqueue: fix idle worker depletion
>>   workqueue: rename manager_mutex to assoc_mutex
>>   workqueue: new day don't need WORKER_REBIND for busy rebinding
>>   workqueue: remove WORKER_REBIND
>>
>>  kernel/workqueue.c |  195 +++++++++++++++++++++++-----------------------------
>>  1 files changed, 85 insertions(+), 110 deletions(-)
>>
>> --
>> 1.7.4.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
