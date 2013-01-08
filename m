Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3AHVoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:44:12 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:45538 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3AHVni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:43:38 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] tty: of_serial: Add pinctrl support
Date: Tue,  8 Jan 2013 22:43:17 +0100
Message-Id: <1357681398-23956-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pinctrl to configure the SoCs pins directly from the driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/tty/serial/of_serial.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index e7cae1c..e9f3289 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_reg.h>
@@ -57,6 +58,7 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 			struct of_serial_info *info)
 {
 	struct resource resource;
+	struct pinctrl *pinctrl;
 	struct device_node *np = ofdev->dev.of_node;
 	u32 clk, spd, prop;
 	int ret;
@@ -85,6 +87,11 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		goto out;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&ofdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&ofdev->dev,
+			"pins are not configured from the driver\n");
+
 	spin_lock_init(&port->lock);
 	port->mapbase = resource.start;
 
-- 
1.7.10.4

