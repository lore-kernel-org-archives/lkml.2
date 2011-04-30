Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1D3HQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 03:16:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1D3HQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 03:16:20 -0400
Date: Sat, 30 Apr 2011 07:16:01 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Message-ID: <tip-eea502ffd4aeef233b5eadbde405a9df92d57a5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1304100062.19359.6.camel@localhost.localdomain>
References: <1304100062.19359.6.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use bool type for rq->idle_at_tick
Git-Commit-ID: eea502ffd4aeef233b5eadbde405a9df92d57a5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Apr 2011 07:16:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eea502ffd4aeef233b5eadbde405a9df92d57a5e
Gitweb:     http://git.kernel.org/tip/eea502ffd4aeef233b5eadbde405a9df92d57a5e
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sat, 30 Apr 2011 00:01:02 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 Apr 2011 00:17:14 +0200

sched: Use bool type for rq->idle_at_tick

Searching over the scheduler code for uses of rq->idle_at_tick
shows us that it's used for making TRUE/FALSE decision.

Still its type is 'unsigned char' so using 'bool' would be
cleaner.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1304100062.19359.6.camel@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f11a2a5..a492209 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -505,7 +505,7 @@ struct rq {
 
 	unsigned long cpu_power;
 
-	unsigned char idle_at_tick;
+	bool idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
 	int active_balance;
