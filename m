Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0KJPwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:52:20 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59028 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0KJPwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:52:18 -0500
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
Subject: [PATCH v1.3 1/4] lib: hex2bin converts ascii hexadecimal string to binary
Date: Wed, 10 Nov 2010 10:51:46 -0500
Message-Id: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the kgdb_hex2mem() code, hex2bin converts a string
to binary using the hex_to_bin() library call.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
---
 include/linux/kernel.h |    1 +
 lib/hexdump.c          |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3f648d2..b03aa43 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -419,6 +419,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 extern int hex_to_bin(char ch);
+extern void hex2bin(unsigned char *mem, char *buf, int count);
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 5d7a480..66f96bb 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -34,6 +34,22 @@ int hex_to_bin(char ch)
 EXPORT_SYMBOL(hex_to_bin);
 
 /**
+ * hex2bin - convert an ascii hexadecimal string to its binary representation
+ * @mem: result
+ * @buf: ascii hexadecimal string
+ * @count: result length
+ */
+void hex2bin(unsigned char *mem, char *buf, int count)
+{
+	while (count--) {
+		*mem = hex_to_bin(*buf++) << 4;
+		*mem += hex_to_bin(*buf++);
+		mem++;
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

