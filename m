Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0FQBvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34337 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287Ab0FQBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
       akpm@linux-foundation.org, balbir@in.ibm.com, oleg@redhat.com
In-Reply-To: <201006092141.o59LfE9Z023291@imap1.linux-foundation.org>
References: <201006092141.o59LfE9Z023291@imap1.linux-foundation.org>
Message-Id: <20100617102831.FB69.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: protect dereferencing of task's comm
> has been added to the -mm tree.  Its filename is
>      oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
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
> Subject: oom: protect dereferencing of task's comm
> From: David Rientjes <rientjes@google.com>
> 
> Andrew notes that dereferencing task->comm is unsafe without holding
> task_lock(task).  That's true even when dealing with current, so all
> existing dereferences within the oom killer need to ensure they are
> holding task_lock() before doing so.
> 
> This avoids using get_task_comm() because we'd otherwise need to allocate
> a string of TASK_COMM_LEN on the stack (or add synchronization and use a
> global string) and we don't want to do that because page allocations, and
> thus the oom killer, can happen particularly deep in the stack.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



