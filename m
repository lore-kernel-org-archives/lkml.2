Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1GEQEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:04:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52178 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab1GEQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:04:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 3/3] xtensa: Use generic config PREEMPT definition
Date: Tue,  5 Jul 2011 18:04:28 +0200
Message-Id: <1309881868-9483-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
References: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can handle the new CONFIG_PREEMPT_COUNT.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/Kconfig |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 5d43c1f..c346ccd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -80,18 +80,7 @@ config XTENSA_UNALIGNED_USER
 
 	  Say Y here to enable unaligned memory access in user space.
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-          This option reduces the latency of the kernel when reacting to
-          real-time or interactive events by allowing a low priority process to
-          be preempted even if it is in kernel mode executing a system call.
-          Unfortunately the kernel code has some race conditions if both
-          CONFIG_SMP and CONFIG_PREEMPT are enabled, so this option is
-          currently disabled if you are building an SMP kernel.
-
-          Say Y here if you are building a kernel for a desktop, embedded
-          or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 config MATH_EMULATION
 	bool "Math emulation"
-- 
1.7.5.4

