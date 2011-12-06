Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab1LFJxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:53:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab1LFJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:52:59 -0500
Date: Tue, 6 Dec 2011 01:52:42 -0800
From: tip-bot for Shan Hai <haishan.bai@gmail.com>
Message-ID: <tip-5b680fd61388abb9059fbc8e7a2f60f602bfce15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, haishan.bai@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, haishan.bai@gmail.com, mingo@elte.hu
In-Reply-To: <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
References: <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Code cleanup, remove a redundant function call
Git-Commit-ID: 5b680fd61388abb9059fbc8e7a2f60f602bfce15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:52:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b680fd61388abb9059fbc8e7a2f60f602bfce15
Gitweb:     http://git.kernel.org/tip/5b680fd61388abb9059fbc8e7a2f60f602bfce15
Author:     Shan Hai <haishan.bai@gmail.com>
AuthorDate: Tue, 29 Nov 2011 11:03:56 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:28 +0100

sched/rt: Code cleanup, remove a redundant function call

The second call to sched_rt_period() is redundant, because the value of the
rt_runtime was already read and it was protected by the ->rt_runtime_lock.

Signed-off-by: Shan Hai <haishan.bai@gmail.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322535836-13590-2-git-send-email-haishan.bai@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 58a4844..3640ebb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -846,7 +846,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
-	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
+	if (runtime >= sched_rt_period(rt_rq))
 		return 0;
 
 	balance_runtime(rt_rq);
