Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab2K0JWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:22:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38243 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab2K0JVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:21:47 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 4/4] Input: RMI4 - introduce rmi_module_driver() macro
Date: Tue, 27 Nov 2012 01:21:38 -0800
Message-Id: <1354008098-26346-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also allows us to cut down on the boilerplate code in the function
handler modules.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f11.c | 13 +------------
 include/linux/rmi.h          | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index dbb6060..8457ab4 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -2756,18 +2756,7 @@ static struct rmi_function_handler rmi_f11_handler = {
 #endif  /* defined(CONFIG_HAS_EARLYSUSPEND) */
 };
 
-static int __init rmi_f11_module_init(void)
-{
-	return rmi_register_function_handler(&rmi_f11_handler);
-}
-
-static void __exit rmi_f11_module_exit(void)
-{
-	rmi_unregister_function_handler(&rmi_f11_handler);
-}
-
-module_init(rmi_f11_module_init);
-module_exit(rmi_f11_module_exit);
+module_rmi_driver(rmi_f11_handler);
 
 MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com");
 MODULE_DESCRIPTION("RMI F11 module");
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index 8a74066..daca41b 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -600,4 +600,18 @@ int rmi_register_phys_device(struct rmi_phys_device *phys);
 void rmi_unregister_phys_device(struct rmi_phys_device *phys);
 int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data));
 
+/**
+ * module_serio_driver() - Helper macro for registering a serio driver
+ * @__serio_driver: serio_driver struct
+ *
+ * Helper macro for serio drivers which do not do anything special in
+ * module init/exit. This eliminates a lot of boilerplate. Each module
+ * may only use this macro once, and calling it replaces module_init()
+ * and module_exit().
+ */
+#define module_rmi_driver(__rmi_driver)			\
+	module_driver(__rmi_driver,			\
+		      rmi_register_function_handler,	\
+		      rmi_unregister_function_handler)
+
 #endif
-- 
1.7.11.7

