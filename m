Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1CINFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:05:46 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51970 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1CINFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:05:45 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] rtc-mrst: Fix section types
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it
Date: Wed, 09 Mar 2011 12:44:39 +0000
Message-ID: <20110309124431.20581.3589.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Major Lee <major_lee@wistron.com>

Fix the following section mismatch warning.

WARNING: drivers/rtc/built-in.o(.data+0xa0): Section mismatch in
reference from the variable vrtc_mrst_platform_driver to the function
.init.text:vrtc_mrst_platform_probe()
The variable vrtc_mrst_platform_driver references
the function __init vrtc_mrst_platform_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Major Lee <major_lee@wistron.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/rtc/rtc-mrst.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 28e02e7..4c3e251 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -360,7 +360,7 @@ static irqreturn_t mrst_rtc_irq(int irq, void *p)
 	return IRQ_NONE;
 }
 
-static int __init
+static int __devinit
 vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 {
 	int retval = 0;
@@ -432,7 +432,7 @@ static void rtc_mrst_do_shutdown(void)
 	spin_unlock_irq(&rtc_lock);
 }
 
-static void __exit rtc_mrst_do_remove(struct device *dev)
+static void __devexit rtc_mrst_do_remove(struct device *dev)
 {
 	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
 	struct resource *iomem;
@@ -541,14 +541,14 @@ static inline int mrst_poweroff(struct device *dev)
 
 #endif
 
-static int __init vrtc_mrst_platform_probe(struct platform_device *pdev)
+static int __devinit vrtc_mrst_platform_probe(struct platform_device *pdev)
 {
 	return vrtc_mrst_do_probe(&pdev->dev,
 			platform_get_resource(pdev, IORESOURCE_MEM, 0),
 			platform_get_irq(pdev, 0));
 }
 
-static int __exit vrtc_mrst_platform_remove(struct platform_device *pdev)
+static int __devexit vrtc_mrst_platform_remove(struct platform_device *pdev)
 {
 	rtc_mrst_do_remove(&pdev->dev);
 	return 0;
@@ -566,7 +566,7 @@ MODULE_ALIAS("platform:vrtc_mrst");
 
 static struct platform_driver vrtc_mrst_platform_driver = {
 	.probe		= vrtc_mrst_platform_probe,
-	.remove		= __exit_p(vrtc_mrst_platform_remove),
+	.remove		= __devexit_p(vrtc_mrst_platform_remove),
 	.shutdown	= vrtc_mrst_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,

