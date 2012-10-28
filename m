Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2J1IJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:09:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37364 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755184Ab2J1IIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:08:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 08/16] i2c: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:46 -0700
Message-Id: <3e4988b083a8b5d03a458aabc18042cedb3dbd8a.1351411047.git.joe@perches.com>
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
 drivers/i2c/busses/i2c-piix4.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 8bbd6ec..f7216ed 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -204,9 +204,8 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 			 */
 			pci_write_config_byte(PIIX4_dev, SMBHSTCFG,
 					      temp | 1);
-			dev_printk(KERN_NOTICE, &PIIX4_dev->dev,
-				"WARNING: SMBus interface has been "
-				"FORCEFULLY ENABLED!\n");
+			dev_notice(&PIIX4_dev->dev,
+				   "WARNING: SMBus interface has been FORCEFULLY ENABLED!\n");
 		} else {
 			dev_err(&PIIX4_dev->dev,
 				"Host SMBus controller not enabled!\n");
-- 
1.7.8.112.g3fd21

