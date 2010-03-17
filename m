Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0CQKEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:04:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0CQKEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:04:02 -0400
Date: Wed, 17 Mar 2010 10:03:38 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100317090046.4C79.A69D9226@jp.fujitsu.com>
References: <20100317090046.4C79.A69D9226@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use proper type in sched_getaffinity()
Message-ID: <tip-8bc037fb89bb3104b9ae290d18c877624cd7d9cc@git.kernel.org>
Git-Commit-ID: 8bc037fb89bb3104b9ae290d18c877624cd7d9cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 10:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bc037fb89bb3104b9ae290d18c877624cd7d9cc
Gitweb:     http://git.kernel.org/tip/8bc037fb89bb3104b9ae290d18c877624cd7d9cc
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Wed, 17 Mar 2010 09:36:58 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 10:48:49 +0100

sched: Use proper type in sched_getaffinity()

Using the proper type fixes the following compiler warning:

  kernel/sched.c:4850: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: torvalds@linux-foundation.org
Cc: travis@sgi.com
Cc: peterz@infradead.org
Cc: drepper@redhat.com
Cc: rja@sgi.com
Cc: sharyath@in.ibm.com
Cc: steiner@sgi.com
LKML-Reference: <20100317090046.4C79.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 82975b5..49d2fa7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4912,7 +4912,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		int retlen = min(len, cpumask_size());
+		size_t retlen = min_t(size_t, len, cpumask_size());
 
 		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
