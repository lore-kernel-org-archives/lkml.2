Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2KBPIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:08:32 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:56698 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab2KBPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:08:30 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 11:08:30 EDT
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] gpio-pch: Set parent dev for gpio chip
Date: Fri,  2 Nov 2012 16:02:25 +0100
Message-Id: <1351868545-15886-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will show the gpio chip as a child node
under /sys/bus/pci/devices/xxxx:xx:xx.x/

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/gpio/gpio-pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 4ad0c4f..e3a14fe 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -215,6 +215,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 	struct gpio_chip *gpio = &chip->gpio;
 
 	gpio->label = dev_name(chip->dev);
+	gpio->dev = chip->dev;
 	gpio->owner = THIS_MODULE;
 	gpio->direction_input = pch_gpio_direction_input;
 	gpio->get = pch_gpio_get;
-- 
1.7.8.6

