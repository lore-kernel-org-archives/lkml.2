Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2IAUcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 16:32:11 -0400
Received: from mail.ispras.ru ([83.149.199.43]:45626 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2IAUcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 16:32:10 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] ppdev: ppdev_init: do not return zero in case of failure
Date: Sun,  2 Sep 2012 00:31:58 +0400
Message-Id: <1346531518-24612-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling of parport_register_driver() in ppdev_init()
is broken because it deallocates all resources but still
returns zero.

Currently parport_register_driver() always succeeds.
Nevertheless it is worth to fix the issue.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/char/ppdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 3fcf80f..d0d824e 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -783,7 +783,8 @@ static int __init ppdev_init (void)
 		err = PTR_ERR(ppdev_class);
 		goto out_chrdev;
 	}
-	if (parport_register_driver(&pp_driver)) {
+	err = parport_register_driver(&pp_driver);
+	if (err < 0) {
 		printk (KERN_WARNING CHRDEV ": unable to register with parport\n");
 		goto out_class;
 	}
-- 
1.7.9.5

