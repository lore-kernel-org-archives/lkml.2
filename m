Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2I0N6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:58:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2I0N57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:57:59 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] staging/sbe-2t3e3: Use netdev_ printks in main.c
Date: Thu, 27 Sep 2012 22:57:51 +0900
Message-Id: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/sbe-2t3e3/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/main.c b/drivers/staging/sbe-2t3e3/main.c
index f3dbef6..48d80eb 100644
--- a/drivers/staging/sbe-2t3e3/main.c
+++ b/drivers/staging/sbe-2t3e3/main.c
@@ -135,9 +135,10 @@ void t3e3_read_card_serial_number(struct channel *sc)
 	for (i = 0; i < 3; i++)
 		sc->ether.card_serial_number[i] = t3e3_eeprom_read_word(sc, 10 + i);
 
-	printk(KERN_INFO "SBE wanPMC-2T3E3 serial number: %04X%04X%04X\n",
-	       sc->ether.card_serial_number[0], sc->ether.card_serial_number[1],
-	       sc->ether.card_serial_number[2]);
+	netdev_info(sc->dev, "SBE wanPMC-2T3E3 serial number: %04X%04X%04X\n",
+		    sc->ether.card_serial_number[0], 
+		    sc->ether.card_serial_number[1],
+		    sc->ether.card_serial_number[2]);
 }
 
 /*
-- 
1.7.9.5

