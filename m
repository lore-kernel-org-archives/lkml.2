Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0CQAhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 20:37:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50973 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0CQAhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 20:37:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/urgent] sched: sched_getaffinity(): Allow less than NR_CPUS length
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       travis@sgi.com, peterz@infradead.org, drepper@redhat.com, rja@sgi.com,
       sharyath@in.ibm.com, akpm@linux-foundation.org, steiner@sgi.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100316171034.GA17211@elte.hu>
References: <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org> <20100316171034.GA17211@elte.hu>
Message-Id: <20100317090046.4C79.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 09:36:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Commit-ID:  cd3d8031eb4311e516329aee03c79a08333141f1
> > Gitweb:     http://git.kernel.org/tip/cd3d8031eb4311e516329aee03c79a08333141f1
> > Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > AuthorDate: Fri, 12 Mar 2010 16:15:36 +0900
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 15 Mar 2010 08:28:44 +0100
> > 
> > sched: sched_getaffinity(): Allow less than NR_CPUS length
> 
> > +		int retlen = min(len, cpumask_size());
> 
> this one causes:
> 
> kernel/sched.c:4850: warning: comparison of distinct pointer types lacks a cast

Ahh, I'm sorry. attached fixing patch.

thanks.


============================
Subject: [PATCH] fix warning

fix following warning.

kernel/sched.c:4850: warning: comparison of distinct pointer types lacks
a cast

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 34217f1..d1d5acd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4912,7 +4912,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		int retlen = min(len, cpumask_size());
+		size_t retlen = min_t(size_t, len, cpumask_size());
 
 		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
-- 
1.6.5.2



