Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab1KKQO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:14:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962Ab1KKQOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:14:55 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, mike.miller@hp.com,
        iss_storagedev@hp.com, axboe@kernel.dk
Subject: [PATCH V2 4/6] block/cciss: Disable ASPM
Date: Fri, 11 Nov 2011 11:14:22 -0500
Message-Id: <1321028064-644-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1321028064-644-1-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
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
 drivers/block/cciss.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 486f94e..92d8a2f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -4319,6 +4320,10 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
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

