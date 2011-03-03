Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1CCRwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:52:06 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:38233 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab1CCRwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:52:04 -0500
Date: Thu, 3 Mar 2011 09:51:58 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd-core: rename mfd_shared_cell_{en,dis}able to drop the
 "shared" part
Message-ID: <20110303095158.6b5fc39b@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As requested by Samuel, there's not really any reason to have "shared"
in the name.

This also modifies the only user of the function, as well.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc-xo1.c |    4 ++--
 drivers/mfd/mfd-core.c            |    8 ++++----
 include/linux/mfd/core.h          |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index f415535..9951364 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -63,7 +63,7 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 	if (!machine_is_olpc())
 		return -ENODEV;
 
-	err = mfd_shared_cell_enable(pdev);
+	err = mfd_cell_enable(pdev);
 	if (err)
 		return err;
 
@@ -88,7 +88,7 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 
 static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 {
-	mfd_shared_cell_disable(pdev);
+	mfd_cell_disable(pdev);
 
 	if (strcmp(pdev->name, "olpc-xo1-pms") == 0)
 		pms_base = 0;
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index bb2264c..79eda02 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -18,7 +18,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-int mfd_shared_cell_enable(struct platform_device *pdev)
+int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int err = 0;
@@ -33,9 +33,9 @@ int mfd_shared_cell_enable(struct platform_device *pdev)
 
 	return err;
 }
-EXPORT_SYMBOL(mfd_shared_cell_enable);
+EXPORT_SYMBOL(mfd_cell_enable);
 
-int mfd_shared_cell_disable(struct platform_device *pdev)
+int mfd_cell_disable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int err = 0;
@@ -53,7 +53,7 @@ int mfd_shared_cell_disable(struct platform_device *pdev)
 
 	return err;
 }
-EXPORT_SYMBOL(mfd_shared_cell_disable);
+EXPORT_SYMBOL(mfd_cell_disable);
 
 static int mfd_add_device(struct device *parent, int id,
 			  const struct mfd_cell *cell,
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index ed99704..1408bf8 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -59,8 +59,8 @@ struct mfd_cell {
  * being called only when a device is first being enabled or no other
  * clients are making use of it.
  */
-extern int mfd_shared_cell_enable(struct platform_device *pdev);
-extern int mfd_shared_cell_disable(struct platform_device *pdev);
+extern int mfd_cell_enable(struct platform_device *pdev);
+extern int mfd_cell_disable(struct platform_device *pdev);
 
 /*
  * Given a platform device that's been created by mfd_add_devices(), fetch
-- 
1.7.2.3

