Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1KJIah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:30:37 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:48511 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351Ab1KJIag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:30:36 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: documentation update
Date: Thu, 10 Nov 2011 09:30:07 +0100
Message-ID: <1320913807-19928-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Update the docs removing an obsolete __refdata tag and document
the mysterious return value of pin_free().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt |    2 +-
 drivers/pinctrl/pinmux.c  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 328adb7..a05e23b 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -59,7 +59,7 @@ this in our driver:
 
 #include <linux/pinctrl/pinctrl.h>
 
-const struct pinctrl_pin_desc __refdata foo_pins[] = {
+const struct pinctrl_pin_desc foo_pins[] = {
       PINCTRL_PIN(0, "A1"),
       PINCTRL_PIN(1, "A2"),
       PINCTRL_PIN(2, "A3"),
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 06bee1b..6738162 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -178,6 +178,10 @@ out:
  * @pin: the pin to free
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
+ *
+ * This function returns a pointer to the function name in use. This is used
+ * for callers that dynamically allocate a function name so it can be free:ed
+ * once the pin is free. This is done for GPIO request functions.
  */
 static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 			    struct pinctrl_gpio_range *gpio_range)
-- 
1.7.3.2

