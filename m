Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab2JVH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:28:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46056 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2JVH2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:28:15 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] Input: omap4-keypad: Add pinctrl support
Date: Mon, 22 Oct 2012 12:58:16 +0530
Message-ID: <1350890896-29510-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt keypad to use pinctrl framework.

Tested on omap4430 sdp with 3.7-rc1 kernel.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c05f98c..bb9f3a5 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -31,6 +31,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <linux/platform_data/omap4-keypad.h>
 
@@ -76,6 +77,7 @@ enum {
 
 struct omap4_keypad {
 	struct input_dev *input;
+	struct pinctrl	*pins;
 
 	void __iomem *base;
 	unsigned int irq;
@@ -298,6 +300,12 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_release_mem;
 	}
 
+	keypad_data->pins = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(keypad_data->pins)) {
+		dev_warn(&pdev->dev, "did not get pins for keypad error: %li\n",
+					PTR_ERR(keypad_data->pins));
+		keypad_data->pins = NULL;
+	}
 
 	/*
 	 * Enable clocks for the keypad module so that we can read
-- 
1.7.1

