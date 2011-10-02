Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1JBU3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1JBU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/6] ASoC: sh: use correct __iomem annotations
Date: Sun,  2 Oct 2011 22:28:02 +0200
Message-Id: <1317587284-2776-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vmY9+JpaPEUmci63+8wGgqyk1LxpfelEkxLSjnvTn6U
 3vNsv3a+Co8J0HZzsnEWL3X1FsVxeLtWdOaUfkqPC3rd9Qojjv
 OQE47OwOvnKKHgfEGna1ibxWh/mcLZ4Xo4IOAck3HQ2mT1LIVw
 c64hbCJs4GITq0icNCL9Fx8pjFfZXxhgwPWrqLZ+/2MTmDByws
 mNPbctt+QM/41Q7FYzoa+zT+b0Wpgp6NBm6sO447nNxKYqeUd3
 L2wIBG9dUO0Rz/mwPiGjP06J7/OcIzCsvaL6VR44cCjyQvEl3f
 Y5xoUVKFDkOxsPPKcqx1RGg4towENbjRSy8Dhc23nzj8ZOndwQ
 Ou/XN5fmj4S1FpojjE+fom1KicVyySf83veNgnt0mFjRqzD+DD
 etX7ntvbhq1WQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a few unnecessary type casts and avoids
sparse warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 sound/soc/sh/fsi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 8e112cc..916b9f9 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -210,7 +210,7 @@ struct fsi_master {
  *		basic read write function
  */
 
-static void __fsi_reg_write(u32 reg, u32 data)
+static void __fsi_reg_write(u32 __iomem *reg, u32 data)
 {
 	/* valid data area is 24bit */
 	data &= 0x00ffffff;
@@ -218,12 +218,12 @@ static void __fsi_reg_write(u32 reg, u32 data)
 	__raw_writel(data, reg);
 }
 
-static u32 __fsi_reg_read(u32 reg)
+static u32 __fsi_reg_read(u32 __iomem *reg)
 {
 	return __raw_readl(reg);
 }
 
-static void __fsi_reg_mask_set(u32 reg, u32 mask, u32 data)
+static void __fsi_reg_mask_set(u32 __iomem *reg, u32 mask, u32 data)
 {
 	u32 val = __fsi_reg_read(reg);
 
@@ -250,7 +250,7 @@ static u32 _fsi_master_read(struct fsi_master *master, u32 reg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&master->lock, flags);
-	ret = __fsi_reg_read((u32)(master->base + reg));
+	ret = __fsi_reg_read(master->base + reg);
 	spin_unlock_irqrestore(&master->lock, flags);
 
 	return ret;
@@ -264,7 +264,7 @@ static void _fsi_master_mask_set(struct fsi_master *master,
 	unsigned long flags;
 
 	spin_lock_irqsave(&master->lock, flags);
-	__fsi_reg_mask_set((u32)(master->base + reg), mask, data);
+	__fsi_reg_mask_set(master->base + reg, mask, data);
 	spin_unlock_irqrestore(&master->lock, flags);
 }
 
-- 
1.7.5.4

