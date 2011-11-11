Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1KKQQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:16:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab1KKQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:14:45 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, netdev@vger.kernel.org,
        jcliburn@gmail.com, chris.snook@gmail.com
Subject: [PATCH V2 2/6] net/ethernet/atl1e: Disable ASPM
Date: Fri, 11 Nov 2011 11:14:20 -0500
Message-Id: <1321028064-644-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1321028064-644-1-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.atheros.cz/atheros-inf-file.php?inf=209&chipset=45&system=6
indicates that ASPM is disabled on all L1E hardware. Duplicate for sanity.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: netdev@vger.kernel.org
Cc: jcliburn@gmail.com
Cc: chris.snook@gmail.com
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 95483bc..fc74dd1 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2264,6 +2264,9 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	int err = 0;
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "cannot enable PCI device\n");
-- 
1.7.7.1

