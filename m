Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2HWIx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:53:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53130 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2HWIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:53:24 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] misc: use module_spi_driver
Date: Thu, 23 Aug 2012 14:23:09 +0530
Message-Id: <1345711989-23276-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _init and _exit functions can be replaced with the module_spi_driver
macro, which actually implements

static int __init drv_init(void)
{
	spi_register_driver(&driv_op);
	return 0;
}

module_init(drv_init);

static void __exit drv_exit(void)
{
	spi_unregister_driver(&driv_op);
}

module_exit(drv_exit);

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/misc/bmp085-spi.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/misc/bmp085-spi.c b/drivers/misc/bmp085-spi.c
index 78aaff9..5e982af 100644
--- a/drivers/misc/bmp085-spi.c
+++ b/drivers/misc/bmp085-spi.c
@@ -73,19 +73,8 @@ static struct spi_driver bmp085_spi_driver = {
 	.remove		= __devexit_p(bmp085_spi_remove)
 };
 
-static int __init bmp085_spi_init(void)
-{
-	return spi_register_driver(&bmp085_spi_driver);
-}
-
-static void __exit bmp085_spi_exit(void)
-{
-	spi_unregister_driver(&bmp085_spi_driver);
-}
+module_spi_driver(bmp085_spi_driver);
 
 MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
 MODULE_DESCRIPTION("BMP085 SPI bus driver");
 MODULE_LICENSE("GPL");
-
-module_init(bmp085_spi_init);
-module_exit(bmp085_spi_exit);
-- 
1.7.9.5

