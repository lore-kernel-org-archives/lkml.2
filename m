Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1JBOrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1JBOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/30] ARM: omap: fix build with CONFIG_I2C_OMAP disabled
Date: Sun,  2 Oct 2011 16:45:36 +0200
Message-Id: <1317566760-25681-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:G4oyU1IQ5HPC5fQFg+PxEeGqHW2IJlzx3164VcI2N82
 B2EQlBxsBa/KErDylXL5XYLK/hi+vvfRZhcAnn1CxxZA542qLE
 apPL4Uh9YMYsJ4gz7BSPIxfyQlif6fAESkGubJJ94uYbVxPDgz
 PLr61YlgerJyUjdQVL30f32p3rQNfkQD0grxYCPocdTtJy7L7B
 mNBf8K+kY3rkJFakzHJ/dF9JxHx+BxSKO/9+/nsIMHFSIhSk1+
 /Ii2SAl0MKf4EOVsHz+SUAeKQMb7LBlkVtjNNm+xWkUberWL53
 92sg/sG7hS4Vz/pFq3JjQGfL450XRGZC7HbhHqc4LqCA1cI+Dn
 PIwptQSQ4jJVTj7fYnGo8Dj+zdXCJ48IGSlYcaePFvJPpaIrA4
 WlZ1IPcYlqAJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not reference omap_i2c_reset if the file defining it
does not get built.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-omap/include/plat/i2c.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/i2c.h b/arch/arm/plat-omap/include/plat/i2c.h
index 7c22b9e..ae72013 100644
--- a/arch/arm/plat-omap/include/plat/i2c.h
+++ b/arch/arm/plat-omap/include/plat/i2c.h
@@ -28,6 +28,8 @@
 extern int omap_register_i2c_bus(int bus_id, u32 clkrate,
 				 struct i2c_board_info const *info,
 				 unsigned len);
+struct omap_hwmod;
+int omap_i2c_reset(struct omap_hwmod *oh);
 #else
 static inline int omap_register_i2c_bus(int bus_id, u32 clkrate,
 				 struct i2c_board_info const *info,
@@ -35,6 +37,7 @@ static inline int omap_register_i2c_bus(int bus_id, u32 clkrate,
 {
 	return 0;
 }
+#define omap_i2c_reset NULL
 #endif
 
 /**
@@ -53,7 +56,4 @@ struct omap_i2c_dev_attr {
 void __init omap1_i2c_mux_pins(int bus_id);
 void __init omap2_i2c_mux_pins(int bus_id);
 
-struct omap_hwmod;
-int omap_i2c_reset(struct omap_hwmod *oh);
-
 #endif /* __ASM__ARCH_OMAP_I2C_H */
-- 
1.7.5.4

