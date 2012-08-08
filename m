Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2HHHHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:07:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2HHHHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:07:10 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-i801: Add device tree support
Date: Wed,  8 Aug 2012 09:06:47 +0200
Message-Id: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:X8670k85awk4a8u5szAsX0LojCObF/VVzW9SD9n8kyY
 I1ey8fj6znb3codsHHhl8ecAJ0I/heBGHBjXPC7pRRFMWhnkMh
 mmrVB8lUOkm8BfFDe76EzFsctjZzPFnT6EjfFNmuiZH2ySZHPI
 Jc10S/QVUvU9IMRDugKpQLb2/rXf36iT+THMKVmTKnrnY+oHds
 qjSz4EirNj/JfFMP38cHpjTyU5EdZX+lyfepF2b9TBx2e8s4QP
 35G0Zdu2AcuCSYicYzmdCYLOaH6Xqee6AfkTzY21SXDHP23Kwc
 nX8aTnwQgW6YtIea3XyY5yBa6Z1rxNSb+FfLm20ZkaAQfBNmjH
 xbhHnoeMTK3EtixfR+tc6EcC8qTUh2D4xpunWYBm7s1eFdm6yM
 9+g7zS8AHsIwM3Fz3BsoZ/OnwH8Imhk+kFjSsLXcsSO4v0O1+s
 59tdI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for probing slave devices parsed from the
device tree.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/i2c/busses/i2c-i801.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 6f00785..b5311cf 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -80,6 +80,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/err.h>
+#include <linux/of_i2c.h>
 
 #if defined CONFIG_I2C_MUX || defined CONFIG_I2C_MUX_MODULE
 #include <linux/gpio.h>
@@ -1238,6 +1239,7 @@ static int __devinit i801_probe(struct pci_dev *dev,
 		goto exit_free_irq;
 	}
 
+	of_i2c_register_devices(&priv->adapter);
 	i801_probe_optional_slaves(priv);
 	/* We ignore errors - multiplexing is optional */
 	i801_add_mux(priv);
-- 
1.7.11.4

