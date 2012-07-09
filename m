Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2GIOob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:44:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39371 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2GIOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:44:27 -0400
Message-ID: <1341845061.8153.2.camel@phoenix>
Subject: [PATCH] mfd: Export pm80x_regmap_config
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 22:44:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error when CONFIG_MFD_88PM800=m.

ERROR: "pm80x_regmap_config" [drivers/mfd/88pm800.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/88pm80x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index 77b8655..62da342 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -29,6 +29,7 @@ const struct regmap_config pm80x_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
+EXPORT_SYMBOL_GPL(pm80x_regmap_config);
 
 int __devinit pm80x_init(struct i2c_client *client,
 				 const struct i2c_device_id *id)
-- 
1.7.9.5



