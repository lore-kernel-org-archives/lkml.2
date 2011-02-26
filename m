Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1BZXQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:16:20 -0500
Received: from cernmx32.cern.ch ([137.138.144.178]:9716 "EHLO CERNMX32.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1BZXP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:15:58 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <julia@diku.dk>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/1] staging: vme: remove unreachable code
Date: Sun, 27 Feb 2011 00:15:35 +0100
Message-ID: <1298762135-8752-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298762135-8752-1-git-send-email-manohar.vanga@cern.ch>
References: <1298762135-8752-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some more unreachable code found in bridges/vme_ca91cx42.c
and bridges/vme_tsi148.c

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    3 ---
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 42de83e..5d734d9 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -560,8 +560,6 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 
 	return 0;
 
-	iounmap(image->kern_base);
-	image->kern_base = NULL;
 err_remap:
 	release_resource(&image->bus_resource);
 err_resource:
@@ -1782,7 +1780,6 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-	vme_unregister_bridge(ca91cx42_bridge);
 err_reg:
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 26ea42f..2df19ea 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -869,8 +869,6 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 
 	return 0;
 
-	iounmap(image->kern_base);
-	image->kern_base = NULL;
 err_remap:
 	release_resource(&image->bus_resource);
 err_resource:
-- 
1.7.1

