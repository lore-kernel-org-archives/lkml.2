Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2DDDch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:32:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44217 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2DDDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:32:36 -0400
Message-ID: <1333510350.15318.10.camel@phoenix>
Subject: [PATCH 1/2] gameport: Add helper macro for gameport_driver
 boilerplate
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@mail.ru>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-input@vger.kernel.org
Date: Wed, 04 Apr 2012 11:32:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the module_gameport_driver macro which is a convenience
macro for gameport driver modules similar to module_platform_driver. It is
intended to be used by drivers which init/exit section does nothing but
register/unregister the serio driver. By using this macro it is possible
to eliminate a few lines of boilerplate code per serio driver.

Based on work done by Lars-Peter Clausen <lars@metafoo.de> for other
busses (i2c and spi).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/gameport.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/gameport.h b/include/linux/gameport.h
index b456b08..7f51b54 100644
--- a/include/linux/gameport.h
+++ b/include/linux/gameport.h
@@ -153,6 +153,18 @@ int __must_check __gameport_register_driver(struct gameport_driver *drv,
 
 void gameport_unregister_driver(struct gameport_driver *drv);
 
+/**
+ * module_gameport_driver() - Helper macro for registering a gameport driver
+ * @__gameport_driver: gameport_driver struct
+ *
+ * Helper macro for gameport drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_gameport_driver(__gameport_driver) \
+	module_driver(__gameport_driver, gameport_register_driver, \
+		       gameport_unregister_driver)
+
 #endif /* __KERNEL__ */
 
 #define GAMEPORT_MODE_DISABLED		0
-- 
1.7.5.4



