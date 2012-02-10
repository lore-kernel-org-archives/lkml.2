Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2BJXF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:05:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2BJWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:35 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.639970235@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 63/86] iommu/amd: Work around broken IVRS tables
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit af1be04901e27ce669b4ecde1c953d5c939498f5 upstream.

On some systems the IVRS table does not contain all PCI
devices present in the system. In case a device not present
in the IVRS table is translated by the IOMMU no DMA is
possible from that device by default.
This patch fixes this by removing the DTE entry for every
PCI device present in the system and not covered by IVRS.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2479,6 +2479,9 @@ static unsigned device_dma_ops_init(void
 
 	for_each_pci_dev(pdev) {
 		if (!check_device(&pdev->dev)) {
+
+			iommu_ignore_device(&pdev->dev);
+
 			unhandled += 1;
 			continue;
 		}


