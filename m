Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1LFUUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:20:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1LFUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:19:58 -0500
Date: Tue, 6 Dec 2011 12:19:32 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-abjah8ctq5qrjjtdiabe8lph@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix compile error for UP,!NOHZ
Git-Commit-ID: fdaabd800bdd60652a448994eeb77442180db6c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:19:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdaabd800bdd60652a448994eeb77442180db6c0
Gitweb:     http://git.kernel.org/tip/fdaabd800bdd60652a448994eeb77442180db6c0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 6 Dec 2011 12:47:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:18 +0100

sched: Fix compile error for UP,!NOHZ

Commit 69e1e811 ("sched, nohz: Track nr_busy_cpus in the
sched_group_power") messed up the static inline function definition.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/n/tip-abjah8ctq5qrjjtdiabe8lph@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 295666c..64527c4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -277,7 +277,7 @@ extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
-static inline void set_cpu_sd_state_idle(void);
+static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
 /*
