Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1EFHkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:40:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:52856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1EFHkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:40:31 -0400
Date: Fri, 6 May 2011 07:40:03 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Message-ID: <tip-4934a4d3d3fa775601a9f1b35cc0e2aa93f81355@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1304528026.15681.3.camel@localhost.localdomain>
References: <1304528026.15681.3.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Wrap the 'cfs_rq->nr_spread_over' field with CONFIG_SCHED_DEBUG
Git-Commit-ID: 4934a4d3d3fa775601a9f1b35cc0e2aa93f81355
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 May 2011 07:40:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4934a4d3d3fa775601a9f1b35cc0e2aa93f81355
Gitweb:     http://git.kernel.org/tip/4934a4d3d3fa775601a9f1b35cc0e2aa93f81355
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Wed, 4 May 2011 22:53:46 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 May 2011 09:04:19 +0200

sched: Wrap the 'cfs_rq->nr_spread_over' field with CONFIG_SCHED_DEBUG

cfs_rq->nr_spread_over is only used when CONFIG_SCHED_DEBUG is set.
So wrap it with CONFIG_SCHED_DEBUG.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1304528026.15681.3.camel@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f11a2a5..3d8a1b2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -328,7 +328,9 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr, *next, *last, *skip;
 
+#ifdef	CONFIG_SCHED_DEBUG
 	unsigned int nr_spread_over;
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
