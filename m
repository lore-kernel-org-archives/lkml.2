Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792Ab0KRWnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:43:03 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49942 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab0KRWm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:42:59 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.4 1/5] lib: hex2bin converts ascii hexadecimal string to binary
Date: Thu, 18 Nov 2010 17:42:42 -0500
Message-Id: <1290120166-3132-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the kgdb_hex2mem() code, hex2bin converts a string
to binary using the hex_to_bin() library call.

Changelog:
- Replace parameter names with src/dst (based on David Howell's comment)
- Add 'const' where needed (based on David Howell's comment)
- Replace int with size_t (based on David Howell's comment)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
---
 include/linux/kernel.h |    1 +
 lib/hexdump.c          |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3f648d2..fbca217 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -419,6 +419,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 extern int hex_to_bin(char ch);
+extern void hex2bin(u8 *dst, const char *src, size_t count);
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 5d7a480..0eea94d 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -34,6 +34,22 @@ int hex_to_bin(char ch)
 EXPORT_SYMBOL(hex_to_bin);
 
 /**
+ * hex2bin - convert an ascii hexadecimal string to its binary representation
+ * @dst: binary result
+ * @src: ascii hexadecimal string
+ * @count: result length
+ */
+void hex2bin(u8 *dst, const char *src, size_t count)
+{
+	while (count--) {
+		*dst = hex_to_bin(*src++) << 4;
+		*dst += hex_to_bin(*src++);
+		dst++;
+	}
+}
+EXPORT_SYMBOL(hex2bin);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
-- 
1.7.2.2

