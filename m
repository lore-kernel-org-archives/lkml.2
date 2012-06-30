Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2F3VwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 17:52:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47512 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab2F3VwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 17:52:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 1/2] hdaps: Use struct dev_pm_ops for power management
Date: Sat, 30 Jun 2012 23:56:59 +0200
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
Message-Id: <201206302356.59946.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the HDAPS driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/hdaps.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/drivers/platform/x86/hdaps.c
===================================================================
--- linux.orig/drivers/platform/x86/hdaps.c
+++ linux/drivers/platform/x86/hdaps.c
@@ -305,17 +305,19 @@ static int hdaps_probe(struct platform_d
 	return 0;
 }
 
-static int hdaps_resume(struct platform_device *dev)
+static int hdaps_resume(struct device *dev)
 {
 	return hdaps_device_init();
 }
 
+static SIMPLE_DEV_PM_OPS(hdaps_pm, NULL, hdaps_resume);
+
 static struct platform_driver hdaps_driver = {
 	.probe = hdaps_probe,
-	.resume = hdaps_resume,
 	.driver	= {
 		.name = "hdaps",
 		.owner = THIS_MODULE,
+		.pm = &hdaps_pm,
 	},
 };
 

