Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2BXLua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:50:30 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43585 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab2BXLu3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 24 Feb 2012 06:50:29 -0500
Message-Id: <4F4787930200007800074A10@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 11:50:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: eliminate unused irq0_irqs counter
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of 2.6.38 this counter is being maintained without ever being read.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/hardirq.h |    1 -
 arch/x86/kernel/time.c         |    3 ---
 2 files changed, 4 deletions(-)

--- 3.3-rc4/arch/x86/include/asm/hardirq.h
+++ 3.3-rc4-x86-no-irq0_irqs/arch/x86/include/asm/hardirq.h
@@ -7,7 +7,6 @@
 typedef struct {
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int irq0_irqs;
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
--- 3.3-rc4/arch/x86/kernel/time.c
+++ 3.3-rc4-x86-no-irq0_irqs/arch/x86/kernel/time.c
@@ -57,9 +57,6 @@ EXPORT_SYMBOL(profile_pc);
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	/* Keep nmi watchdog up to date */
-	inc_irq_stat(irq0_irqs);
-
 	global_clock_event->event_handler(global_clock_event);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */



