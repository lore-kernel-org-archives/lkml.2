Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab2HVTEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:04:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46809 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2HVTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:04:08 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] misc/at25: Add an .id_table to at25 to facilitate driver loading and binding.
Date: Wed, 22 Aug 2012 12:03:58 -0700
Message-Id: <1345662238-15211-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com>
References: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

With this patch we get automatic driver loading and binding for device
tree specified hardware typologies.  Also recognize "st,m95256"
devices as being compatible with the driver.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/misc/eeprom/at25.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 4ed93dd..bd4a6c7 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -470,12 +470,19 @@ static int __devexit at25_remove(struct spi_device *spi)
 }
 
 /*-------------------------------------------------------------------------*/
+static const struct spi_device_id at25_id[] = {
+	{"at25", 0},
+	{"m95256", 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, at25_id);
 
 static struct spi_driver at25_driver = {
 	.driver = {
 		.name		= "at25",
 		.owner		= THIS_MODULE,
 	},
+	.id_table	= at25_id,
 	.probe		= at25_probe,
 	.remove		= __devexit_p(at25_remove),
 };
@@ -485,4 +492,3 @@ module_spi_driver(at25_driver);
 MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
 MODULE_AUTHOR("David Brownell");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("spi:at25");
-- 
1.7.11.4

