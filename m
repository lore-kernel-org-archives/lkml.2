Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2IJIxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:53:11 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24804 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2IJIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcCAHGoTVBbdWObgWdsb2JhbABFhUBHtUoiAQEWJieCIQEFIwQLATQSECUCJgICVwYTiBSoFZI7gSGPFoESA5VdiTOJUg
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262505"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 12/20] Staging: ipack/bridges/tpci200: increment the reference counter of the pci_dev
Date: Mon, 10 Sep 2012 10:51:50 +0200
Message-Id: <1347267118-9580-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As indicated in the documentation of pci_dev_get.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 5150794..c1ce311 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -672,6 +672,8 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 		goto out_err_info;
 	}
 
+	pci_dev_get(pdev);
+
 	/* Obtain a mapping of the carrier's PCI configuration registers */
 	ret = pci_request_region(pdev, TPCI200_CFG_MEM_BAR,
 				 KBUILD_MODNAME " Configuration Memory");
@@ -743,6 +745,7 @@ out_err_install:
 out_err_ioremap:
 	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
 out_err_pci_request:
+	pci_dev_put(pdev);
 	kfree(tpci200->info);
 out_err_info:
 	kfree(tpci200);
-- 
1.7.10.4

