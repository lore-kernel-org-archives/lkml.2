Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1EXBpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:45:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58278 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1EXBpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:45:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0D93.5070005@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:44:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6204D.5020109@jp.fujitsu.com> <BANLkTinpX59NnwsJVQZNTgt_6X3DVK9WLg@mail.gmail.com>
In-Reply-To: <BANLkTinpX59NnwsJVQZNTgt_6X3DVK9WLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -176,33 +178,49 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>>          */
>>         points = get_mm_rss(p->mm) + p->mm->nr_ptes;
>>         points += get_mm_counter(p->mm, MM_SWAPENTS);
>> -
>> -       points *= 1000;
>> -       points /= totalpages;
>>         task_unlock(p);
>>
>>         /*
>>          * Root processes get 3% bonus, just like the __vm_enough_memory()
>>          * implementation used by LSMs.
>> +        *
>> +        * XXX: Too large bonus, example, if the system have tera-bytes memory..
>>          */
>
> Nitpick. I have no opposition about adding this comment.
> But strictly speaking, the comment isn't related to this patch.
> No biggie and it's up to you.  :)

ok, removed.

 From 3dda8863e5acdba7a714f0e7506fae931865c442 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:43:49 +0900
Subject: [PATCH] remove unrelated comments

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
  mm/oom_kill.c |    2 --
  1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ec075cc..b01fa64 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -184,8 +184,6 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
  	/*
  	 * Root processes get 3% bonus, just like the __vm_enough_memory()
  	 * implementation used by LSMs.
-	 *
-	 * XXX: Too large bonus, example, if the system have tera-bytes memory..
  	 */
  	if (protect_root && has_capability_noaudit(p, CAP_SYS_ADMIN)) {
  		if (points >= totalpages / 32)
-- 
1.7.3.1


