Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2KIOUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46832 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab2KIOUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:39 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 06/10] drivers/mfd/sta2x11-mfd: platform probe: don't mind about gpio platform data
Date: Fri,  9 Nov 2012 15:19:57 +0100
Message-Id: <1352470801-2418-7-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The gpio platform driver will take care of its platform data,
let's not do any checks here.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index b981dc4..2c8d65e 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -553,7 +553,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 {
 	int err, i;
 	struct sta2x11_mfd_setup_data *setup_data;
-	struct sta2x11_gpio_pdata *gpio_data;
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
@@ -571,16 +570,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 		&mfd_setup_data[STA2X11_MFD0] :
 		&mfd_setup_data[STA2X11_MFD1];
 
-	/* Read gpio config data as pci device's platform data */
-	gpio_data = dev_get_platdata(&pdev->dev);
-	if (!gpio_data)
-		dev_warn(&pdev->dev, "no gpio configuration\n");
-
-	dev_dbg(&pdev->dev, "%s, gpio_data = %p (%p)\n", __func__,
-		gpio_data, &gpio_data);
-	dev_dbg(&pdev->dev, "%s, pdev = %p (%p)\n", __func__,
-		pdev, &pdev);
-
 	/* platform data is the pci device for all of them */
 	sta2x11_mfd_setup(pdev, setup_data);
 
-- 
1.7.10.4

