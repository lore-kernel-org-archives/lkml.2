Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2GDWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:07:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2GDWH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:07:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/4] tpm_atmel: Use struct dev_pm_ops for power management
Date: Thu, 5 Jul 2012 00:10:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
References: <201207050008.02097.rjw@sisk.pl>
In-Reply-To: <201207050008.02097.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207050010.31787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the tpm_atmel driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

This allows the driver to use tpm_pm_suspend() and tpm_pm_resume()
as its PM callbacks directly, without defining its own PM callback
routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/tpm/tpm_atmel.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux/drivers/char/tpm/tpm_atmel.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm_atmel.c
+++ linux/drivers/char/tpm/tpm_atmel.c
@@ -168,22 +168,14 @@ static void atml_plat_remove(void)
 	}
 }
 
-static int tpm_atml_suspend(struct platform_device *dev, pm_message_t msg)
-{
-	return tpm_pm_suspend(&dev->dev);
-}
+static SIMPLE_DEV_PM_OPS(tpm_atml_pm, tpm_pm_suspend, tpm_pm_resume);
 
-static int tpm_atml_resume(struct platform_device *dev)
-{
-	return tpm_pm_resume(&dev->dev);
-}
 static struct platform_driver atml_drv = {
 	.driver = {
 		.name = "tpm_atmel",
 		.owner		= THIS_MODULE,
+		.pm		= &tpm_atml_pm,
 	},
-	.suspend = tpm_atml_suspend,
-	.resume = tpm_atml_resume,
 };
 
 static int __init init_atmel(void)

