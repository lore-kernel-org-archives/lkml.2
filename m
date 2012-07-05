Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2GEMbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:31:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44057 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2GEMbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:31:31 -0400
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 20:31:30 +0800
Message-ID: <CAJd=RBDx7Hwd1fjnGEdFny2XNHmvjRGQkCJySYK5+vfSfRFbrg@mail.gmail.com>
Subject: [patch] BFS 421-1: fix selecting CPU for migrating nohz timer
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bail out walking the hierarchy of schedule domain only if a busy CPU
is discovered.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Thu Jul  5 20:12:06 2012
+++ b/kernel/sched/bfs.c	Thu Jul  5 20:12:50 2012
@@ -4937,9 +4937,10 @@ int get_nohz_timer_target(void)
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		for_each_cpu(i, sched_domain_span(sd)) {
-			if (!idle_cpu(i))
+			if (!idle_cpu(i)) {
 				cpu = i;
-			goto unlock;
+				goto unlock;
+			}
 		}
 	}
 unlock:
--
