Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1EDOaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:30:09 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43185 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1EDOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:30:07 -0400
Date: Wed, 4 May 2011 16:30:03 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k/atari: Do not use "/" in interrupt names
Message-ID: <alpine.DEB.2.00.1105041629390.2629@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may trigger a warning in fs/proc/generic.c:__xlate_proc_name() when
trying to add an entry for the interrupt handler to sysfs.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c |    2 +-
 arch/m68k/atari/stdma.c   |    2 +-
 drivers/net/atarilance.c  |    2 +-
 drivers/video/atafb.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index e1ada31..779efdc 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -572,7 +572,7 @@ int atari_keyb_init(void)
 	kb_state.len = 0;
 
 	error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt,
-			    IRQ_TYPE_SLOW, "keyboard/mouse/MIDI",
+			    IRQ_TYPE_SLOW, "keyboard:mouse:MIDI",
 			    atari_keyboard_interrupt);
 	if (error)
 		return error;
diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
index 604329f..ad68fe9 100644
--- a/arch/m68k/atari/stdma.c
+++ b/arch/m68k/atari/stdma.c
@@ -180,7 +180,7 @@ void __init stdma_init(void)
 {
 	stdma_isr = NULL;
 	if (request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | IRQF_SHARED,
-			"ST-DMA: floppy/ACSI/IDE/Falcon-SCSI", stdma_int))
+			"ST-DMA floppy:ACSI:IDE:Falcon-SCSI", stdma_int))
 		pr_err("Couldn't register ST-DMA interrupt\n");
 }
 
diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index ce0091e..1833b12 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -554,7 +554,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		memaddr == (unsigned short *)0xffe00000) {
 		/* PAMs card and Riebl on ST use level 5 autovector */
 		if (request_irq(IRQ_AUTO_5, lance_interrupt, IRQ_TYPE_PRIO,
-		            "PAM/Riebl-ST Ethernet", dev)) {
+		            "PAM:Riebl-ST Ethernet", dev)) {
 			printk( "Lance: request for irq %d failed\n", IRQ_AUTO_5 );
 			return 0;
 		}
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 5b2b5ef..64e41f5 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3117,7 +3117,7 @@ int __init atafb_init(void)
 			atafb_ops.fb_setcolreg = &falcon_setcolreg;
 			error = request_irq(IRQ_AUTO_4, falcon_vbl_switcher,
 					    IRQ_TYPE_PRIO,
-					    "framebuffer/modeswitch",
+					    "framebuffer:modeswitch",
 					    falcon_vbl_switcher);
 			if (error)
 				return error;
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
