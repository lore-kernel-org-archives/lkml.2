Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab2C2VNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:13:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33748 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab2C2VMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:54 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 09/17] h8300: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:26 +0200
Message-Id: <1333055554-31300-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 arch/h8300/platform/h8300h/irq.c  |    4 ++--
 arch/h8300/platform/h8s/irq.c     |    4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index a2ae5e9..2ab0e42 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -62,7 +62,7 @@ static struct irqaction itu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int divide_rate[] __initconst = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index ae0d381..78f6843 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -57,7 +57,7 @@ static struct irqaction timer16_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int divide_rate[] __initconst = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 7a1533f..ea4eb8d 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -77,7 +77,7 @@ static struct irqaction timer8_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {8, 64, 8192};
+static const int divide_rate[] __initconst = {8, 64, 8192};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index 2193a2e..eec62d8 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -66,7 +66,7 @@ static struct irqaction tpu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {
+static const int divide_rate[] __initconst = {
 #if CONFIG_H8300_TPU_CH == 0
 	1,4,16,64,0,0,0,0,
 #elif (CONFIG_H8300_TPU_CH == 1) || (CONFIG_H8300_TPU_CH == 5)
diff --git a/arch/h8300/platform/h8300h/irq.c b/arch/h8300/platform/h8300h/irq.c
index bc4f51b..a80e1a1 100644
--- a/arch/h8300/platform/h8300h/irq.c
+++ b/arch/h8300/platform/h8300h/irq.c
@@ -14,14 +14,14 @@
 #include <asm/gpio-internal.h>
 #include <asm/regs306x.h>
 
-const int __initdata h8300_saved_vectors[] = {
+const int h8300_saved_vectors[] __initconst = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRAP3_VEC,	/* TRAPA #3 is GDB breakpoint */
 #endif
 	-1,
 };
 
-const h8300_vector __initdata h8300_trap_table[] = {
+const h8300_vector h8300_trap_table[] __initconst = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	system_call,
 	0,
diff --git a/arch/h8300/platform/h8s/irq.c b/arch/h8300/platform/h8s/irq.c
index 7b5f29f..362b191 100644
--- a/arch/h8300/platform/h8s/irq.c
+++ b/arch/h8300/platform/h8s/irq.c
@@ -18,7 +18,7 @@
 #include <asm/regs267x.h>
 
 /* saved vector list */
-const int __initdata h8300_saved_vectors[]={
+const int h8300_saved_vectors[] __initconst = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRACE_VEC,
 	TRAP3_VEC,
@@ -27,7 +27,7 @@ const int __initdata h8300_saved_vectors[]={
 };
 
 /* trap entry table */
-const H8300_VECTOR __initdata h8300_trap_table[] = {
+const H8300_VECTOR h8300_trap_table[] __initconst = {
 	0,0,0,0,0,
 	trace_break,  /* TRACE */
 	0,0,
-- 
1.7.9.1

