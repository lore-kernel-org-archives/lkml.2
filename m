Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2JBOXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:23:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33941 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903Ab2JBOXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:23:02 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-pcil@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] revert "PCI: log vendor/device ID always"
Date: Tue,  2 Oct 2012 09:23:00 -0500
Message-Id: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert commit id 2c6413aee215a43b1f95e218067abcde50ccbc5e
On larger systems (256 cores+) with signifigant IO attached this single message
represents over 20% of the messages at boot.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 drivers/pci/probe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9f8a6b7..a1add54 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1002,8 +1002,8 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->revision = class & 0xff;
 	dev->class = class >> 8;		    /* upper 3 bytes */
 
-	dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %02x class %#08x\n",
-		   dev->vendor, dev->device, dev->hdr_type, dev->class);
+	dev_dbg(&dev->dev, "[%04x:%04x] type %02x class %#08x\n",
+		dev->vendor, dev->device, dev->hdr_type, dev->class);
 
 	/* need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
-- 
1.6.0.2

