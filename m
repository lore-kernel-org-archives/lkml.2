Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1JPK5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:57:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1JPK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:57:04 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH -rt 1/5] hotplug: sync_unplug: No '\n' in task name
Date: Sun, 16 Oct 2011 18:56:43 +0800
Message-Id: <1318762607-2261-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the output will look a little odd.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5f2382a..83fb084 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -139,7 +139,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	struct task_struct *tsk;
 
 	init_completion(&hp->synced);
-	tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d\n", cpu);
+	tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
 	if (IS_ERR(tsk))
 		return (PTR_ERR(tsk));
 	kthread_bind(tsk, cpu);
-- 
1.7.1

