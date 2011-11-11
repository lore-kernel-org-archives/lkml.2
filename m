Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1KKQFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1KKQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:05:38 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, netdev@vger.kernel.org,
        cooldavid@cooldavid.org
Subject: [PATCH 3/6] net/ethernet/jme: Disable ASPM
Date: Fri, 11 Nov 2011 11:05:08 -0500
Message-Id: <1321027511-31229-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1321027511-31229-1-git-send-email-mjg@redhat.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://driveragent.com/archive/30421/7-0-14 indicates that ASPM is
disabled on the 250 and 260. Duplicate for sanity.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: netdev@vger.kernel.org
Cc: cooldavid@cooldavid.org
---
 drivers/net/ethernet/jme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 7becff1..b28a873 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2860,6 +2860,9 @@ jme_init_one(struct pci_dev *pdev,
 	/*
 	 * set up PCI device basics
 	 */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	rc = pci_enable_device(pdev);
 	if (rc) {
 		pr_err("Cannot enable PCI device\n");
-- 
1.7.7.1

