Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2GENKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:10:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/9] pinctrl: pinctrl-nomadik: Append sleepmode property with vendor specific prefixes
Date: Thu,  5 Jul 2012 14:06:05 +0100
Message-Id: <1341493572-29735-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any non-standard property should contain the vendor's identifier which
should be perpended onto the property name followed by a comma. This
aids in name-space collision prevention. This patch ensures the
sleepmode property adheres to the rules.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/gpio/gpio-nmk.txt          |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-nmk.txt b/Documentation/devicetree/bindings/gpio/gpio-nmk.txt
index ee87467..8315ac7 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-nmk.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-nmk.txt
@@ -26,6 +26,6 @@ Example:
                         #gpio-cells = <2>;
                         gpio-controller;
                         interrupt-controller;
-                        supports-sleepmode;
+                        st,supports-sleepmode;
                         gpio-bank = <1>;
                 };
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index af0389f..520aa23 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1198,7 +1198,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		if (!pdata)
 			return -ENOMEM;
 
-		if (of_get_property(np, "supports-sleepmode", NULL))
+		if (of_get_property(np, "st,supports-sleepmode", NULL))
 			pdata->supports_sleepmode = true;
 
 		if (of_property_read_u32(np, "gpio-bank", &dev->id)) {
-- 
1.7.9.5

