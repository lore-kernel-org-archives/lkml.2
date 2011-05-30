Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1E3Mdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:33:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38170 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab1E3Mdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HBbdcon4yo2NDAtMXxqX/OPzyEK7dwWzdDsIHbBGvpNWyjZMLTbgf2sP+A1Cw/l0NU
         OK3WfrqMSl7ltyb/TwHubqcej5XYzRfUCpvPfSzDvCbraKXE96PuSFqWcYsDYKHp/QMr
         nBUhJT+U9g23L2+z2XkyHXk+HYBBDPJWik8SY=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] sdhci: fix undue iomem warning
Date: Mon, 30 May 2011 20:33:16 +0800
Message-Id: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some newer SDHCI controllers have memory mapped I/O regions of 512
bytes, so accept these without warning.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 936bbca..ae948b0 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -918,8 +918,9 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 		return ERR_PTR(-ENODEV);
 	}
 
-	if (pci_resource_len(pdev, bar) != 0x100) {
-		dev_err(&pdev->dev, "Invalid iomem size. You may "
+	int len = pci_resource_len(pdev, bar);
+	if (len != 0x100 && len != 0x200) {
+		dev_warn(&pdev->dev, "Invalid iomem size. You may "
 			"experience problems.\n");
 	}
 
-- 
1.7.4.1

