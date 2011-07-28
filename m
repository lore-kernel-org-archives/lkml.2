Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1G1Qof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:44:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39902 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab1G1Qod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:44:33 -0400
Subject: [PATCH] watchdog: NUMA affine kthreads
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 18:44:28 +0200
Message-ID: <1311871468.2346.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog kthreads can use kthread_create_on_node() to NUMA affine their
stack and task_struct.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/watchdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..14cabcd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -438,7 +438,8 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
-		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu),
+					   "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
 			if (!err) {


