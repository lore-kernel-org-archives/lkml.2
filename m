Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2F3VxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 17:53:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2F3VwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 17:52:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 2/2] msi-laptop: Use struct dev_pm_ops for power management
Date: Sat, 30 Jun 2012 23:57:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Frank Seidel <frank@f-seidel.de>, "Lee, Chun-Yi" <jlee@novell.com>
References: <201206302356.11014.rjw@sisk.pl>
In-Reply-To: <201206302356.11014.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206302357.43405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the msi-laptop driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/msi-laptop.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/platform/x86/msi-laptop.c
===================================================================
--- linux.orig/drivers/platform/x86/msi-laptop.c
+++ linux/drivers/platform/x86/msi-laptop.c
@@ -85,7 +85,8 @@
 #define MSI_STANDARD_EC_TOUCHPAD_ADDRESS	0xe4
 #define MSI_STANDARD_EC_TOUCHPAD_MASK		(1 << 4)
 
-static int msi_laptop_resume(struct platform_device *device);
+static int msi_laptop_resume(struct device *device);
+static SIMPLE_DEV_PM_OPS(msi_laptop_pm, NULL, msi_laptop_resume);
 
 #define MSI_STANDARD_EC_DEVICES_EXISTS_ADDRESS	0x2f
 
@@ -437,8 +438,8 @@ static struct platform_driver msipf_driv
 	.driver = {
 		.name = "msi-laptop-pf",
 		.owner = THIS_MODULE,
+		.pm = &msi_laptop_pm,
 	},
-	.resume = msi_laptop_resume,
 };
 
 static struct platform_device *msipf_device;
@@ -752,7 +753,7 @@ err_bluetooth:
 	return retval;
 }
 
-static int msi_laptop_resume(struct platform_device *device)
+static int msi_laptop_resume(struct device *device)
 {
 	u8 data;
 	int result;

