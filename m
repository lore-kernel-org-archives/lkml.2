Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1AGPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:36:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:40825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1AGPgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:36:50 -0500
Date: Fri, 7 Jan 2011 15:36:28 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1294222285.8369.2.camel@marge.simson.net>
References: <1294222285.8369.2.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix struct autogroup memory leak
Message-ID: <tip-e9aa1dd19fe49b5aed3ca94aab87576e534d2a39@git.kernel.org>
Git-Commit-ID: e9aa1dd19fe49b5aed3ca94aab87576e534d2a39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:36:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9aa1dd19fe49b5aed3ca94aab87576e534d2a39
Gitweb:     http://git.kernel.org/tip/e9aa1dd19fe49b5aed3ca94aab87576e534d2a39
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 5 Jan 2011 11:11:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:54:37 +0100

sched: Fix struct autogroup memory leak

Seems I lost a change somewhere, leaking memory.

sched: fix struct autogroup memory leak

Add missing change to actually use autogroup_free().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294222285.8369.2.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 54b58ec..a8478a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8377,6 +8377,7 @@ static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	autogroup_free(tg);
 	kfree(tg);
 }
 
