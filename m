Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab2EPCjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:39:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52026 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab2EPCjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:39:18 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v4 1/7] ARM: imx: Modify IMX_IO_P2V macro
Date: Tue, 15 May 2012 21:33:30 -0500
Message-Id: <1337135616-8988-2-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change is needed in the IMX_IO_P2V macro to allow all imx5 platforms
to use common definitions when accessing registers of peripherals on
the AIPS2 bus.  With this change, IMX_IO_P2V(MX50_AIPS2_BASE_ADDR) ==
IMX_IO_P2V(MX51_AIPS2_BASE_ADDR) == IMX_IO_P2V(MX53_AIPS2_BASE_ADDR).

This change was tested for mapping conflicts using the iop2v script
found at git://git.pengutronix.de/git/ukl/imx-iop2v.git and by
performing a bootup of a default build using imx_v6_v7_defconfig
on a imx51 babbage board and imx53 loco board.  The comments were
modified to reflect the output given by the script which shows the
virtual address mappings.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/plat-mxc/include/mach/hardware.h |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/hardware.h b/arch/arm/plat-mxc/include/mach/hardware.h
index 0630513..071afd0 100644
--- a/arch/arm/plat-mxc/include/mach/hardware.h
+++ b/arch/arm/plat-mxc/include/mach/hardware.h
@@ -50,7 +50,7 @@
  *	IO	0x00200000+0x100000	->	0xf4000000+0x100000
  * mx21:
  *	AIPI	0x10000000+0x100000	->	0xf4400000+0x100000
- *	SAHB1	0x80000000+0x100000	->	0xf4000000+0x100000
+ *	SAHB1	0x80000000+0x100000	->	0xf5000000+0x100000
  *	X_MEMC	0xdf000000+0x004000	->	0xf5f00000+0x004000
  * mx25:
  *	AIPS1	0x43f00000+0x100000	->	0xf5300000+0x100000
@@ -58,47 +58,50 @@
  *	AVIC	0x68000000+0x100000	->	0xf5800000+0x100000
  * mx27:
  *	AIPI	0x10000000+0x100000	->	0xf4400000+0x100000
- *	SAHB1	0x80000000+0x100000	->	0xf4000000+0x100000
+ *	SAHB1	0x80000000+0x100000	->	0xf5000000+0x100000
  *	X_MEMC	0xd8000000+0x100000	->	0xf5c00000+0x100000
  * mx31:
  *	AIPS1	0x43f00000+0x100000	->	0xf5300000+0x100000
  *	AIPS2	0x53f00000+0x100000	->	0xf5700000+0x100000
  *	AVIC	0x68000000+0x100000	->	0xf5800000+0x100000
- *	X_MEMC	0xb8000000+0x010000	->	0xf4c00000+0x010000
+ *	X_MEMC	0xb8000000+0x010000	->	0xf5c00000+0x010000
  *	SPBA0	0x50000000+0x100000	->	0xf5400000+0x100000
  * mx35:
  *	AIPS1	0x43f00000+0x100000	->	0xf5300000+0x100000
  *	AIPS2	0x53f00000+0x100000	->	0xf5700000+0x100000
  *	AVIC	0x68000000+0x100000	->	0xf5800000+0x100000
- *	X_MEMC	0xb8000000+0x010000	->	0xf4c00000+0x010000
+ *	X_MEMC	0xb8000000+0x010000	->	0xf5c00000+0x010000
  *	SPBA0	0x50000000+0x100000	->	0xf5400000+0x100000
  * mx50:
  *	TZIC	0x0fffc000+0x004000	->	0xf4bfc000+0x004000
- *	SPBA0	0x50000000+0x100000	->	0xf5400000+0x100000
  *	AIPS1	0x53f00000+0x100000	->	0xf5700000+0x100000
+ *	SPBA0	0x50000000+0x100000	->	0xf5400000+0x100000
  *	AIPS2	0x63f00000+0x100000	->	0xf5300000+0x100000
  * mx51:
- *	TZIC	0xe0000000+0x004000	->	0xf5000000+0x004000
+ *	TZIC	0x0fffc000+0x004000	->	0xf4bfc000+0x004000
  *	IRAM	0x1ffe0000+0x020000	->	0xf4fe0000+0x020000
+ *	DEBUG	0x60000000+0x100000	->	0xf5000000+0x100000
  *	SPBA0	0x70000000+0x100000	->	0xf5400000+0x100000
  *	AIPS1	0x73f00000+0x100000	->	0xf5700000+0x100000
- *	AIPS2	0x83f00000+0x100000	->	0xf4300000+0x100000
+ *	AIPS2	0x83f00000+0x100000	->	0xf5300000+0x100000
  * mx53:
  *	TZIC	0x0fffc000+0x004000	->	0xf4bfc000+0x004000
+ *	DEBUG	0x40000000+0x100000	->	0xf5000000+0x100000
  *	SPBA0	0x50000000+0x100000	->	0xf5400000+0x100000
  *	AIPS1	0x53f00000+0x100000	->	0xf5700000+0x100000
  *	AIPS2	0x63f00000+0x100000	->	0xf5300000+0x100000
  * mx6q:
- *	SCU	0x00a00000+0x001000	->	0xf4000000+0x001000
+ *	SCU	0x00a00000+0x004000	->	0xf4000000+0x004000
  *	CCM	0x020c4000+0x004000	->	0xf42c4000+0x004000
- *	ANATOP	0x020c8000+0x001000	->	0xf42c8000+0x001000
+ *	ANATOP	0x020c8000+0x004000	->	0xf42c8000+0x004000
  *	UART4	0x021f0000+0x004000	->	0xf42f0000+0x004000
  */
 #define IMX_IO_P2V(x)	(						\
-			0xf4000000 +					\
+			(((x) & 0x80000000) >> 7) |			\
+			(0xf4000000 +					\
 			(((x) & 0x50000000) >> 6) +			\
 			(((x) & 0x0b000000) >> 4) +			\
-			(((x) & 0x000fffff)))
+			(((x) & 0x000fffff))))
 
 #define IMX_IO_ADDRESS(x)	IOMEM(IMX_IO_P2V(x))
 
-- 
1.7.10

