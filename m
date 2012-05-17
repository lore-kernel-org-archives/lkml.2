Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305Ab2EQHft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:35:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761113Ab2EQHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:35:45 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/2] gpio/mxc: remove basic_mmio_gpio shadow fixup
Date: Thu, 17 May 2012 15:35:03 +0800
Message-Id: <1337240103-4756-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
References: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 7cc9c7c (gpio/generic: initialize basic_mmio_gpio shadow
variables properly) fixing the basic_mmio_gpio shadow variables in
gpio-generic, the fixup in gpio-mxc can be removed now.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-mxc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index e791476..dbaac01 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -423,8 +423,6 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 
 	port->bgc.gc.to_irq = mxc_gpio_to_irq;
 	port->bgc.gc.base = pdev->id * 32;
-	port->bgc.dir = port->bgc.read_reg(port->bgc.reg_dir);
-	port->bgc.data = port->bgc.read_reg(port->bgc.reg_set);
 
 	err = gpiochip_add(&port->bgc.gc);
 	if (err)
-- 
1.7.5.4

