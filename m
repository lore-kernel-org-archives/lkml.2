Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1BFTWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:05 -0500
Received: from www.tglx.de ([62.245.132.106]:45154 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab1BFTWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:03 -0500
Message-Id: <20110206192106.011224503@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 1/7] frv: Remove stale irq_chip.end
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

irq-mb93093.c even lacks an implementation, but nobody noticed that
it's broken since commit 88d6e1 in 2006.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/irq-mb93093.c |    1 -
 arch/frv/kernel/irq.c         |    6 ------
 2 files changed, 7 deletions(-)

Index: linux-next/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-next/arch/frv/kernel/irq-mb93093.c
@@ -73,7 +73,6 @@ static struct irq_chip frv_fpga_pic = {
 	.mask		= frv_fpga_mask,
 	.mask_ack	= frv_fpga_mask_ack,
 	.unmask		= frv_fpga_unmask,
-	.end		= frv_fpga_end,
 };
 
 /*
Index: linux-next/arch/frv/kernel/irq.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq.c
+++ linux-next/arch/frv/kernel/irq.c
@@ -118,18 +118,12 @@ static void frv_cpupic_unmask(unsigned i
 	__clr_MASK(irqlevel);
 }
 
-static void frv_cpupic_end(unsigned int irqlevel)
-{
-	__clr_MASK(irqlevel);
-}
-
 static struct irq_chip frv_cpu_pic = {
 	.name		= "cpu",
 	.ack		= frv_cpupic_ack,
 	.mask		= frv_cpupic_mask,
 	.mask_ack	= frv_cpupic_mask_ack,
 	.unmask		= frv_cpupic_unmask,
-	.end		= frv_cpupic_end,
 };
 
 /*


