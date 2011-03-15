Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1COIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:52:19 -0400
Received: from portal.weinmann.de ([62.8.140.122]:11082 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1COIwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:52:17 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 04:52:17 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Nicolas Ferre'" <nicolas.ferre@atmel.com>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Mar 2011 09:35:59 +0100
Subject: [PATCH] drivers/usb/host/ehci-atmel.c: fix section mismatch warning
Thread-Topic: [PATCH] drivers/usb/host/ehci-atmel.c: fix section mismatch
 warning
Thread-Index: Acvi7AJSw3Se6NltRcSKBKSUh7uE+w==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D068D5C0F27@wm021.weinmann.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following section mismatch warning:

WARNING: drivers/usb/host/ehci-hcd.o(.data+0x0): Section mismatch in reference
from the variable ehci_atmel_driver to the function
.init.text:ehci_atmel_drv_probe()
The variable ehci_atmel_driver references
the function __init ehci_atmel_drv_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/usb/host/ehci-atmel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index d6a69d5..b2ed55c 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -115,7 +115,7 @@ static const struct hc_driver ehci_atmel_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
-static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
+static int __devinit ehci_atmel_drv_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	const struct hc_driver *driver = &ehci_atmel_hc_driver;
@@ -207,7 +207,7 @@ fail_create_hcd:
 	return retval;
 }
 
-static int __exit ehci_atmel_drv_remove(struct platform_device *pdev)
+static int __devexit ehci_atmel_drv_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
@@ -227,7 +227,7 @@ static int __exit ehci_atmel_drv_remove(struct platform_device *pdev)
 
 static struct platform_driver ehci_atmel_driver = {
 	.probe		= ehci_atmel_drv_probe,
-	.remove		= __exit_p(ehci_atmel_drv_remove),
+	.remove		= __devexit_p(ehci_atmel_drv_remove),
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver.name	= "atmel-ehci",
 };
-- 
1.5.4.3

