Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1DKOjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:39:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:54559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1DKOjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:39:04 -0400
Date: Mon, 11 Apr 2011 14:38:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-a6c75f2f8d988ecfecf971f98f1cb6fc4de522fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.350174079@chello.nl>
References: <20110407122942.350174079@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Avoid using sd->level
Git-Commit-ID: a6c75f2f8d988ecfecf971f98f1cb6fc4de522fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:38:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6c75f2f8d988ecfecf971f98f1cb6fc4de522fe
Gitweb:     http://git.kernel.org/tip/a6c75f2f8d988ecfecf971f98f1cb6fc4de522fe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:20 +0200

sched: Avoid using sd->level

Don't use sd->level for identifying properties of the domain.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.350174079@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4a8ac7c..9c5679c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2651,7 +2651,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
 	 */
-	if (sd->level != SD_LV_SIBLING)
+	if (!(sd->flags & SD_SHARE_CPUPOWER))
 		return 0;
 
 	/*
