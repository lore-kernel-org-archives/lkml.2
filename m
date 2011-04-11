Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1DKKtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:48305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab1DKKtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:49:14 -0400
Date: Mon, 11 Apr 2011 10:48:55 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Message-ID: <tip-f4ad9bd208c98f32a6f9136618e0b8bebe3fb370@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <1302238389.3981.92.camel@sli10-conroe>
References: <1302238389.3981.92.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Eliminate dead code from wakeup_gran()
Git-Commit-ID: f4ad9bd208c98f32a6f9136618e0b8bebe3fb370
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 10:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4ad9bd208c98f32a6f9136618e0b8bebe3fb370
Gitweb:     http://git.kernel.org/tip/f4ad9bd208c98f32a6f9136618e0b8bebe3fb370
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Fri, 8 Apr 2011 12:53:09 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 11:08:55 +0200

sched: Eliminate dead code from wakeup_gran()

calc_delta_fair() checks NICE_0_LOAD already, delete duplicate check.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/1302238389.3981.92.camel@sli10-conroe
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fa833a..4ee50f0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1789,10 +1789,7 @@ wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 	 * This is especially important for buddies when the leftmost
 	 * task is higher priority than the buddy.
 	 */
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		gran = calc_delta_fair(gran, se);
-
-	return gran;
+	return calc_delta_fair(gran, se);
 }
 
 /*
