Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2FKA7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:45 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40530 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2FKA63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 04/14] sta2x11-mfd : platform probe: don't mind about gpio platform data
Date: Mon, 11 Jun 2012 02:57:49 +0200
Message-Id: <1339376279-16753-5-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The gpio platform driver will take care of its platform data,
let's not do any checks here.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index e004c59..744bdd0 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -465,7 +465,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 {
 	int err, i;
 	struct sta2x11_mfd_setup_data *setup_data;
-	struct sta2x11_gpio_pdata *gpio_data;
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
@@ -483,16 +482,6 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
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
1.7.9.1

