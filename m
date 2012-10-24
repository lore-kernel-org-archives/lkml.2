Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2JXDFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:05:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59237 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2JXDFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:05:39 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] staging/sbe-2t3e3: Use netdev_ printks in main.c
Date: Wed, 24 Oct 2012 12:05:28 +0900
Message-Id: <1351047928-7234-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121019191038.GA18369@kroah.com>
References: <20121019191038.GA18369@kroah.com>
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
index f3dbef6..c8e0398 100644
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

