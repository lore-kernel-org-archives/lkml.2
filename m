Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab0D3TZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:25:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58032 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab0D3QsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:48:07 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/10] lib: introduce common method to convert hex digits
Date: Fri, 30 Apr 2010 12:34:00 +0300
Message-Id: <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:09.0474 (UTC) FILETIME=[4912D220:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hex_to_bin() is a little method which converts hex digit to its actual value.
There are plenty of places where such functionality is needed.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/kernel.h |    2 ++
 lib/hexdump.c          |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9365227..2077cd1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -372,6 +372,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	return buf;
 }
 
+extern int hex_to_bin(char ch);
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 39af256..d79b166 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -16,6 +16,25 @@ const char hex_asc[] = "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
 
 /**
+ * hex_to_bin - convert a hex digit to its real value
+ * @ch: ascii character represents hex digit
+ *
+ * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
+ * input.
+ */
+int hex_to_bin(char ch)
+{
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+EXPORT_SYMBOL(hex_to_bin);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
-- 
1.6.3.3

