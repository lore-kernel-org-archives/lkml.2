Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2IBTay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:30:54 -0400
Received: from mail.ispras.ru ([83.149.199.43]:56888 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab2IBTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:30:53 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kevin McKinney <klmckinney1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: bcm: use pr_info and pr_err rather than printk
Date: Sun,  2 Sep 2012 23:30:14 +0400
Message-Id: <1346614214-14340-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
References: <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printk(KERN_INFO to pr_info( and printk(KERN_ERR to pr_err(.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/bcm/InterfaceInit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 57452ef..dfee0ce 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -671,18 +671,18 @@ static __init int bcm_init(void)
 {
 	int retval;
 
-	printk(KERN_INFO "%s: %s, %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
-	printk(KERN_INFO "%s\n", DRV_COPYRIGHT);
+	pr_info("%s: %s, %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
+	pr_info("%s\n", DRV_COPYRIGHT);
 
 	bcm_class = class_create(THIS_MODULE, DRV_NAME);
 	if (IS_ERR(bcm_class)) {
-		printk(KERN_ERR DRV_NAME ": could not create class\n");
+		pr_err(DRV_NAME ": could not create class\n");
 		return PTR_ERR(bcm_class);
 	}
 
 	retval = usb_register(&usbbcm_driver);
 	if (retval < 0) {
-		printk(KERN_ERR DRV_NAME ": could not register usb driver\n");
+		pr_err(DRV_NAME ": could not register usb driver\n");
 		class_destroy(bcm_class);
 		return retval;
 	}
-- 
1.7.9.5

