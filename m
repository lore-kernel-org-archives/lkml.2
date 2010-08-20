Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0HTBz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:55:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35693 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTBzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DUx2ZlnCL0aG6DSA1yKrSZM0HTvPQbAefiE7UQILDjVcA9xCbRRY9b/TlNXfTSf6pP
         zEO+/2rncQTeCWp5osD4A2I+1tpss6IAZp1/fsnuNQyrLmv1vtDrmd8fOEl4EzOZ6Uxa
         lHpdziNLANQFbESmwSv8/c07GAUxGq7h196qw=
Subject: [PATCH 1/4] regulator/wm831x-dcdc: fix potential NULL dereference
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 09:58:38 +0800
Message-Id: <1282269518.31048.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata is dereferenced earlier than tested for being NULL.
Thus move the dereference of "pdata" below the check for NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index dbfaf59..ed66fac 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -501,14 +501,17 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
 
+	if (pdata == NULL)
+		return -ENODEV;
+
+	id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
-	if (pdata == NULL || pdata->dcdc[id] == NULL)
+	if (pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
 	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
@@ -704,14 +707,17 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
 
+	if (pdata == NULL)
+		return -ENODEV;
+
+	id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
-	if (pdata == NULL || pdata->dcdc[id] == NULL)
+	if (pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
 	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
@@ -834,14 +840,17 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
 
+	if (pdata == NULL)
+		return -ENODEV;
+
+	id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
-	if (pdata == NULL || pdata->dcdc[id] == NULL)
+	if (pdata->dcdc[id] == NULL)
 		return -ENODEV;
 
 	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
@@ -940,13 +949,16 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->epe);
 	struct wm831x_dcdc *dcdc;
-	int ret;
+	int id, ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
 
+	id = pdev->id % ARRAY_SIZE(pdata->epe);
 	dev_dbg(&pdev->dev, "Probing EPE%d\n", id + 1);
 
-	if (pdata == NULL || pdata->epe[id] == NULL)
+	if (pdata->epe[id] == NULL)
 		return -ENODEV;
 
 	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
-- 
1.7.2



