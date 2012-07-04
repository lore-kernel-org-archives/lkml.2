Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2GDWHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:07:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2GDWH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:07:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/4]  PM / TPM: Drop unused pm_message_t argument from tpm_pm_suspend()
Date: Thu, 5 Jul 2012 00:09:52 +0200
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
Message-Id: <201207050009.52375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The tpm_pm_suspend()'s second argument of type pm_message_t is not
used, so remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/tpm/tpm.c       |    2 +-
 drivers/char/tpm/tpm.h       |    2 +-
 drivers/char/tpm/tpm_atmel.c |    2 +-
 drivers/char/tpm/tpm_nsc.c   |    2 +-
 drivers/char/tpm/tpm_tis.c   |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/char/tpm/tpm.h
===================================================================
--- linux.orig/drivers/char/tpm/tpm.h
+++ linux/drivers/char/tpm/tpm.h
@@ -299,7 +299,7 @@ extern ssize_t tpm_write(struct file *,
 			 loff_t *);
 extern ssize_t tpm_read(struct file *, char __user *, size_t, loff_t *);
 extern void tpm_remove_hardware(struct device *);
-extern int tpm_pm_suspend(struct device *, pm_message_t);
+extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *);
Index: linux/drivers/char/tpm/tpm_atmel.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm_atmel.c
+++ linux/drivers/char/tpm/tpm_atmel.c
@@ -170,7 +170,7 @@ static void atml_plat_remove(void)
 
 static int tpm_atml_suspend(struct platform_device *dev, pm_message_t msg)
 {
-	return tpm_pm_suspend(&dev->dev, msg);
+	return tpm_pm_suspend(&dev->dev);
 }
 
 static int tpm_atml_resume(struct platform_device *dev)
Index: linux/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm_tis.c
+++ linux/drivers/char/tpm/tpm_tis.c
@@ -750,7 +750,7 @@ static int __devinit tpm_tis_pnp_init(st
 
 static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
 {
-	return tpm_pm_suspend(&dev->dev, msg);
+	return tpm_pm_suspend(&dev->dev);
 }
 
 static int tpm_tis_pnp_resume(struct pnp_dev *dev)
@@ -808,7 +808,7 @@ MODULE_PARM_DESC(hid, "Set additional sp
 #endif
 static int tpm_tis_suspend(struct platform_device *dev, pm_message_t msg)
 {
-	return tpm_pm_suspend(&dev->dev, msg);
+	return tpm_pm_suspend(&dev->dev);
 }
 
 static int tpm_tis_resume(struct platform_device *dev)
Index: linux/drivers/char/tpm/tpm_nsc.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm_nsc.c
+++ linux/drivers/char/tpm/tpm_nsc.c
@@ -276,7 +276,7 @@ static void tpm_nsc_remove(struct device
 
 static int tpm_nsc_suspend(struct platform_device *dev, pm_message_t msg)
 {
-	return tpm_pm_suspend(&dev->dev, msg);
+	return tpm_pm_suspend(&dev->dev);
 }
 
 static int tpm_nsc_resume(struct platform_device *dev)
Index: linux/drivers/char/tpm/tpm.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm.c
+++ linux/drivers/char/tpm/tpm.c
@@ -1274,7 +1274,7 @@ static struct tpm_input_header savestate
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
  */
-int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
+int tpm_pm_suspend(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct tpm_cmd_t cmd;

