Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab1EOONQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:13:16 -0400
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:15800 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881Ab1EOONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:13:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEhAC7ez01UXeb6/2dsb2JhbACCNIJmkkYxjgV3uS0ChhyJHg6GCwSUQIQchio
Subject: [PATCH] mfd: Fix ASIC3 SD Host Controller Configuration size
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>, <philipp.zabel@gmail.com>
Date: Sun, 15 May 2011 14:13:11 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QLc4H-0005Vx-7y@outmx05.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the TC6380AF SD Host Controller Configuration area is 0x200 bytes (assuming registers are aligned on 32-bit boundaries), not 0x400 bytes. Source: Toshiba TC6380AF Specification sections 4.2 and 4.3.1

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
diff -uprN clean-2.6.39-rc7/drivers/mfd/asic3.c linux-2.6.39-rc7/drivers/mfd/asic3.c
--- clean-2.6.39-rc7/drivers/mfd/asic3.c	2011-05-15 14:54:26.240112516 +0100
+++ linux-2.6.39-rc7/drivers/mfd/asic3.c	2011-05-15 14:59:12.758135981 +0100
@@ -854,7 +854,8 @@ static int __init asic3_mfd_probe(struct
 
 	/* MMC */
 	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
-				 mem_sdio->start, 0x400 >> asic->bus_shift);
+				 mem_sdio->start,
+				 ASIC3_SD_CONFIG_SIZE >> asic->bus_shift);
 	if (!asic->tmio_cnf) {
 		ret = -ENOMEM;
 		dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
diff -uprN clean-2.6.39-rc7/include/linux/mfd/asic3.h linux-2.6.39-rc7/include/linux/mfd/asic3.h
--- clean-2.6.39-rc7/include/linux/mfd/asic3.h	2011-05-15 14:54:23.488093081 +0100
+++ linux-2.6.39-rc7/include/linux/mfd/asic3.h	2011-05-13 19:21:20.515450640 +0100
@@ -297,6 +297,7 @@ struct asic3_platform_data {
  *
  *****************************************************************************/
 #define ASIC3_SD_CONFIG_BASE	0x0400 /* Assumes 32 bit addressing */
+#define ASIC3_SD_CONFIG_SIZE	0x0200 /* Assumes 32 bit addressing */
 #define ASIC3_SD_CTRL_BASE	0x1000
 #define ASIC3_SDIO_CTRL_BASE	0x1200
 

