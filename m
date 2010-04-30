Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab0D3TJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:09:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59900 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab0D3RAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:40 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/10] drivers: isdn: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:01 +0300
Message-Id: <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:09.0413 (UTC) FILETIME=[49098350:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/isdn/gigaset/capi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 964a55f..ac4cfee 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -170,17 +170,6 @@ static inline void ignore_cstruct_param(struct cardstate *cs, _cstruct param,
 }
 
 /*
- * convert hex to binary
- */
-static inline u8 hex2bin(char c)
-{
-	int result = c & 0x0f;
-	if (c & 0x40)
-		result += 9;
-	return result;
-}
-
-/*
  * convert an IE from Gigaset hex string to ETSI binary representation
  * including length byte
  * return value: result length, -1 on error
@@ -191,7 +180,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)
 	while (*in) {
 		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >= maxlen)
 			return -1;
-		out[++l] = (hex2bin(in[0]) << 4) + hex2bin(in[1]);
+		out[++l] = (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
 		in += 2;
 	}
 	out[0] = l;
-- 
1.6.3.3

