Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2KENmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:42:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46011 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2KENmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:42:22 -0500
Message-ID: <1352122936.14769.4.camel@phoenix>
Subject: [PATCH] pinctrl: u300: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 21:42:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staticize u300_pin_config_get() and u300_pin_config_set() functions.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-u300.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 2e9825e..d756cce 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1052,9 +1052,8 @@ static struct pinctrl_gpio_range *u300_match_gpio_range(unsigned pin)
 	return NULL;
 }
 
-int u300_pin_config_get(struct pinctrl_dev *pctldev,
-			unsigned pin,
-			unsigned long *config)
+static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
+			       unsigned long *config)
 {
 	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
 
@@ -1067,9 +1066,8 @@ int u300_pin_config_get(struct pinctrl_dev *pctldev,
 				    config);
 }
 
-int u300_pin_config_set(struct pinctrl_dev *pctldev,
-			unsigned pin,
-			unsigned long config)
+static int u300_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
+			       unsigned long config)
 {
 	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
 	int ret;
-- 
1.7.9.5



