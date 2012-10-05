Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2JEPej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:34:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2JEPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 04/10] of/i2c: Add support for I2C_CLIENT_WAKE when booting with Device Tree
Date: Fri,  5 Oct 2012 16:31:40 +0100
Message-Id: <1349451107-8009-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's important for wakeup sources such as keyboards, power buttons
and the like to identify themselves as wakeup devices. Until now
this has not been possible when platforms are booting via Device
Tree.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/of_i2c.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 1e173f3..2f20019 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -61,6 +61,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
+		if (of_get_property(node, "i2c-client-wake", NULL))
+			info.flags |= I2C_CLIENT_WAKE;
+
 		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
 
 		result = i2c_new_device(adap, &info);
-- 
1.7.9.5

