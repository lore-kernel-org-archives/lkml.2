Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1IWKsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:48:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:47025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1IWKr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,428,1312182000"; 
   d="scan'208";a="54688447"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] kernel.h: rename pack_hex_byte to hex_pack_byte
Date: Fri, 23 Sep 2011 13:47:26 +0300
Message-Id: <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <20110919232602.ac450450.akpm00@gmail.com>
References: <20110919232602.ac450450.akpm00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Andrew Morton in [1] there is better to have most significant
part first in the function name.

[1] https://lkml.org/lkml/2011/9/20/22

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/kernel.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 46ac9a5..5022158 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -374,13 +374,18 @@ extern const char hex_asc[];
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
 extern void hex2bin(u8 *dst, const char *src, size_t count);
 
-- 
1.7.6.3

