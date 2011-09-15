Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934745Ab1IOUKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934521Ab1IOUKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48899365"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, ysato@users.sourceforge.jp
Subject: [PATCH 03/27] Initconst section fixes for H8300
Date: Thu, 15 Sep 2011 13:09:30 -0700
Message-Id: <1316117394-21666-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: ysato@users.sourceforge.jp
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 arch/h8300/platform/h8300h/irq.c  |    4 ++--
 arch/h8300/platform/h8s/irq.c     |    4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index a2ae5e9..0a8b5cd 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -62,7 +62,7 @@ static struct irqaction itu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index ae0d381..462d9f58 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -57,7 +57,7 @@ static struct irqaction timer16_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 7a1533f..505f341 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -77,7 +77,7 @@ static struct irqaction timer8_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {8, 64, 8192};
+static const int __initconst divide_rate[] = {8, 64, 8192};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index 2193a2e..0350f62 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -66,7 +66,7 @@ static struct irqaction tpu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {
+static const int __initconst divide_rate[] = {
 #if CONFIG_H8300_TPU_CH == 0
 	1,4,16,64,0,0,0,0,
 #elif (CONFIG_H8300_TPU_CH == 1) || (CONFIG_H8300_TPU_CH == 5)
diff --git a/arch/h8300/platform/h8300h/irq.c b/arch/h8300/platform/h8300h/irq.c
index e977345..7a5aa87 100644
--- a/arch/h8300/platform/h8300h/irq.c
+++ b/arch/h8300/platform/h8300h/irq.c
@@ -14,14 +14,14 @@
 #include <asm/gpio.h>
 #include <asm/regs306x.h>
 
-const int __initdata h8300_saved_vectors[] = {
+const int __initconst h8300_saved_vectors[] = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRAP3_VEC,	/* TRAPA #3 is GDB breakpoint */
 #endif
 	-1,
 };
 
-const h8300_vector __initdata h8300_trap_table[] = {
+const h8300_vector __initconst h8300_trap_table[] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	system_call,
 	0,
diff --git a/arch/h8300/platform/h8s/irq.c b/arch/h8300/platform/h8s/irq.c
index 8182f04..6369ca9 100644
--- a/arch/h8300/platform/h8s/irq.c
+++ b/arch/h8300/platform/h8s/irq.c
@@ -18,7 +18,7 @@
 #include <asm/regs267x.h>
 
 /* saved vector list */
-const int __initdata h8300_saved_vectors[]={
+const int __initconst h8300_saved_vectors[]={
 #if defined(CONFIG_GDB_DEBUG)
 	TRACE_VEC,
 	TRAP3_VEC,
@@ -27,7 +27,7 @@ const int __initdata h8300_saved_vectors[]={
 };
 
 /* trap entry table */
-const H8300_VECTOR __initdata h8300_trap_table[] = {
+const H8300_VECTOR __initconst h8300_trap_table[] = {
 	0,0,0,0,0,
 	trace_break,  /* TRACE */
 	0,0,
-- 
1.7.4.4

