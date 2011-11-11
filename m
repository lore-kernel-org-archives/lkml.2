Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1KKQGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab1KKQGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:06:12 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, mike.miller@hp.com,
        iss_storagedev@hp.com, axboe@kernel.dk
Subject: [PATCH 4/6] block/cciss: Disable ASPM
Date: Fri, 11 Nov 2011 11:05:09 -0500
Message-Id: <1321027511-31229-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1321027511-31229-1-git-send-email-mjg@redhat.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Windows driver .inf disables ASPM on all cciss devices. Do the same.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: mike.miller@hp.com
Cc: iss_storagedev@hp.com
Cc: axboe@kernel.dk
---
 drivers/block/cciss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 486f94e..7e43ad3 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4319,6 +4319,10 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
+
+	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_warn(&h->pdev->dev, "Unable to Enable PCI device\n");
-- 
1.7.7.1

