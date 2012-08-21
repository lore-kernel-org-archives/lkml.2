Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2HUV3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:29:21 -0400
Received: from fieldses.org ([174.143.236.118]:35401 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab2HUV3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:29:15 -0400
Date: Tue, 21 Aug 2012 17:29:10 -0400
To: linux-kernel@vger.kernel.org
Cc: Jim Rees <rees@umich.edu>
Subject: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120821212910.GD18637@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

I've seen a couple examples recently where we've gotten this wrong.
Maybe something like this would help?  Is there some better way?

(Approximation due to Jim Rees).

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 include/linux/string.h |    6 ++++++
 net/sunrpc/cache.c     |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index ffe0442..d4809b7 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -126,6 +126,12 @@ extern void argv_free(char **argv);
 extern bool sysfs_streq(const char *s1, const char *s2);
 extern int strtobool(const char *s, bool *res);
 
+/*
+ * length of the decimal representation of an unsigned integer.  Just an
+ * approximation, but it's right for types of size 1 to 36 bytes:
+ */
+#define base10len(i) (sizeof(i) * 24 / 10 + 1)
+
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 2afd2a8..1dcd2b3 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1409,7 +1409,7 @@ static ssize_t read_flush(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos,
 			  struct cache_detail *cd)
 {
-	char tbuf[20];
+	char tbuf[base10len(long) + 2];
 	unsigned long p = *ppos;
 	size_t len;
 
-- 
1.7.9.5

