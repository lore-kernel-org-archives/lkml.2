Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935309Ab1ETFNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:13:41 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51667 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935215Ab1ETFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:13:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/12] staging: usbip: vhci_hcd.c: rename init and exit functions
Date: Thu, 19 May 2011 21:37:06 -0700
Message-Id: <bd7f81f595fb8b19530f0a5373092fa27d58e7c1.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the prefix of the __init and __exit functions to vhci_hcd_ to
correspond with the modules name. And change the suffix of the __exit
function to exit instead of cleanup.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci_hcd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 5b94b80..359b464 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1209,7 +1209,7 @@ static struct platform_device the_pdev = {
 	},
 };
 
-static int __init vhci_init(void)
+static int __init vhci_hcd_init(void)
 {
 	int ret;
 
@@ -1233,14 +1233,14 @@ err_driver_register:
 	return ret;
 }
 
-static void __exit vhci_cleanup(void)
+static void __exit vhci_hcd_exit(void)
 {
 	platform_device_unregister(&the_pdev);
 	platform_driver_unregister(&vhci_driver);
 }
 
-module_init(vhci_init);
-module_exit(vhci_cleanup);
+module_init(vhci_hcd_init);
+module_exit(vhci_hcd_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.5.1

