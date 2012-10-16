Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2JPCFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:05:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43203 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2JPCFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:05:11 -0400
From: "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tools/include: use stdint types for user-space byteshift headers
Date: Mon, 15 Oct 2012 21:04:44 -0500
Message-Id: <1350353084-2684-1-git-send-email-yselkowitz@users.sourceforge.net>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>

Commit a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c added user-space copies
of the byteshift headers to be used by hostprogs, changing e.g. u8 to __u8.
However, in order to cross-compile the kernel from a non-Linux system,
stdint.h types need to be used instead of linux/types.h types.

Signed-off-by: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
---
Ping 2; still hasn't been merged and no on-list response to original 
posted of 11 June.

Also applies to linux-3.[3456].y

 tools/include/tools/be_byteshift.h |   34 +++++++++++++++++-----------------
 tools/include/tools/le_byteshift.h |   34 +++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
index f4912e2..84c17d8 100644
--- a/tools/include/tools/be_byteshift.h
+++ b/tools/include/tools/be_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_BE_BYTESHIFT_H
 #define _TOOLS_BE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <stdint.h>
 
-static inline __u16 __get_unaligned_be16(const __u8 *p)
+static inline uint16_t __get_unaligned_be16(const uint8_t *p)
 {
 	return p[0] << 8 | p[1];
 }
 
-static inline __u32 __get_unaligned_be32(const __u8 *p)
+static inline uint32_t __get_unaligned_be32(const uint8_t *p)
 {
 	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
-static inline __u64 __get_unaligned_be64(const __u8 *p)
+static inline uint64_t __get_unaligned_be64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_be32(p) << 32 |
+	return (uint64_t)__get_unaligned_be32(p) << 32 |
 	       __get_unaligned_be32(p + 4);
 }
 
-static inline void __put_unaligned_be16(__u16 val, __u8 *p)
+static inline void __put_unaligned_be16(uint16_t val, uint8_t *p)
 {
 	*p++ = val >> 8;
 	*p++ = val;
 }
 
-static inline void __put_unaligned_be32(__u32 val, __u8 *p)
+static inline void __put_unaligned_be32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_be16(val >> 16, p);
 	__put_unaligned_be16(val, p + 2);
 }
 
-static inline void __put_unaligned_be64(__u64 val, __u8 *p)
+static inline void __put_unaligned_be64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_be32(val >> 32, p);
 	__put_unaligned_be32(val, p + 4);
 }
 
-static inline __u16 get_unaligned_be16(const void *p)
+static inline uint16_t get_unaligned_be16(const void *p)
 {
-	return __get_unaligned_be16((const __u8 *)p);
+	return __get_unaligned_be16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_be32(const void *p)
+static inline uint32_t get_unaligned_be32(const void *p)
 {
-	return __get_unaligned_be32((const __u8 *)p);
+	return __get_unaligned_be32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_be64(const void *p)
+static inline uint64_t get_unaligned_be64(const void *p)
 {
-	return __get_unaligned_be64((const __u8 *)p);
+	return __get_unaligned_be64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_be16(__u16 val, void *p)
+static inline void put_unaligned_be16(uint16_t val, void *p)
 {
 	__put_unaligned_be16(val, p);
 }
 
-static inline void put_unaligned_be32(__u32 val, void *p)
+static inline void put_unaligned_be32(uint32_t val, void *p)
 {
 	__put_unaligned_be32(val, p);
 }
 
-static inline void put_unaligned_be64(__u64 val, void *p)
+static inline void put_unaligned_be64(uint64_t val, void *p)
 {
 	__put_unaligned_be64(val, p);
 }
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
index c99d45a..8fe9f24 100644
--- a/tools/include/tools/le_byteshift.h
+++ b/tools/include/tools/le_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_LE_BYTESHIFT_H
 #define _TOOLS_LE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <stdint.h>
 
-static inline __u16 __get_unaligned_le16(const __u8 *p)
+static inline uint16_t __get_unaligned_le16(const uint8_t *p)
 {
 	return p[0] | p[1] << 8;
 }
 
-static inline __u32 __get_unaligned_le32(const __u8 *p)
+static inline uint32_t __get_unaligned_le32(const uint8_t *p)
 {
 	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
 }
 
-static inline __u64 __get_unaligned_le64(const __u8 *p)
+static inline uint64_t __get_unaligned_le64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_le32(p + 4) << 32 |
+	return (uint64_t)__get_unaligned_le32(p + 4) << 32 |
 	       __get_unaligned_le32(p);
 }
 
-static inline void __put_unaligned_le16(__u16 val, __u8 *p)
+static inline void __put_unaligned_le16(uint16_t val, uint8_t *p)
 {
 	*p++ = val;
 	*p++ = val >> 8;
 }
 
-static inline void __put_unaligned_le32(__u32 val, __u8 *p)
+static inline void __put_unaligned_le32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_le16(val >> 16, p + 2);
 	__put_unaligned_le16(val, p);
 }
 
-static inline void __put_unaligned_le64(__u64 val, __u8 *p)
+static inline void __put_unaligned_le64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_le32(val >> 32, p + 4);
 	__put_unaligned_le32(val, p);
 }
 
-static inline __u16 get_unaligned_le16(const void *p)
+static inline uint16_t get_unaligned_le16(const void *p)
 {
-	return __get_unaligned_le16((const __u8 *)p);
+	return __get_unaligned_le16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_le32(const void *p)
+static inline uint32_t get_unaligned_le32(const void *p)
 {
-	return __get_unaligned_le32((const __u8 *)p);
+	return __get_unaligned_le32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_le64(const void *p)
+static inline uint64_t get_unaligned_le64(const void *p)
 {
-	return __get_unaligned_le64((const __u8 *)p);
+	return __get_unaligned_le64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_le16(__u16 val, void *p)
+static inline void put_unaligned_le16(uint16_t val, void *p)
 {
 	__put_unaligned_le16(val, p);
 }
 
-static inline void put_unaligned_le32(__u32 val, void *p)
+static inline void put_unaligned_le32(uint32_t val, void *p)
 {
 	__put_unaligned_le32(val, p);
 }
 
-static inline void put_unaligned_le64(__u64 val, void *p)
+static inline void put_unaligned_le64(uint64_t val, void *p)
 {
 	__put_unaligned_le64(val, p);
 }
-- 
1.7.9

