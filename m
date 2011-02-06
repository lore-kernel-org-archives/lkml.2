Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1BFVq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:26 -0500
Received: from www.tglx.de ([62.245.132.106]:45938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab1BFVqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:46:03 -0500
Message-Id: <20110206214534.762044156@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 4/7] mn10300: Convert serial irq_chip to new functions
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-convert-serial-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/mn10300-serial.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-next/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-next.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-next/arch/mn10300/kernel/mn10300-serial.c
@@ -384,16 +384,21 @@ static void mn10300_serial_mask_ack(unsi
 	arch_local_irq_restore(flags);
 }
 
-static void mn10300_serial_nop(unsigned int irq)
+static void mn10300_serial_chip_mask_ack(struct irq_data *d)
+{
+	mn10300_serial_mask_ack(d->irq);
+}
+
+static void mn10300_serial_nop(struct irq_data *d
 {
 }
 
 static struct irq_chip mn10300_serial_pic = {
 	.name		= "mnserial",
-	.ack		= mn10300_serial_mask_ack,
-	.mask		= mn10300_serial_mask_ack,
-	.mask_ack	= mn10300_serial_mask_ack,
-	.unmask		= mn10300_serial_nop,
+	.irq_ack	= mn10300_serial_chip_mask_ack,
+	.irq_mask	= mn10300_serial_chip_mask_ack,
+	.irq_mask_ack	= mn10300_serial_chip_mask_ack,
+	.irq_unmask	= mn10300_serial_nop,
 };
 
 


