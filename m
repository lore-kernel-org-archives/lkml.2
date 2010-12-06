Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0LFFo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:44:57 -0500
Received: from mail.perches.com ([173.55.12.10]:2289 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0LFFo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:44:29 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org
Subject: [PATCH 5/7] include/linux/printk.h lib/hexdump.c: Neatening and add CONFIG_PRINTK guard
Date: Sun,  5 Dec 2010 21:44:19 -0800
Message-Id: <c64db63a5cc37114259cba025377c44d4953b288.1291611192.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1291611190.git.joe@perches.com>
References: <cover.1291611190.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototypes and align arguments.
Add CONFIG_PRINTK guard for print_hex functions

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   42 ++++++++++++++++++++++++++++--------------
 lib/hexdump.c          |    2 ++
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8a9a2ee..a705a91 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -140,20 +140,6 @@ static inline void log_buf_kexec_setup(void)
 
 extern void dump_stack(void) __cold;
 
-enum {
-	DUMP_PREFIX_NONE,
-	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
-};
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
-extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
-extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
-
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
@@ -285,4 +271,32 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
+#ifdef CONFIG_PRINTK
+extern void print_hex_dump(const char *level, const char *prefix_str,
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+				 const void *buf, size_t len);
+#else
+static inline void print_hex_dump(const char *level, const char *prefix_str,
+				  int prefix_type, int rowsize, int groupsize,
+				  const void *buf, size_t len, bool ascii)
+{
+}
+static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+					const void *buf, size_t len)
+{
+}
+
+#endif
+
 #endif
diff --git a/lib/hexdump.c b/lib/hexdump.c
index b66b2bd..f5fe6ba 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -154,6 +154,7 @@ nil:
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
+#ifdef CONFIG_PRINTK
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
  * @level: kernel log level (e.g. KERN_DEBUG)
@@ -238,3 +239,4 @@ void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 		       buf, len, true);
 }
 EXPORT_SYMBOL(print_hex_dump_bytes);
+#endif
-- 
1.7.3.2.245.g03276.dirty

