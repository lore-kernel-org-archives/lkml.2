Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1IAJmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:42:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52250 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1IAJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:42:05 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] drivers/i2c/busses/scx200_acb.c: Fix section mismatch warning in scx200_pci_drv
Date: Thu,  1 Sep 2011 17:40:29 +0800
Message-Id: <1314870029-28541-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/i2c/busses/built-in.o(.data+0x47c8): Section mismatch in reference from the variable scx200_pci_drv to the function .devinit.text:scx200_probe()
The variable scx200_pci_drv references
the function __devinit scx200_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/i2c/busses/scx200_acb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 986e5f6..91e349c 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -550,7 +550,7 @@ static int __devexit scx200_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver scx200_pci_drv = {
+static struct platform_driver scx200_pci_driver = {
 	.driver = {
 		.name = "cs5535-smb",
 		.owner = THIS_MODULE,
@@ -593,14 +593,14 @@ static int __init scx200_acb_init(void)
 		return 0;
 
 	/* No ISA devices; register the platform driver for PCI-based devices */
-	return platform_driver_register(&scx200_pci_drv);
+	return platform_driver_register(&scx200_pci_driver);
 }
 
 static void __exit scx200_acb_cleanup(void)
 {
 	struct scx200_acb_iface *iface;
 
-	platform_driver_unregister(&scx200_pci_drv);
+	platform_driver_unregister(&scx200_pci_driver);
 
 	mutex_lock(&scx200_acb_list_mutex);
 	while ((iface = scx200_acb_list) != NULL) {
-- 
1.7.2.5

