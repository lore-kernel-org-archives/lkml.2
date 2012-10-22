Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2JVOvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:51:36 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:50388 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab2JVOvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:51:33 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 06/10] drivers/mfd/sta2x11-mfd: platform probe: don't mind about gpio platform data
Date: Mon, 22 Oct 2012 16:50:37 +0200
Message-Id: <1350917441-4478-7-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com>
References: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com>
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
index c7e95d0..d6e1626 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -550,7 +550,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 {
 	int err, i;
 	struct sta2x11_mfd_setup_data *setup_data;
-	struct sta2x11_gpio_pdata *gpio_data;
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
@@ -568,16 +567,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
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

