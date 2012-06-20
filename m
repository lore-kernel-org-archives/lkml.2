Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2FTIoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:44:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18669 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2FTIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:44:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jun 2012 01:44:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND] gpio: fix bits conflict for gpio flags
Date: Wed, 20 Jun 2012 14:14:05 +0530
Message-ID: <1340181845-14582-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit 2 and 3 in GPIO flag are allocated for the
flag OPEN_DRAIN/OPEN_SOURCE. These bits are reused
for the flag EXPORT/EXPORT_CHANGEABLE and so creating
conflict.
Fix this conflict by assigning bit 4 and 5 for the
flag EXPORT/EXPORT_CHANGEABLE.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Resending this patch in case of if previous patch lost.

 include/linux/gpio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.1.1

