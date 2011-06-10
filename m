Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1FJQIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:08:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:27029 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1FJQIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:08:40 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1307722119!22096015!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio/ep93xx: Add missing EP93XX_GPIO_PHYS_BASE define
Date: Fri, 10 Jun 2011 09:08:17 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>, Ryan Mallon <ryan@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106100908.18678.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch to convert of the ep93xx gpio driver to a platform_driver is
missing the define for the memory resource that is passed to the driver.

This is needed to prevent a build error.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ryan Mallon <ryan@bluewatersys.com>

---

Grant, can you pick this up in your tree to prevent the build error?

diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
index 9ac4d10..c4a7b84 100644
--- a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
+++ b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
@@ -98,6 +98,7 @@
 
 #define EP93XX_SECURITY_BASE		EP93XX_APB_IOMEM(0x00030000)
 
+#define EP93XX_GPIO_PHYS_BASE		EP93XX_APB_PHYS(0x00040000)
 #define EP93XX_GPIO_BASE		EP93XX_APB_IOMEM(0x00040000)
 #define EP93XX_GPIO_REG(x)		(EP93XX_GPIO_BASE + (x))
 #define EP93XX_GPIO_F_INT_STATUS	EP93XX_GPIO_REG(0x5c)
