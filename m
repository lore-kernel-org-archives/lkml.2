Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2FQUZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:25:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2FQUZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:25:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 3/5] acer-wmi: Use struct dev_pm_ops for power management
Date: Sun, 17 Jun 2012 22:28:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
References: <201206172226.42729.rjw@sisk.pl>
In-Reply-To: <201206172226.42729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172228.59364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the acer-wmi driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/acer-wmi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/platform/x86/acer-wmi.c
===================================================================
--- linux.orig/drivers/platform/x86/acer-wmi.c
+++ linux/drivers/platform/x86/acer-wmi.c
@@ -1877,8 +1877,7 @@ static int acer_platform_remove(struct p
 	return 0;
 }
 
-static int acer_platform_suspend(struct platform_device *dev,
-pm_message_t state)
+static int acer_suspend(struct device *dev)
 {
 	u32 value;
 	struct acer_data *data = &interface->data;
@@ -1900,7 +1899,7 @@ pm_message_t state)
 	return 0;
 }
 
-static int acer_platform_resume(struct platform_device *device)
+static int acer_resume(struct device *dev)
 {
 	struct acer_data *data = &interface->data;
 
@@ -1916,6 +1915,8 @@ static int acer_platform_resume(struct p
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acer_pm, acer_suspend, acer_resume);
+
 static void acer_platform_shutdown(struct platform_device *device)
 {
 	struct acer_data *data = &interface->data;
@@ -1931,11 +1932,10 @@ static struct platform_driver acer_platf
 	.driver = {
 		.name = "acer-wmi",
 		.owner = THIS_MODULE,
+		.pm = &acer_pm,
 	},
 	.probe = acer_platform_probe,
 	.remove = acer_platform_remove,
-	.suspend = acer_platform_suspend,
-	.resume = acer_platform_resume,
 	.shutdown = acer_platform_shutdown,
 };
 

