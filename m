Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1GVDiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:38:01 -0400
Received: from lunge.queued.net ([173.255.254.236]:55521 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1GVDh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:37:58 -0400
Date: Thu, 21 Jul 2011 20:37:55 -0700
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/3] staging: olpc_dcon: drop support for DCON v1
Message-ID: <20110721203755.4d59fc47@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v1 DCONs only existed for XO-1 prototypes (and even then, very very
early prototypes).  Drop support for v1 DCON.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index cf4b454..ae18cd4 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -88,29 +88,18 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 	}
 
 	if (ver < 0xdc02) {
-		/* Initialize the DCON registers */
-
-		/* Start with work-arounds for DCON ASIC */
-		i2c_smbus_write_word_data(client, 0x4b, 0x00cc);
-		i2c_smbus_write_word_data(client, 0x4b, 0x00cc);
-		i2c_smbus_write_word_data(client, 0x4b, 0x00cc);
-		i2c_smbus_write_word_data(client, 0x0b, 0x007a);
-		i2c_smbus_write_word_data(client, 0x36, 0x025c);
-		i2c_smbus_write_word_data(client, 0x37, 0x025e);
-
-		/* Initialise SDRAM */
-
-		i2c_smbus_write_word_data(client, 0x3b, 0x002b);
-		i2c_smbus_write_word_data(client, 0x41, 0x0101);
-		i2c_smbus_write_word_data(client, 0x42, 0x0101);
-	} else {
-		/* SDRAM setup/hold time */
-		i2c_smbus_write_word_data(client, 0x3a, 0xc040);
-		i2c_smbus_write_word_data(client, 0x41, 0x0000);
-		i2c_smbus_write_word_data(client, 0x41, 0x0101);
-		i2c_smbus_write_word_data(client, 0x42, 0x0101);
+		dev_err(&dcon->client->dev,
+				"DCON v1 is unsupported, giving up..\n");
+		rc = -ENODEV;
+		goto err;
 	}
 
+	/* SDRAM setup/hold time */
+	i2c_smbus_write_word_data(client, 0x3a, 0xc040);
+	i2c_smbus_write_word_data(client, 0x41, 0x0000);
+	i2c_smbus_write_word_data(client, 0x41, 0x0101);
+	i2c_smbus_write_word_data(client, 0x42, 0x0101);
+
 	/* Colour swizzle, AA, no passthrough, backlight */
 	if (is_init) {
 		dcon->disp_mode = MODE_PASSTHRU | MODE_BL_ENABLE |
-- 
1.7.2.5

