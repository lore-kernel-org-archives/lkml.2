Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1HNQBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:01:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1HNQBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:01:03 -0400
Date: Sun, 14 Aug 2011 16:00:47 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-0835471697255b415edcefd6b1e25b6c034439f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <BANLkTimT+Tut-3TshCDm-NiLLXrOznibNA@mail.gmail.com>
References: <BANLkTimT+Tut-3TshCDm-NiLLXrOznibNA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove noop in lowest_flag_domain()
Git-Commit-ID: 0835471697255b415edcefd6b1e25b6c034439f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:00:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0835471697255b415edcefd6b1e25b6c034439f2
Gitweb:     http://git.kernel.org/tip/0835471697255b415edcefd6b1e25b6c034439f2
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 16 Jun 2011 21:55:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:46 +0200

sched: Remove noop in lowest_flag_domain()

Checking for the validity of sd is removed, since it is already
checked by the for_each_domain macro.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTimT+Tut-3TshCDm-NiLLXrOznibNA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 241fc86..f4b732a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3660,7 +3660,7 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 	struct sched_domain *sd;
 
 	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
+		if (sd->flags & flag)
 			break;
 
 	return sd;
