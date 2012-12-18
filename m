Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2LROjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:39:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47138 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2LROjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:39:17 -0500
X-AuditID: cbfee61b-b7f616d00000319b-59-50d08013b2c3
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        jg1.han@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com
Subject: [PATCH v5 4/4] USB: ohci-exynos: Add phy driver support
Date: Tue, 18 Dec 2012 20:13:06 +0530
Message-id: <1355841786-13307-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkWle44UKAwdJ5phaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZSx9vJix4L9WxYbOBcwNjO+Uuxg5OSQETCRm
	9t5igrDFJC7cW8/WxcjFISSwlFHi3pG/7DBFM6bMYIdITGeUmNpwnQXCmcwkcaj/MDNIFZuA
	rkTT212MILaIgKzE4Su/mUGKmAV6mSVOnTzCApIQFnCQODFjDxuIzSKgKtEz/Q1YA6+Ah8T+
	A/NYINYpSLy5/QxsKKeAp0TjkWNA93EAbfOQ6LotBdEqIPFt8iEWkLAE0K5NB8BWSQg8Z5OY
	sWU31BhJiYMrbrBMYBRewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMwME//eya9g3FV
	g8UhRgEORiUe3p/x5wOEWBPLiitzDzFKcDArifC+ibsQIMSbklhZlVqUH19UmpNafIjRB+iS
	icxSosn5wKjJK4k3NDYxNzU2tTQyMjM1xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoFx
	UpLl2x+mU/wPfX3t9VX2o+ZKfoFmdqtEq4uOOea+z0/NrjdafkOza2fHleJdjzjFVu35MFHS
	46dwy6PDNz4z7tJjK2iP92BR9UxKnztBhUexaMFDNgYPr4W8Kqs+MqUsi6g+x/zug930BxJv
	+FUchP+s4JlhOqk5WmFJXLRZ45O+5UZM64SVWIozEg21mIuKEwFfTVyMeQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV3hhgsBBheualhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix9PFi
	xoL/WhUbOhcwNzC+U+5i5OSQEDCRmDFlBjuELSZx4d56ti5GLg4hgemMElMbrrNAOJOZJA71
	H2YGqWIT0JVoeruLEcQWEZCVOHzlNzNIEbNAL7PEqZNHWEASwgIOEidm7GEDsVkEVCV6pr8B
	a+AV8JDYf2AeC8Q6BYk3t5+BDeUU8JRoPHKMqYuRA2ibh0TXbakJjLwLGBlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgSH/TPpHYyrGiwOMQpwMCrx8P6MPx8gxJpYVlyZe4hRgoNZSYT3
	TdyFACHelMTKqtSi/Pii0pzU4kOMPkBHTWSWEk3OB8ZkXkm8obGJuamxqaWJhYmZJQ5hJXHe
	Zo+UACGB9MSS1OzU1ILUIphxTBycUg2ME4xu/1lxKHba1p9aL8xZZMKcFuWmPlkdsldl8UG+
	n2u+WqRc8ropdjR9brKX1vurNzJsut7lRBvOrd33YkG6PfdKpdUH3u+z1V/iF29bquu1Keeg
	SnXYurcnsw1+SMvkNWm89rrRUXlCMnfnFx6hQKe0qzvtsvXbyzNjKm7FnRBaEqr86UWGEktx
	RqKhFnNRcSIAAyIMKKgCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the phy-driver to ohci-exynos. Keeping the platform data
for continuing the smooth operation for boards which still uses it

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/usb/host/ohci-exynos.c |   70 ++++++++++++++++++++++++++++------------
 1 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 804fb62..c92ab7b 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-exynos.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
@@ -22,8 +23,34 @@ struct exynos_ohci_hcd {
 	struct device *dev;
 	struct usb_hcd *hcd;
 	struct clk *clk;
+	struct usb_phy *phy;
+	struct exynos4_ohci_platdata *pdata;
 };
 
+static void exynos_ohci_phy_enable(struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
+
+	if (exynos_ohci->phy) {
+		samsung_usbphy_set_type(exynos_ohci->phy, USB_PHY_TYPE_HOST);
+		usb_phy_init(exynos_ohci->phy);
+	} else if (exynos_ohci->pdata->phy_init) {
+		exynos_ohci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	}
+}
+
+static void exynos_ohci_phy_disable(struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
+
+	if (exynos_ohci->phy) {
+		samsung_usbphy_set_type(exynos_ohci->phy, USB_PHY_TYPE_HOST);
+		usb_phy_shutdown(exynos_ohci->phy);
+	} else if (exynos_ohci->pdata->phy_exit) {
+		exynos_ohci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	}
+}
+
 static int ohci_exynos_reset(struct usb_hcd *hcd)
 {
 	return ohci_init(hcd_to_ohci(hcd));
@@ -79,20 +106,15 @@ static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
 
 static int exynos_ohci_probe(struct platform_device *pdev)
 {
-	struct exynos4_ohci_platdata *pdata;
+	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct ohci_hcd *ohci;
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
@@ -108,6 +130,19 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	if (!exynos_ohci)
 		return -ENOMEM;
 
+	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR_OR_NULL(phy)) {
+		/* Fallback to pdata */
+		if (!pdata) {
+			dev_err(&pdev->dev, "no platform data or transceiver defined\n");
+			return -EPROBE_DEFER;
+		} else {
+			exynos_ohci->pdata = pdata;
+		}
+	} else {
+		exynos_ohci->phy = phy;
+	}
+
 	exynos_ohci->dev = &pdev->dev;
 
 	hcd = usb_create_hcd(&exynos_ohci_hc_driver, &pdev->dev,
@@ -153,8 +188,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	if (pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	exynos_ohci_phy_enable(exynos_ohci);
 
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -162,13 +196,15 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto fail_io;
+		goto fail_add_hcd;
 	}
 
 	platform_set_drvdata(pdev, exynos_ohci);
 
 	return 0;
 
+fail_add_hcd:
+	exynos_ohci_phy_disable(exynos_ohci);
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
@@ -178,14 +214,12 @@ fail_clk:
 
 static int exynos_ohci_remove(struct platform_device *pdev)
 {
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_ohci_hcd *exynos_ohci = platform_get_drvdata(pdev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
 
 	usb_remove_hcd(hcd);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	exynos_ohci_phy_disable(exynos_ohci);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -209,8 +243,6 @@ static int exynos_ohci_suspend(struct device *dev)
 	struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	unsigned long flags;
 	int rc = 0;
 
@@ -229,8 +261,7 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	exynos_ohci_phy_disable(exynos_ohci);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -244,13 +275,10 @@ static int exynos_ohci_resume(struct device *dev)
 {
 	struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	exynos_ohci_phy_enable(exynos_ohci);
 
 	ohci_resume(hcd, false);
 
-- 
1.7.6.5

