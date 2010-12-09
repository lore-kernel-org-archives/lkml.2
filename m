Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0LIR0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:26:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:55817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab0LIR0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:26:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685558436"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 11/11] sep: eliminate kernel crash due to null parameter in dma_alloc_coherent
Date: Thu,  9 Dec 2010 09:32:53 -0800
Message-Id: <1291915973-18696-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index bb42b04..2681fcf 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -3442,7 +3442,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	}
 
 	sep->rar_size = FAKE_RAR_SIZE;
-	sep->rar_addr = dma_alloc_coherent(NULL,
+	sep->rar_addr = dma_alloc_coherent(&sep->pdev->dev,
 		sep->rar_size, &sep->rar_bus, GFP_KERNEL);
 	if (sep->rar_addr == NULL) {
 		dev_warn(&sep->pdev->dev, "can't allocate mfld rar\n");
-- 
1.6.3.3

