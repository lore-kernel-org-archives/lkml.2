Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2IMTtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:49:25 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:33181 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2IMTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:49:23 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        linux-kernel@vger.kernel.org, thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] pinctrl: use kasprintf() in pinmux_request_gpio()
Date: Thu, 13 Sep 2012 21:49:14 +0200
Message-Id: <1347565754-9534-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a temporary buffer, snprintf() and kstrdup(), just
use kasprintf() that does the same thing in just oneline.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/pinmux.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 3d5ac73..9301a7a 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -232,14 +232,11 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio)
 {
-	char gpiostr[16];
 	const char *owner;
 	int ret;
 
 	/* Conjure some name stating what chip and pin this is taken by */
-	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
-
-	owner = kstrdup(gpiostr, GFP_KERNEL);
+	owner = kasprintf(GFP_KERNEL, "%s:%d", range->name, gpio);
 	if (!owner)
 		return -EINVAL;
 
-- 
1.7.9.5

