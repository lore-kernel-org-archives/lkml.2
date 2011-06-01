Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1FAGol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:44:41 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:48499 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1FAGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:44:40 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_phub: Don't panic if dmi_get_system_info returns NULL
Date: Wed,  1 Jun 2011 08:44:29 +0200
Message-Id: <1306910669-19348-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/misc/pch_phub.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 5fe79df..01eb67b 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -686,6 +686,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 	}
 
 	if (id->driver_data == 1) { /* EG20T PCH */
+		const char *board_name;
+
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
 		if (retval)
@@ -701,7 +703,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CANCLK_MASK);
 
 		/* quirk for CM-iTC board */
-		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+		board_name = dmi_get_system_info(DMI_BOARD_NAME);
+		if (board_name && strstr(board_name, "CM-iTC"))
 			pch_phub_read_modify_write_reg(chip,
 						(unsigned int)CLKCFG_REG_OFFSET,
 						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
-- 
1.7.3.4

