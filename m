Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab0D3TDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:03:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:60020 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0D3RB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:27 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Divy Le Ray <divy@chelsio.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/10] drivers: net: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:04 +0300
Message-Id: <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:09.0757 (UTC) FILETIME=[493E00D0:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Divy Le Ray <divy@chelsio.com>
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
1.6.3.3

