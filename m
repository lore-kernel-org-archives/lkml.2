Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1AGEoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:44:02 -0500
Received: from mail.windriver.com ([147.11.1.11]:38966 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1AGEoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:44:00 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH] sched: mark autogroup_init() __init
Date: Fri,  7 Jan 2011 12:43:45 +0800
Message-Id: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 07 Jan 2011 04:43:48.0178 (UTC) FILETIME=[79450320:01CBAE25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autogroup_init() is only called at boot time.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_autogroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index ff6c88c..b367941 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -9,7 +9,7 @@ unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
 static struct autogroup autogroup_default;
 static atomic_t autogroup_seq_nr;
 
-static void autogroup_init(struct task_struct *init_task)
+static void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &init_task_group;
 	init_task_group.autogroup = &autogroup_default;
-- 
1.7.0.4

