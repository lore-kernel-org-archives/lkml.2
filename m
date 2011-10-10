Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1JJOeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:34:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:9492 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1JJOeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:34:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="61737382"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 1/5] lib: rename pack_hex_byte to hex_byte_pack
Date: Mon, 10 Oct 2011 17:33:35 +0300
Message-Id: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
References: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Andrew Morton in [1] there is better to have most significant
part first in the function name.

[1] https://lkml.org/lkml/2011/9/20/22

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/kernel.h |    7 ++++++-
 lib/vsprintf.c         |   14 +++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a10ed77..4c0d3b2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -376,13 +376,18 @@ extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
 
-static inline char *pack_hex_byte(char *buf, u8 byte)
+static inline char *hex_byte_pack(char *buf, u8 byte)
 {
 	*buf++ = hex_asc_hi(byte);
 	*buf++ = hex_asc_lo(byte);
 	return buf;
 }
 
+static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
+{
+	return hex_byte_pack(buf, byte);
+}
+
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c1a3927..993599e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -547,7 +547,7 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 	}
 
 	for (i = 0; i < 6; i++) {
-		p = pack_hex_byte(p, addr[i]);
+		p = hex_byte_pack(p, addr[i]);
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -667,13 +667,13 @@ char *ip6_compressed_string(char *p, const char *addr)
 		lo = word & 0xff;
 		if (hi) {
 			if (hi > 0x0f)
-				p = pack_hex_byte(p, hi);
+				p = hex_byte_pack(p, hi);
 			else
 				*p++ = hex_asc_lo(hi);
-			p = pack_hex_byte(p, lo);
+			p = hex_byte_pack(p, lo);
 		}
 		else if (lo > 0x0f)
-			p = pack_hex_byte(p, lo);
+			p = hex_byte_pack(p, lo);
 		else
 			*p++ = hex_asc_lo(lo);
 		needcolon = true;
@@ -695,8 +695,8 @@ char *ip6_string(char *p, const char *addr, const char *fmt)
 	int i;
 
 	for (i = 0; i < 8; i++) {
-		p = pack_hex_byte(p, *addr++);
-		p = pack_hex_byte(p, *addr++);
+		p = hex_byte_pack(p, *addr++);
+		p = hex_byte_pack(p, *addr++);
 		if (fmt[0] == 'I' && i != 7)
 			*p++ = ':';
 	}
@@ -754,7 +754,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = pack_hex_byte(p, addr[index[i]]);
+		p = hex_byte_pack(p, addr[index[i]]);
 		switch (i) {
 		case 3:
 		case 5:
-- 
1.7.6.3

