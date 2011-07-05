Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1GEQEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:04:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56772 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1GEQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:04:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 1/3] m32r: Use generic PREEMPT config
Date: Tue,  5 Jul 2011 18:04:26 +0200
Message-Id: <1309881868-9483-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
References: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic preempt config definition in m32r instead of
using a custom one.

This also makes it handle the new CONFIG_PREEMPT_COUNT that
need to be selected by CONFIG_PREEMPT.

Without that it breaks

  kernel/sched.c: In function 'preempt_schedule':
  kernel/sched.c:4364: error: implicit declaration of function 'add_preempt_count_notrace'
  kernel/sched.c:4366: error: implicit declaration of function 'sub_preempt_count_notrace'

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/Kconfig |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 85b44e8..b92b944 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -268,17 +268,7 @@ config SCHED_OMIT_FRAME_POINTER
         bool
         default y
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
-
-	  Say Y here if you are building a kernel for a desktop, embedded
-	  or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 config SMP
 	bool "Symmetric multi-processing support"
-- 
1.7.5.4

