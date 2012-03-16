Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032716Ab2CPKV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:21:28 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:38852 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031028Ab2CPKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:21:26 -0400
From: Shiraz Hashim <shiraz.hashim@st.com>
To: <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>
Subject: [PATCH resend] ata/ahci_platform: add hibernation callbacks
Date: Fri, 16 Mar 2012 15:49:55 +0530
Message-ID: <1331893195-27078-1-git-send-email-shiraz.hashim@st.com>
X-Mailer: git-send-email 1.7.9.rc0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing suspend, resume implementation for hibernation callbacks.

Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
---
 drivers/ata/ahci_platform.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 2bbcbbe..4431c60 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
@@ -286,13 +287,10 @@ static int ahci_resume(struct device *dev)
 
 	return 0;
 }
-
-static struct dev_pm_ops ahci_pm_ops = {
-	.suspend		= &ahci_suspend,
-	.resume			= &ahci_resume,
-};
 #endif
 
+SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
+
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
 	{},
@@ -305,9 +303,7 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
-#ifdef CONFIG_PM
 		.pm = &ahci_pm_ops,
-#endif
 	},
 	.id_table	= ahci_devtype,
 };
-- 
1.7.9.rc0

