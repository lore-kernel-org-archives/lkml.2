Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2EGK3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:29:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15815 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2EGK3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:29:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 May 2012 03:29:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com
Cc: w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1] gpio: fix bits conflict for gpio flags
Date: Mon,  7 May 2012 15:55:38 +0530
Message-Id: <1336386338-20353-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit 2 and 3 in GPIO flag are allocated for the
flag OPEN_DRAIN/OPEN_SOURCE. These bits are reused
for the flag EXPORT/EXPORT_CHANGEABLE and so creating
conflict.
Fix this conflict by allocating bit 4 and 5 for the
flag EXPORT/EXPORT_CHANGEABLE.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is broken by commit
commit fc3a1f04f5040255cbc086c419e4237f29f89f88
Author: Wolfram Sang <w.sang@pengutronix.de>

    gpio: add flags to export GPIOs when requesting
    

 include/linux/gpio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index d1890d4..0118141 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -20,8 +20,8 @@
 /* Gpio pin is open source */
 #define GPIOF_OPEN_SOURCE	(1 << 3)
 
-#define GPIOF_EXPORT		(1 << 2)
-#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
+#define GPIOF_EXPORT		(1 << 4)
+#define GPIOF_EXPORT_CHANGEABLE	(1 << 5)
 #define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
 #define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
 
-- 
1.7.1.1

