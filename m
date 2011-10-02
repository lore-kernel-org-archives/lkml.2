Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1JBOtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1JBOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/30] ARM: omap2: irq.c is always needed
Date: Sun,  2 Oct 2011 16:45:44 +0200
Message-Id: <1317566760-25681-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tINGx7U57dm5kVbxKD0hx//WW/tOQVqQeTIzJgmhdV+
 AlIjv4ai5MOaNg1stDFFexAcoVE7dvWxXj0t12H5/PZfNnAc2r
 uPMoYUGYTRoCsx8U4ISqFtj91PWk76+0GRZvDY07ySMuHBo8bK
 tx//dmcZ/RYcEEVtQGkli8z8OnXEUs08gY7DCFu2Dovy7wyHj0
 CdGWIsY4ZbNwOer48I2k0UzrxEL8MbsAcggvTmnLU6UZmmYIde
 zWtmQnObkaJGmu+PvKyNaAObJmltt53zFTf9fY08e5o33kE28Z
 GueMzrloIwp4JcVE1bx4LAbYVjKKNmMddK1lcW8L6st2TITmYB
 06cNNsBSocl3JBOt6KroSRBqsqNGmqoAj8KIQ7MU+A8aF8XIFD
 /8xEF4rGFSEXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile only includes irq.o for omap2 and omap3, but it's in
fact also required to build omap4-only kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index dc36bd4..f14549d 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -4,9 +4,9 @@
 
 # Common support
 obj-y := id.o io.o control.o mux.o devices.o serial.o gpmc.o timer.o pm.o \
-	 common.o gpio.o dma.o wd_timer.o
+	 common.o gpio.o dma.o wd_timer.o irq.o
 
-omap-2-3-common				= irq.o sdrc.o
+omap-2-3-common				= sdrc.o
 hwmod-common				= omap_hwmod.o \
 					  omap_hwmod_common_data.o
 clock-common				= clock.o clock_common_data.o \
-- 
1.7.5.4

