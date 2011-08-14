Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1HNPzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:55:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1HNPzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:55:35 -0400
Date: Sun, 14 Aug 2011 15:55:24 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <tip-18e5a45db30e0e338cdd663eda05a8288cc14fa5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1312394344-18815-1-git-send-email-dzickus@redhat.com>
References: <1312394344-18815-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Make the kthreads NUMA affine
Git-Commit-ID: 18e5a45db30e0e338cdd663eda05a8288cc14fa5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:55:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18e5a45db30e0e338cdd663eda05a8288cc14fa5
Gitweb:     http://git.kernel.org/tip/18e5a45db30e0e338cdd663eda05a8288cc14fa5
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Wed, 3 Aug 2011 13:59:04 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 11:53:06 +0200

watchdog: Make the kthreads NUMA affine

Watchdog kthreads can use kthread_create_on_node() to NUMA affine their
stack and task_struct.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312394344-18815-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..e952a13 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -438,7 +438,7 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
-		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
 			if (!err) {
