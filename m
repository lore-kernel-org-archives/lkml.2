Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0EQUQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:16:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45294 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0EQUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:16:32 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-nforce2: Remove redundant error messages on ACPI conflict
Date: Mon, 17 May 2010 16:16:19 -0400
Message-Id: <1274127379-5433-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI subsystem strictly checks for resource conflicts. When there's
a conflict, it outputs a warning message with all the details needed to
properly diagnose the underlying issue. However, the i2c-nforce2 driver
also prints its own message. Not only is the message redundant, it is at
the KERN_ERR level, which overrides some bootsplash screens for no good
reason. This change removes the two lines that print out the error
messages.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/i2c/busses/i2c-nforce2.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 4a48dd4..2da9a23 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -405,7 +405,6 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
 	/* SMBus adapter 1 */
 	res1 = nforce2_probe_smb(dev, 4, NFORCE_PCI_SMB1, &smbuses[0], "SMB1");
 	if (res1 < 0) {
-		dev_err(&dev->dev, "Error probing SMB1.\n");
 		smbuses[0].base = 0;	/* to have a check value */
 	}
 	/* SMBus adapter 2 */
@@ -417,7 +416,6 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
 		res2 = nforce2_probe_smb(dev, 5, NFORCE_PCI_SMB2, &smbuses[1],
 					 "SMB2");
 		if (res2 < 0) {
-			dev_err(&dev->dev, "Error probing SMB2.\n");
 			smbuses[1].base = 0;	/* to have a check value */
 		}
 	}
-- 
1.7.0.4

