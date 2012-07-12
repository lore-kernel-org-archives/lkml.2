Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2GLXnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:43:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab2GLWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 044/187] powerpc: Fix build of some debug irq code
Date: Thu, 12 Jul 2012 15:33:20 -0700
Message-Id: <20120712191526.424092774@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 21b2de341270bd7bb7a811027ffe63276d9b3b75 upstream.

There was a typo, checking for CONFIG_TRACE_IRQFLAG instead of
CONFIG_TRACE_IRQFLAGS causing some useful debug code to not be
built

This in turns causes a build error on BookE 64-bit due to incorrect
semicolons at the end of a couple of macros, so let's fix that too

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/hw_irq.h |    4 ++--
 arch/powerpc/kernel/irq.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -85,8 +85,8 @@ static inline bool arch_irqs_disabled(vo
 }
 
 #ifdef CONFIG_PPC_BOOK3E
-#define __hard_irq_enable()	asm volatile("wrteei 1" : : : "memory");
-#define __hard_irq_disable()	asm volatile("wrteei 0" : : : "memory");
+#define __hard_irq_enable()	asm volatile("wrteei 1" : : : "memory")
+#define __hard_irq_disable()	asm volatile("wrteei 0" : : : "memory")
 #else
 #define __hard_irq_enable()	__mtmsrd(local_paca->kernel_msr | MSR_EE, 1)
 #define __hard_irq_disable()	__mtmsrd(local_paca->kernel_msr, 1)
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -229,7 +229,7 @@ notrace void arch_local_irq_restore(unsi
 	 */
 	if (unlikely(irq_happened != PACA_IRQ_HARD_DIS))
 		__hard_irq_disable();
-#ifdef CONFIG_TRACE_IRQFLAG
+#ifdef CONFIG_TRACE_IRQFLAGS
 	else {
 		/*
 		 * We should already be hard disabled here. We had bugs


