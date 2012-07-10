Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2GJGoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:44:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36979 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2GJGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:44:09 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 4/6] staging/media/dt3155v4l: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:13:48 +0530
Message-Id: <1341902628-22465-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the driver duplicates the module_pci_driver code,
remove the duplicate code and use the module_pci_driver macro.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index c365cdf..ebe5a27 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -971,20 +971,7 @@ static struct pci_driver pci_driver = {
 	.remove = __devexit_p(dt3155_remove),
 };
 
-static int __init
-dt3155_init_module(void)
-{
-	return pci_register_driver(&pci_driver);
-}
-
-static void __exit
-dt3155_exit_module(void)
-{
-	pci_unregister_driver(&pci_driver);
-}
-
-module_init(dt3155_init_module);
-module_exit(dt3155_exit_module);
+module_pci_driver(pci_driver);
 
 MODULE_DESCRIPTION("video4linux pci-driver for dt3155 frame grabber");
 MODULE_AUTHOR("Marin Mitov <mitov@issp.bas.bg>");
-- 
1.7.9.5

