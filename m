Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0FOOSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:18:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52749 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0FOOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mUudzq1Ym1B1Z+kTftCRM6jwPQ4jOH/w8op8h/ko1GQ7bz+xOjnpodKb6/sEGLgVwJ
         ZHCrMTICniUIS4b/xXoa2ZH2GyuDkxeIwI5FQz82yRfU7dHaYJ2yCuflE/L3lh5aLgPV
         4EVc7Unb96qi+89vXTcpfQROsoFZdk0l9YFPI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers: net: use new hex_to_bin() method
Date: Tue, 15 Jun 2010 17:18:29 +0300
Message-Id: <1276611509-27637-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: Divy Le Ray <divy@chelsio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/cxgb3/t3_hw.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 95a8ba0..427c451 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -679,14 +679,6 @@ int t3_seeprom_wp(struct adapter *adapter, int enable)
 	return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 0xc : 0);
 }
 
-/*
- * Convert a character holding a hex digit to a number.
- */
-static unsigned int hex2int(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 /**
  *	get_vpd_params - read VPD parameters from VPD EEPROM
  *	@adapter: adapter to read
@@ -727,15 +719,15 @@ static int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		p->port_type[0] = uses_xaui(adapter) ? 1 : 2;
 		p->port_type[1] = uses_xaui(adapter) ? 6 : 2;
 	} else {
-		p->port_type[0] = hex2int(vpd.port0_data[0]);
-		p->port_type[1] = hex2int(vpd.port1_data[0]);
+		p->port_type[0] = hex_to_bin(vpd.port0_data[0]);
+		p->port_type[1] = hex_to_bin(vpd.port1_data[0]);
 		p->xauicfg[0] = simple_strtoul(vpd.xaui0cfg_data, NULL, 16);
 		p->xauicfg[1] = simple_strtoul(vpd.xaui1cfg_data, NULL, 16);
 	}
 
 	for (i = 0; i < 6; i++)
-		p->eth_base[i] = hex2int(vpd.na_data[2 * i]) * 16 +
-				 hex2int(vpd.na_data[2 * i + 1]);
+		p->eth_base[i] = hex_to_bin(vpd.na_data[2 * i]) * 16 +
+				 hex_to_bin(vpd.na_data[2 * i + 1]);
 	return 0;
 }
 
-- 
1.6.6.1

