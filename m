Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2DVRIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 13:08:40 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60408 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2DVRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 13:08:39 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH] mfd: omap-ush-host: Fix build breakage
Date: Sun, 22 Apr 2012 19:08:30 +0200
Message-Id: <1335114510-29413-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 (ARM: OMAP3: USB: Fix
the EHCI ULPI PHY reset issue) removed #include <linux/gpio.h> which
indirectly includes 'plat/cpu.h'. This caused build breakage:

drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'cpu_is_omap3430'
drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'omap_rev'
drivers/mfd/omap-usb-host.c:525:43: error: 'OMAP3430_REV_ES2_1' undeclared (first use in this function)

Include <plat/cpu.h> to fix it.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Keshava Munegowda <Keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index c8aae66..7e96bb2 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
+#include <plat/cpu.h>
 #include <plat/usb.h>
 #include <linux/pm_runtime.h>
 
-- 
1.7.1

