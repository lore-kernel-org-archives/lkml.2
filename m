Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2FFOcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:32:11 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56034 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756145Ab2FFOcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:32:09 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 10:32:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAMFmz09bdWOb/2dsb2JhbABFhU6uZ4EHghkBBSMPAUYQJQImAgJXBxKID6RJkmCBI458gRIDlR2PeoJi
X-IronPort-AV: E=Sophos;i="4.75,724,1330902000"; 
   d="scan'208";a="999999577"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 2/4] Staging: xgifb: reorder the code a bit to be more module friendly
Date: Wed,  6 Jun 2012 16:22:05 +0200
Message-Id: <1338992527-5659-2-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338992527-5659-1-git-send-email-magomez@igalia.com>
References: <1338992527-5659-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   51 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 61dc7cb..96abb23 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2306,49 +2306,44 @@ static struct pci_driver xgifb_driver = {
 	.remove = __devexit_p(xgifb_remove)
 };
 
-static int __init xgifb_init(void)
-{
-	char *option = NULL;
-
-	if (forcecrt2type != NULL)
-		XGIfb_search_crt2type(forcecrt2type);
-	if (fb_get_options("xgifb", &option))
-		return -ENODEV;
-	XGIfb_setup(option);
-
-	return pci_register_driver(&xgifb_driver);
-}
 
-module_init(xgifb_init);
 
 /*****************************************************/
 /*                      MODULE                       */
 /*****************************************************/
 
-MODULE_DESCRIPTION("Z7 Z9 Z9S Z11 framebuffer device driver");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("XGITECH , Others");
-
 module_param(mode, charp, 0);
-module_param(vesa, int, 0);
-module_param(filter, int, 0);
-module_param(forcecrt2type, charp, 0);
+MODULE_PARM_DESC(mode,
+	"\nSelects the desired default display mode in the format XxYxDepth,\n"
+	"eg. 1024x768x16.\n");
 
+module_param(forcecrt2type, charp, 0);
 MODULE_PARM_DESC(forcecrt2type,
 	"\nForce the second display output type. Possible values are NONE,\n"
 	"LCD, TV, VGA, SVIDEO or COMPOSITE.\n");
 
-MODULE_PARM_DESC(mode,
-	"\nSelects the desired default display mode in the format XxYxDepth,\n"
-	"eg. 1024x768x16.\n");
-
+module_param(vesa, int, 0);
 MODULE_PARM_DESC(vesa,
 	"\nSelects the desired default display mode by VESA mode number, eg.\n"
 	"0x117.\n");
 
+module_param(filter, int, 0);
 MODULE_PARM_DESC(filter,
-		"\nSelects TV flicker filter type (only for systems with a SiS301 video bridge).\n"
-		"(Possible values 0-7, default: [no filter])\n");
+	"\nSelects TV flicker filter type (only for systems with a SiS301 video bridge).\n"
+	"(Possible values 0-7, default: [no filter])\n");
+
+static int __init xgifb_init(void)
+{
+	char *option = NULL;
+
+	if (forcecrt2type != NULL)
+		XGIfb_search_crt2type(forcecrt2type);
+	if (fb_get_options("xgifb", &option))
+		return -ENODEV;
+	XGIfb_setup(option);
+
+	return pci_register_driver(&xgifb_driver);
+}
 
 static void __exit xgifb_remove_module(void)
 {
@@ -2356,4 +2351,8 @@ static void __exit xgifb_remove_module(void)
 	pr_debug("Module unloaded\n");
 }
 
+MODULE_DESCRIPTION("Z7 Z9 Z9S Z11 framebuffer device driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("XGITECH , Others");
+module_init(xgifb_init);
 module_exit(xgifb_remove_module);
-- 
1.7.9.5

