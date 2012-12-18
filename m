Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2LROjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:39:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42782 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2LROjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:39:14 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-f9-50d080104fa7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        jg1.han@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com
Subject: [PATCH v5 3/4] USB: ehci-s5p: Add phy driver support
Date: Tue, 18 Dec 2012 20:13:05 +0530
Message-id: <1355841786-13307-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkRleg4UKAwesJJhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbRv2chesFOrYs7RS+wNjJOVuxg5OCQETCR+
	z+XoYuQEMsUkLtxbz9bFyMUhJLCUUeLWhDVMEAkTiaadu6AS0xkl5ryeww7hTGaSWP7zPRtI
	FZuArkTT212MILaIgKzE4Su/mUGKmAV6mSVOnTzCApIQFrCVuHq7jwVkNYuAqsSTKeEgYV4B
	D4kF02+zQmxTkHhz+xkziM0p4CnReOQYE0i5EFBN120pkDCLgIDEt8mHWCAekJXYdABsk4TA
	YzaJ7d/fskOMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxAoPy9L9n
	UjsYVzZYHGIU4GBU4uG9kX8hQIg1say4MvcQowQHs5II75s4oBBvSmJlVWpRfnxRaU5q8SFG
	H6BLJjJLiSbnAyMmryTe0NjE3NTY1NLIyMzUFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5O
	qQZGu903Xm6qas53OpDzL+NK18y3PxpPzv4Rft5i50QpicTI5eW/vyyMUdi0JOcJI3epW/Xh
	SKXSW2GnNX/vOb3+kumZ20Ld2h/dBObdmXL09Ke7E3rP9MvGsAf6nviuUxwQaF3olZiVt/er
	5hE/+5ATreF+8SJLSz7tYFTv0pCre7S+5fPZN3uUlFiKMxINtZiLihMBedW4IncCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQV2BhgsBBgcvalhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRvmUj
	e8FOrYo5Ry+xNzBOVu5i5OSQEDCRaNq5iw3CFpO4cG89kM3FISQwnVFizus57BDOZCaJ5T/f
	g1WxCehKNL3dxQhiiwjIShy+8psZpIhZoJdZ4tTJIywgCWEBW4mrt/uAbA4OFgFViSdTwkHC
	vAIeEgum32aF2KYg8eb2M2YQm1PAU6LxyDEmkHIhoJqu21ITGHkXMDKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAgO+mdSOxhXNlgcYhTgYFTi4b2RfyFAiDWxrLgy9xCjBAezkgjvmzig
	EG9KYmVValF+fFFpTmrxIUYfoJsmMkuJJucDIzKvJN7Q2MTc1NjU0sTCxMwSh7CSOG+zR0qA
	kEB6YklqdmpqQWoRzDgmDk6pBsY0X7a8S/wRTzhMmI/WV+QdPXX/4uUs5f79u5d/vfH0dek3
	nf1WPFqCRytzap2u1678wp5zKnme7aVqNglGXv60ZzYfrpV6G7XujjilZfVnRvKFjIe+4acm
	Rh+QeMjKbNZvqFnb37462GTxhupd5t80VpzX1bi3xfXgFSMOi9OSX+3v3+o6rq3EUpyRaKjF
	XFScCADiqX4+pwIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the phy driver to ehci-s5p. Keeping the platform data
for continuing the smooth operation for boards which still uses it

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/usb/host/ehci-s5p.c |   70 ++++++++++++++++++++++++++++++-------------
 1 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 46ca5ef..50c93af 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
@@ -33,6 +34,8 @@ struct s5p_ehci_hcd {
 	struct device *dev;
 	struct usb_hcd *hcd;
 	struct clk *clk;
+	struct usb_phy *phy;
+	struct s5p_ehci_platdata *pdata;
 };
 
 static const struct hc_driver s5p_ehci_hc_driver = {
@@ -66,6 +69,30 @@ static const struct hc_driver s5p_ehci_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+static void s5p_ehci_phy_enable(struct s5p_ehci_hcd *s5p_ehci)
+{
+	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
+
+	if (s5p_ehci->phy) {
+		samsung_usbphy_set_type(s5p_ehci->phy, USB_PHY_TYPE_HOST);
+		usb_phy_init(s5p_ehci->phy);
+	} else if (s5p_ehci->pdata->phy_init) {
+		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	}
+}
+
+static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
+{
+	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
+
+	if (s5p_ehci->phy) {
+		samsung_usbphy_set_type(s5p_ehci->phy, USB_PHY_TYPE_HOST);
+		usb_phy_shutdown(s5p_ehci->phy);
+	} else if (s5p_ehci->pdata->phy_exit) {
+		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	}
+}
+
 static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
 	int err;
@@ -88,20 +115,15 @@ static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
 
 static int s5p_ehci_probe(struct platform_device *pdev)
 {
-	struct s5p_ehci_platdata *pdata;
+	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	struct s5p_ehci_hcd *s5p_ehci;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
+	struct usb_phy *phy;
 	int irq;
 	int err;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "No platform data defined\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Right now device-tree probed devices don't get dma_mask set.
 	 * Since shared usb code relies on it, set it here for now.
@@ -119,6 +141,19 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	if (!s5p_ehci)
 		return -ENOMEM;
 
+	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR_OR_NULL(phy)) {
+		/* Fallback to pdata */
+		if (!pdata) {
+			dev_err(&pdev->dev, "no platform data or transceiver defined\n");
+			return -EPROBE_DEFER;
+		} else {
+			s5p_ehci->pdata = pdata;
+		}
+	} else {
+		s5p_ehci->phy = phy;
+	}
+
 	s5p_ehci->dev = &pdev->dev;
 
 	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
@@ -164,8 +199,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	if (pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	s5p_ehci_phy_enable(s5p_ehci);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -176,13 +210,15 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto fail_io;
+		goto fail_add_hcd;
 	}
 
 	platform_set_drvdata(pdev, s5p_ehci);
 
 	return 0;
 
+fail_add_hcd:
+	s5p_ehci_phy_disable(s5p_ehci);
 fail_io:
 	clk_disable_unprepare(s5p_ehci->clk);
 fail_clk:
@@ -192,14 +228,12 @@ fail_clk:
 
 static int s5p_ehci_remove(struct platform_device *pdev)
 {
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	struct s5p_ehci_hcd *s5p_ehci = platform_get_drvdata(pdev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
 
 	usb_remove_hcd(hcd);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	s5p_ehci_phy_disable(s5p_ehci);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -223,14 +257,11 @@ static int s5p_ehci_suspend(struct device *dev)
 	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
 	bool do_wakeup = device_may_wakeup(dev);
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	int rc;
 
 	rc = ehci_suspend(hcd, do_wakeup);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	s5p_ehci_phy_disable(s5p_ehci);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -241,13 +272,10 @@ static int s5p_ehci_resume(struct device *dev)
 {
 	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = s5p_ehci->hcd;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 
 	clk_prepare_enable(s5p_ehci->clk);
 
-	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	s5p_ehci_phy_enable(s5p_ehci);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
-- 
1.7.6.5

