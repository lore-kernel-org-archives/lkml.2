Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966899Ab2EOVDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:03:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56918 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966835Ab2EOVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:12 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 4/5] drivers/savagefb: use mdelay instead of udelay
Date: Tue, 15 May 2012 15:03:00 -0600
Message-Id: <1337115781-27979-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
References: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Long delays need to use mdelay on architectures such as ARM
that cannot compute long timeouts in udelay.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/video/savage/savagefb_driver.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
index cee7803..f3d3b9c 100644
--- a/drivers/video/savage/savagefb_driver.c
+++ b/drivers/video/savage/savagefb_driver.c
@@ -1351,7 +1351,7 @@ static void savagefb_set_par_int(struct savagefb_par  *par, struct savage_reg *r
 	/* following part not present in X11 driver */
 	cr67 = vga_in8(0x3d5, par) & 0xf;
 	vga_out8(0x3d5, 0x50 | cr67, par);
-	udelay(10000);
+	mdelay(10);
 	vga_out8(0x3d4, 0x67, par);
 	/* end of part */
 	vga_out8(0x3d5, reg->CR67 & ~0x0c, par);
@@ -1904,11 +1904,11 @@ static int savage_init_hw(struct savagefb_par *par)
 	vga_out8(0x3d4, 0x66, par);
 	cr66 = vga_in8(0x3d5, par);
 	vga_out8(0x3d5, cr66 | 0x02, par);
-	udelay(10000);
+	mdelay(10);
 
 	vga_out8(0x3d4, 0x66, par);
 	vga_out8(0x3d5, cr66 & ~0x02, par);	/* clear reset flag */
-	udelay(10000);
+	mdelay(10);
 
 
 	/*
@@ -1918,11 +1918,11 @@ static int savage_init_hw(struct savagefb_par *par)
 	vga_out8(0x3d4, 0x3f, par);
 	cr3f = vga_in8(0x3d5, par);
 	vga_out8(0x3d5, cr3f | 0x08, par);
-	udelay(10000);
+	mdelay(10);
 
 	vga_out8(0x3d4, 0x3f, par);
 	vga_out8(0x3d5, cr3f & ~0x08, par);	/* clear reset flags */
-	udelay(10000);
+	mdelay(10);
 
 	/* Savage ramdac speeds */
 	par->numClocks = 4;
-- 
1.7.5.4

