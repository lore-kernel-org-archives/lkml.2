Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1LTJkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:40:46 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29482
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab1LTJkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:40:43 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>
Subject: [PATCH 1/1] pinctrl: some typo fixes
Date: Tue, 20 Dec 2011 17:51:59 +0800
Message-ID: <1324374719-5654-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 Documentation/pinctrl.txt |   10 +++++-----
 drivers/pinctrl/pinmux.c  |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index f080643..1021be9 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -217,7 +217,7 @@ changing pin configuration in the pin controller ops like this:
 #include <linux/pinctrl/pinconf.h>
 #include "platform_x_pindefs.h"
 
-int foo_pin_config_get(struct pinctrl_dev *pctldev,
+static int foo_pin_config_get(struct pinctrl_dev *pctldev,
 		    unsigned offset,
 		    unsigned long *config)
 {
@@ -228,7 +228,7 @@ int foo_pin_config_get(struct pinctrl_dev *pctldev,
 	*config = (unsigned long) conf;
 }
 
-int foo_pin_config_set(struct pinctrl_dev *pctldev,
+static int foo_pin_config_set(struct pinctrl_dev *pctldev,
 		    unsigned offset,
 		    unsigned long config)
 {
@@ -241,14 +241,14 @@ int foo_pin_config_set(struct pinctrl_dev *pctldev,
 	}
 }
 
-int foo_pin_config_group_get (struct pinctrl_dev *pctldev,
+static int foo_pin_config_group_get (struct pinctrl_dev *pctldev,
 		    unsigned selector,
 		    unsigned long *config)
 {
 	...
 }
 
-int foo_pin_config_group_set (struct pinctrl_dev *pctldev,
+static int foo_pin_config_group_set (struct pinctrl_dev *pctldev,
 		    unsigned selector,
 		    unsigned long config)
 {
@@ -819,7 +819,7 @@ it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinmux_map __initdata pmx_mapping[] = {
-       PINMUX_MAP_PRIMARY("I2CMAP", "i2c0", "foo-i2c.0"),
+       PINMUX_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
 };
 
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 432feb6..0916222 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -342,7 +342,7 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
  * Only call this once during initialization of your machine, the function is
  * tagged as __init and won't be callable after init has completed. The map
  * passed into this function will be owned by the pinmux core and cannot be
- * free:d.
+ * freed.
  */
 int __init pinmux_register_mappings(struct pinmux_map const *maps,
 				    unsigned num_maps)
@@ -1006,7 +1006,7 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 }
 
 /**
- * pinmux_hog_maps() - unhog specific map entries on controller device
+ * pinmux_unhog_maps() - unhog specific map entries on controller device
  * @pctldev: the pin control device to unhog entries on
  */
 void pinmux_unhog_maps(struct pinctrl_dev *pctldev)
-- 
1.7.0.4


