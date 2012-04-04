Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2DDDIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:08:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55285 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab2DDDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:08:08 -0400
Message-ID: <1333508882.15318.5.camel@phoenix>
Subject: [PATCH 1/2] serio: Add helper macro for serio_driver boilerplate
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@mail.ru>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-input@vger.kernel.org
Date: Wed, 04 Apr 2012 11:08:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the module_serio_driver macro which is a convenience
macro for serio driver modules similar to module_platform_driver. It is
intended to be used by drivers which init/exit section does nothing but
register/unregister the serio driver. By using this macro it is possible
to eliminate a few lines of boilerplate code per serio driver.

Based on work done by Lars-Peter Clausen <lars@metafoo.de> for other
busses (i2c and spi).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/serio.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/serio.h b/include/linux/serio.h
index ca82861..4166208 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -96,6 +96,18 @@ int __must_check __serio_register_driver(struct serio_driver *drv,
 
 void serio_unregister_driver(struct serio_driver *drv);
 
+/**
+ * module_serio_driver() - Helper macro for registering a serio driver
+ * @__serio_driver: serio_driver struct
+ *
+ * Helper macro for serio drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_serio_driver(__serio_driver) \
+	module_driver(__serio_driver, serio_register_driver, \
+		       serio_unregister_driver)
+
 static inline int serio_write(struct serio *serio, unsigned char data)
 {
 	if (serio->write)
-- 
1.7.5.4



