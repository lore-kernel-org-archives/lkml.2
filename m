Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab2KOXQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:16:48 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1456 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2KOXQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:16:47 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Al Cooper" <alcooperx@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, cernekee@gmail.com
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH] MIPS: Fix crash that occurs when function tracing is
 enabled
Date: Thu, 15 Nov 2012 18:16:14 -0500
Message-ID: <1353021374-3311-1-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
X-WSS-ID: 7CBBA96B3P83507328-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch changed some irq routines from inlines to functions.
These routines are called by the tracer code. Now that they're functions,
if they are compiled for function tracing they will call the tracer
and crash the system due to infinite recursion. The fix disables
tracing in these functions by using "notrace" in the function
definition.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 arch/mips/lib/mips-atomic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lib/mips-atomic.c b/arch/mips/lib/mips-atomic.c
index e091430..cd160be 100644
--- a/arch/mips/lib/mips-atomic.c
+++ b/arch/mips/lib/mips-atomic.c
@@ -56,7 +56,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-void arch_local_irq_disable(void)
+notrace void arch_local_irq_disable(void)
 {
 	preempt_disable();
 	__asm__ __volatile__(
@@ -93,7 +93,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-unsigned long arch_local_irq_save(void)
+notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	preempt_disable();
@@ -135,7 +135,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-void arch_local_irq_restore(unsigned long flags)
+notrace void arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
@@ -159,7 +159,7 @@ void arch_local_irq_restore(unsigned long flags)
 EXPORT_SYMBOL(arch_local_irq_restore);
 
 
-void __arch_local_irq_restore(unsigned long flags)
+notrace void __arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
-- 
1.7.6


