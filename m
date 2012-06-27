Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2F0JFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:05:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24379 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2F0JFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:05:33 -0400
Date: Wed, 27 Jun 2012 12:05:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] [SCSI] isci: add a couple __iomem annotations
Message-ID: <20120627090521.GM31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are __iomem.  Sparse complains if we don't have that.

drivers/scsi/isci/phy.c +149 70: warning:
        incorrect type in initializer (different address spaces)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Sent on Wed, 18 Jan 2012.

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index bc8981e..4a095f3 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1973,7 +1973,7 @@ static void sci_controller_afe_initialization(struct isci_host *ihost)
 	}
 
 	for (phy_id = 0; phy_id < SCI_MAX_PHYS; phy_id++) {
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_id];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_id];
 		const struct sci_phy_oem_params *oem_phy = &oem->phys[phy_id];
 		int cable_length_long =
 			is_long_cable(phy_id, cable_selection_mask);
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 18f43d4..7b60353 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -169,7 +169,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	phy_cap.gen1_no_ssc = 1;
 	if (ihost->oem_parameters.controller.do_enable_ssc) {
 		struct scu_afe_registers __iomem *afe = &ihost->scu_registers->afe;
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_idx];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_idx];
 		struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
 		bool en_sas = false;
 		bool en_sata = false;
