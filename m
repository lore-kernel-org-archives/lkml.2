Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab0FQBzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:55:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34371 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab0FQBvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, rientjes@google.com
In-Reply-To: <201006081942.o58JgsrW021043@imap1.linux-foundation.org>
References: <201006081942.o58JgsrW021043@imap1.linux-foundation.org>
Message-Id: <20100617102026.FB57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: introduce find_lock_task_mm() to fix !mm false positives
> has been added to the -mm tree.  Its filename is
>      oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: oom: introduce find_lock_task_mm() to fix !mm false positives
> From: Oleg Nesterov <oleg@redhat.com>
> 
> Almost all ->mm == NULL checks in oom_kill.c are wrong.
> 
> The current code assumes that the task without ->mm has already released
> its memory and ignores the process.  However this is not necessarily true
> when this process is multithreaded, other live sub-threads can use this
> ->mm.
> 
> - Remove the "if (!p->mm)" check in select_bad_process(), it is
>   just wrong.
> 
> - Add the new helper, find_lock_task_mm(), which finds the live
>   thread which uses the memory and takes task_lock() to pin ->mm
> 
> - change oom_badness() to use this helper instead of just checking
>   ->mm != NULL.
> 
> - As David pointed out, select_bad_process() must never choose the
>   task without ->mm, but no matter what oom_badness() returns the
>   task can be chosen if nothing else has been found yet.
> 
>   Change oom_badness() to return int, change it to return -1 if
>   find_lock_task_mm() fails, and change select_bad_process() to
>   check points >= 0.
> 
> Note! This patch is not enough, we need more changes.
> 
> 	- oom_badness() was fixed, but oom_kill_task() still ignores
> 	  the task without ->mm
> 
> 	- oom_forkbomb_penalty() should use find_lock_task_mm() too,
> 	  and it also needs other changes to actually find the first
> 	  first-descendant children
> 
> This will be addressed later.
> 
> [kosaki.motohiro@jp.fujitsu.com: use in badness(), __oom_kill_task()]
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



