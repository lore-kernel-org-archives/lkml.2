Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2GUSrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 14:47:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33024 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2GUSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 14:47:35 -0400
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] of: i2c: add support for wakeup-source property
Date: Sat, 21 Jul 2012 11:47:25 -0700
Message-Id: <1342896445-5244-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for specifying a generic "wakeup-source" property on i2c
clients, which will set the I2C_CLIENT_WAKE flag, thus configuring the
device to wake the system from suspend (via IRQ).

This obviously doesn't make sense on devices lacking IRQ, but since we
still allow that in the i2c_board_info case, I don't see a reason to
restrict it here.

Note: Since the generic i2c bindings aren't documented in the kernel,
I didn't find a good place to add documentation for this binding
extension. I still think it makes sense to have a generic property
instead of having each device do its own binding for the same.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/of/of_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 1e173f3..3550f3b 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -61,6 +61,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
+		if (of_get_property(node, "wakeup-source", NULL))
+			info.flags |= I2C_CLIENT_WAKE;
+
 		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
 
 		result = i2c_new_device(adap, &info);
-- 
1.7.10.1.488.g05fbf7a

