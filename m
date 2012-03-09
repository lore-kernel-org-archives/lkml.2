Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506Ab2CITux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031332Ab2CITut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:49 -0500
Message-Id: <20120309190209.937912706@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Danny Kukawka <danny.kukawka@bisect.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 95/95] spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit c88db233251b026fda775428f0250c760553e216 upstream.

Rename static struct pci_driver pch_spi_pcidev to
pch_spi_pcidev_driver to get rid of warnings from modpost checks.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1717,7 +1717,7 @@ static int pch_spi_resume(struct pci_dev
 
 #endif
 
-static struct pci_driver pch_spi_pcidev = {
+static struct pci_driver pch_spi_pcidev_driver = {
 	.name = "pch_spi",
 	.id_table = pch_spi_pcidev_id,
 	.probe = pch_spi_probe,
@@ -1733,7 +1733,7 @@ static int __init pch_spi_init(void)
 	if (ret)
 		return ret;
 
-	ret = pci_register_driver(&pch_spi_pcidev);
+	ret = pci_register_driver(&pch_spi_pcidev_driver);
 	if (ret)
 		return ret;
 
@@ -1743,7 +1743,7 @@ module_init(pch_spi_init);
 
 static void __exit pch_spi_exit(void)
 {
-	pci_unregister_driver(&pch_spi_pcidev);
+	pci_unregister_driver(&pch_spi_pcidev_driver);
 	platform_driver_unregister(&pch_spi_pd_driver);
 }
 module_exit(pch_spi_exit);


