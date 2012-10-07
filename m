Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2JGWqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 18:46:50 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56258 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2JGWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 18:46:47 -0400
From: Fabio Estevam <festevam@gmail.com>
To: jgarzik@pobox.com
Cc: rob.herring@calxeda.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] ata: sata_highbank: Fix section mismatch
Date: Sun,  7 Oct 2012 19:46:36 -0300
Message-Id: <1349649996-17115-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Building multi_v7_defconfig leads to the following warning:

WARNING: vmlinux.o(.data+0xf7d8): Section mismatch in reference from the variable ahci_highbank_driver to the function .init.text:ahci_highbank_probe()
The variable ahci_highbank_driver references
the function __init ahci_highbank_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Fix it by annotating ahci_highbank_probe as __devinit.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/ata/sata_highbank.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 0d7c4c2..36a141a 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -260,7 +260,7 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
-static int __init ahci_highbank_probe(struct platform_device *pdev)
+static int __devinit ahci_highbank_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
-- 
1.7.9.5

