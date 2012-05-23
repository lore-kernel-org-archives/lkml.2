Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318Ab2EWPhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:37:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223Ab2EWPhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:37:43 -0400
Date: Wed, 23 May 2012 08:37:27 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-63f82f66a208efe0f5f10ed5d0cd8d32c8dfd013@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120522145233.GA17419@elgon.mountain>
References: <20120522145233.GA17419@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Checking for NULL instead of IS_ERR()
Git-Commit-ID: 63f82f66a208efe0f5f10ed5d0cd8d32c8dfd013
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:37:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63f82f66a208efe0f5f10ed5d0cd8d32c8dfd013
Gitweb:     http://git.kernel.org/tip/63f82f66a208efe0f5f10ed5d0cd8d32c8dfd013
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 22 May 2012 17:52:34 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 23 May 2012 17:11:31 +0200

sched/numa: Checking for NULL instead of IS_ERR()

If mpol_new() is called with MPOL_BIND then it can't return a
NULL pointer.  We should be checking IS_ERR() here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120522145233.GA17419@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index de66256..25be2b1 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -1482,9 +1482,9 @@ SYSCALL_DEFINE4(numa_mbind, unsigned long, addr, unsigned long, len,
 
 	mask = nodemask_of_node(ng->numa_entity.node);
 	mpol = mpol_new(MPOL_BIND, 0, &mask);
-	if (!mpol) {
+	if (IS_ERR(mpol)) {
 		ng_put(ng);
-		return -ENOMEM;
+		return PTR_ERR(mpol);
 	}
 	mpol->flags |= MPOL_MF_LAZY;
 	mpol->numa_group = ng;
