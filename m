Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1GWPvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:51:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:36333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1GWPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:51:40 -0400
Message-Id: <20110723154916.391682000@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 23 Jul 2011 15:51:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Javier Herrero <jherrero@hvsistemas.es>
Subject: [patch] blackfin: Fixup bogus ioresource init
Content-Disposition: inline;
 filename=blackfin-fixup-bogus-ioresource-init.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_SHARED is not part of the IORESOURCE_IRQ bits. It's expressed by
IORESOURCE_IRQ_SHAREABLE.

IORESOURCE_IRQ_HIGHEDGE and IRQF_TRIGGER_HIGH are contradicting
values, an interrupt can hardly be configured for both level and edge
at the same time. This was introduced in commit 45138439(Blackfin
arch: flash memory map and dm9000 resources updating) of course
without any hint in the changelog what the heck this is supposed to
do.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Javier Herrero <jherrero@hvsistemas.es>
---
 arch/blackfin/mach-bf533/boards/H8606.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/blackfin/mach-bf533/boards/H8606.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf533/boards/H8606.c
+++ linux-2.6/arch/blackfin/mach-bf533/boards/H8606.c
@@ -54,7 +54,8 @@ static struct resource dm9000_resources[
 	[2] = {
 		.start	= IRQ_PF10,
 		.end	= IRQ_PF10,
-		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE | IRQF_SHARED | IRQF_TRIGGER_HIGH),
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE |
+			   | IORESOURCE_IRQ_SHAREABLE),
 	},
 };
 


