Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab0D3SVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:21:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63529 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab0D3RXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:23:13 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/10] drivers: net: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:03 +0300
Message-Id: <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:08.0945 (UTC) FILETIME=[48C21A10:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using own implementation involve hex_to_bin() function. It requires
to have hex_to_bin() introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/sb1250-mac.c |   32 ++------------------------------
 1 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 9944e5d..34f8753 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -2184,34 +2184,6 @@ static void sbmac_setmulti(struct sbmac_softc *sc)
 
 #if defined(SBMAC_ETH0_HWADDR) || defined(SBMAC_ETH1_HWADDR) || defined(SBMAC_ETH2_HWADDR) || defined(SBMAC_ETH3_HWADDR)
 /**********************************************************************
- *  SBMAC_PARSE_XDIGIT(str)
- *
- *  Parse a hex digit, returning its value
- *
- *  Input parameters:
- *  	   str - character
- *
- *  Return value:
- *  	   hex value, or -1 if invalid
- ********************************************************************* */
-
-static int sbmac_parse_xdigit(char str)
-{
-	int digit;
-
-	if ((str >= '0') && (str <= '9'))
-		digit = str - '0';
-	else if ((str >= 'a') && (str <= 'f'))
-		digit = str - 'a' + 10;
-	else if ((str >= 'A') && (str <= 'F'))
-		digit = str - 'A' + 10;
-	else
-		return -1;
-
-	return digit;
-}
-
-/**********************************************************************
  *  SBMAC_PARSE_HWADDR(str,hwaddr)
  *
  *  Convert a string in the form xx:xx:xx:xx:xx:xx into a 6-byte
@@ -2231,7 +2203,7 @@ static int sbmac_parse_hwaddr(char *str, unsigned char *hwaddr)
 	int idx = 6;
 
 	while (*str && (idx > 0)) {
-		digit1 = sbmac_parse_xdigit(*str);
+		digit1 = hex_to_bin(*str);
 		if (digit1 < 0)
 			return -1;
 		str++;
@@ -2243,7 +2215,7 @@ static int sbmac_parse_hwaddr(char *str, unsigned char *hwaddr)
 			digit1 = 0;
 		}
 		else {
-			digit2 = sbmac_parse_xdigit(*str);
+			digit2 = hex_to_bin(*str);
 			if (digit2 < 0)
 				return -1;
 			str++;
-- 
1.6.3.3

