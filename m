Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1KPDBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:01:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50775 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1KPDBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:01:13 -0500
From: Rob Herring <robherring2@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Richard Zhu <richard.zhu@linaro.org>,
        Anton Vorontsov <avorontsov@mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci_platform: fix DT probing
Date: Tue, 15 Nov 2011 21:00:56 -0600
Message-Id: <1321412456-31107-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The change in commit 904c04feaf13ed "ahci_platform: Add the board_ids..."
doesn't work for the DT probing case as platform_get_device_id returns
NULL. Pick the default ahci_port_info in this case.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Richard Zhu <richard.zhu@linaro.org>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/ata/ahci_platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ec55595..43b8758 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -67,7 +67,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	const struct platform_device_id *id = platform_get_device_id(pdev);
-	struct ata_port_info pi = ahci_port_info[id->driver_data];
+	struct ata_port_info pi = ahci_port_info[id ? id->driver_data : 0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-- 
1.7.5.4

