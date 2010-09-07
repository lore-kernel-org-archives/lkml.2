Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0IGPS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:18:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57660 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0IGPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AGVplb6OsLScgeckL8iNkGhfnqEqh5jeF6BUqpt8Hi7e+TbIcn4jy5xpYC2xB8HtR/
         +CuqEvnjQEj4qN2g/MmSb7jkpFMzXqIJd+8yw65xcPlNyFI7+eYImdo4g+6ZNUC4SU2A
         ay7zp6MOcGvuBYQGPoOJ1GYut3Zb/9FJyuihc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib: use hex_to_bin()
Date: Tue,  7 Sep 2010 18:18:05 +0300
Message-Id: <1283872685-23046-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/bitmap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index ffb78c9..741fae9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -359,7 +359,6 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area);
 
 #define CHUNKSZ				32
 #define nbits_to_hold_value(val)	fls(val)
-#define unhex(c)			(isdigit(c) ? (c - '0') : (toupper(c) - 'A' + 10))
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
 
 /**
@@ -466,7 +465,7 @@ int __bitmap_parse(const char *buf, unsigned int buflen,
 			if (chunk & ~((1UL << (CHUNKSZ - 4)) - 1))
 				return -EOVERFLOW;
 
-			chunk = (chunk << 4) | unhex(c);
+			chunk = (chunk << 4) | hex_to_bin(c);
 			ndigits++; totaldigits++;
 		}
 		if (ndigits == 0)
-- 
1.7.2.2

