Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2BBNVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:21:02 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36051 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab2BBNU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:20:58 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Danny Kukawka <dkukawka@suse.de>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver
Date: Thu,  2 Feb 2012 14:20:30 +0100
Message-Id: <1328188830-28133-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
References: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328188858;67df008a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename static struct pci_driver pch_spi_pcidev to
pch_spi_pcidev_driver to get rid of warnings from modpost checks.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 2a6429d..10182eb 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1720,7 +1720,7 @@ static int pch_spi_resume(struct pci_dev *pdev)
 
 #endif
 
-static struct pci_driver pch_spi_pcidev = {
+static struct pci_driver pch_spi_pcidev_driver = {
 	.name = "pch_spi",
 	.id_table = pch_spi_pcidev_id,
 	.probe = pch_spi_probe,
@@ -1736,7 +1736,7 @@ static int __init pch_spi_init(void)
 	if (ret)
 		return ret;
 
-	ret = pci_register_driver(&pch_spi_pcidev);
+	ret = pci_register_driver(&pch_spi_pcidev_driver);
 	if (ret)
 		return ret;
 
@@ -1746,7 +1746,7 @@ module_init(pch_spi_init);
 
 static void __exit pch_spi_exit(void)
 {
-	pci_unregister_driver(&pch_spi_pcidev);
+	pci_unregister_driver(&pch_spi_pcidev_driver);
 	platform_driver_unregister(&pch_spi_pd_driver);
 }
 module_exit(pch_spi_exit);
-- 
1.7.7.3

