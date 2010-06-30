Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0F3QAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:00:11 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39948 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0F3QAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:00:07 -0400
Date: Wed, 30 Jun 2010 18:00:05 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, Kalle Valo <kalle.valo@iki.fi>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Ladislav Michl <ladis@linux-mips.org>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 19/33] Removing dead MACH_OMAP_H4_OTG
Message-ID: <9d4f00439829dfb8dae18a532e6d21094f2043e5.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MACH_OMAP_H4_OTG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap2/board-h4.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index ce4292b..85d7fb8 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -277,22 +277,6 @@ static struct omap_usb_config h4_usb_config __initdata = {
 	.pins[1]	= 4,
 #endif
 
-#ifdef	CONFIG_MACH_OMAP_H4_OTG
-	/* S1.10 ON -- USB OTG port
-	 * usb0 switched to Mini-AB port and isp1301 transceiver;
-	 * S2.POS3 = OFF, S2.POS4 = ON ... to allow battery charging
-	 */
-	.otg		= 1,
-	.pins[0]	= 4,
-#ifdef	CONFIG_USB_GADGET_OMAP
-	/* use OTG cable, or standard A-to-MiniB */
-	.hmc_mode	= 0x14,	/* 0:dev/otg 1:host 2:disable */
-#elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
-	/* use OTG cable, or NONSTANDARD (B-to-MiniB) */
-	.hmc_mode	= 0x11,	/* 0:host 1:host 2:disable */
-#endif	/* XX */
-
-#else
 	/* S1.10 OFF -- usb "download port"
 	 * usb0 switched to Mini-B port and isp1105 transceiver;
 	 * S2.POS3 = ON, S2.POS4 = OFF ... to enable battery charging
@@ -301,7 +285,6 @@ static struct omap_usb_config h4_usb_config __initdata = {
 	.pins[0]	= 3,
 /*	.hmc_mode	= 0x14,*/	/* 0:dev 1:host 2:disable */
 	.hmc_mode	= 0x00,		/* 0:dev|otg 1:disable 2:disable */
-#endif
 };
 
 static struct omap_board_config_kernel h4_config[] = {
-- 
1.7.0.4

