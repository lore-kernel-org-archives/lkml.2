Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2FVLrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:47:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6592 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab2FVLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:47:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 22 Jun 2012 04:47:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: gpiolib: fix conflicting flag values
Date: Fri, 22 Jun 2012 20:48:56 +0900
Message-ID: <1340365736-20161-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits aca5ce14 and 25553ff0 introduced two new GPIOF_OPEN_DRAIN and
GPIOF_OPEN_SOURCE flags to gpiolib. Unfortunately they happen to be the
same as GPIOF_EXPORT and GPIOF_EXPORT_CHANGEABLE, which causes all gpios
exported at request time to end up open drain and/or open source.

Resolve the conflict by affecting free flags to GPIOF_EXPORT and
GPIOF_EXPORT_CHANGEABLE.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 include/linux/gpio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index f07fc2d..2e31e8b 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -22,8 +22,8 @@
 /* Gpio pin is open source */
 #define GPIOF_OPEN_SOURCE	(1 << 3)
 
-#define GPIOF_EXPORT		(1 << 2)
-#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
+#define GPIOF_EXPORT		(1 << 4)
+#define GPIOF_EXPORT_CHANGEABLE	(1 << 5)
 #define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
 #define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
 
-- 
1.7.11

