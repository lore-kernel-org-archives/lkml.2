Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab2EQKLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:11:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509Ab2EQKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:44 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with irq disabled
Date: Thu, 17 May 2012 18:10:08 +0800
Message-Id: <1337249410-7162-7-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prevent a problem as commit 5fbd036b && 2baab4e9 try to resolve,
move set_cpu_online() to the uping CPU and with irq disabled.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/mips/kernel/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 73a268a..042145f 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -122,6 +122,8 @@ asmlinkage __cpuinit void start_secondary(void)
 
 	notify_cpu_starting(cpu);
 
+	set_cpu_online(cpu, true);
+
 	set_cpu_sibling_map(cpu);
 
 	cpu_set(cpu, cpu_callin_map);
@@ -249,8 +251,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	while (!cpu_isset(cpu, cpu_callin_map))
 		udelay(100);
 
-	set_cpu_online(cpu, true);
-
 	return 0;
 }
 
-- 
1.7.1

