Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2J1IHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:07:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44729 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755047Ab2J1IHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:07:30 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:40 -0700
Message-Id: <ff89ae9b42c644728575a3cf606184ab9875d6e9.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_cmd64x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 7ba0141..2949cfc 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -474,14 +474,14 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* check for enabled ports */
 	pci_read_config_byte(pdev, CNTRL, &reg);
 	if (!port_ok)
-		dev_printk(KERN_NOTICE, &pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
+		dev_notice(&pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
 	if (port_ok && cntrl_ch0_ok && !(reg & CNTRL_CH0)) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Primary port is disabled\n");
+		dev_notice(&pdev->dev, "Primary port is disabled\n");
 		ppi[0] = &ata_dummy_port_info;
 
 	}
 	if (port_ok && !(reg & CNTRL_CH1)) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Secondary port is disabled\n");
+		dev_notice(&pdev->dev, "Secondary port is disabled\n");
 		ppi[1] = &ata_dummy_port_info;
 	}
 
-- 
1.7.8.112.g3fd21

