Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2DNFFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:05:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab2DNFFy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:05:54 -0400
Message-ID: <1334379950.7150.407.camel@deadeye>
Subject: [PATCH] doc, bitmap: Fix kernel-doc for bitmap_parselist(),
 bitmap_parselist_user()
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Apr 2012 06:05:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move and adjust kernel-doc from __bitmap_parselist() to
bitmap_parselist(), as only the latter is declared extern.

Fix the summary line for bitmap_parselist_user().

Replace outdated statement that bitmap_parselist_user() is a wraper
for bitmap_parselist() with the relevant fact that it has the same
range of return values.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/bitmap.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0d4a127..38c2a1c 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -570,26 +570,6 @@ int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 }
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
-/**
- * __bitmap_parselist - convert list format ASCII string to bitmap
- * @buf: read nul-terminated user string from this buffer
- * @buflen: buffer size in bytes.  If string is smaller than this
- *    then it must be terminated with a \0.
- * @is_user: location of buffer, 0 indicates kernel space
- * @maskp: write resulting mask here
- * @nmaskbits: number of bits in mask to be written
- *
- * Input format is a comma-separated list of decimal numbers and
- * ranges.  Consecutively set bits are shown as two hyphen-separated
- * decimal numbers, the smallest and largest bit numbers set in
- * the range.
- *
- * Returns 0 on success, -errno on invalid input strings.
- * Error values:
- *    %-EINVAL: second number in range smaller than first
- *    %-EINVAL: invalid character in string
- *    %-ERANGE: bit number specified too large for mask
- */
 static int __bitmap_parselist(const char *buf, unsigned int buflen,
 		int is_user, unsigned long *maskp,
 		int nmaskbits)
@@ -660,6 +640,23 @@ static int __bitmap_parselist(const char *buf, unsigned int buflen,
 	return 0;
 }
 
+/**
+ * bitmap_parselist - convert list format ASCII string to bitmap
+ * @bp: read nul-terminated string from this buffer
+ * @maskp: write resulting mask here
+ * @nmaskbits: number of bits in mask to be written
+ *
+ * Input format is a comma-separated list of decimal numbers and
+ * ranges.  Consecutively set bits are shown as two hyphen-separated
+ * decimal numbers, the smallest and largest bit numbers set in
+ * the range.
+ *
+ * Returns 0 on success, -errno on invalid input strings.
+ * Error values:
+ *    %-EINVAL: second number in range smaller than first
+ *    %-EINVAL: invalid character in string
+ *    %-ERANGE: bit number specified too large for mask
+ */
 int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
 {
 	char *nl  = strchr(bp, '\n');
@@ -676,7 +673,7 @@ EXPORT_SYMBOL(bitmap_parselist);
 

 /**
- * bitmap_parselist_user()
+ * bitmap_parselist_user - convert list format ASCII user buffer to bitmap
  *
  * @ubuf: pointer to user buffer containing string.
  * @ulen: buffer size in bytes.  If string is smaller than this
@@ -684,7 +681,7 @@ EXPORT_SYMBOL(bitmap_parselist);
  * @maskp: pointer to bitmap array that will contain result.
  * @nmaskbits: size of bitmap, in bits.
  *
- * Wrapper for bitmap_parselist(), providing it with user buffer.
+ * Return values are as for bitmap_parselist().
  *
  * We cannot have this as an inline function in bitmap.h because it needs
  * linux/uaccess.h to get the access_ok() declaration and this causes
-- 
1.7.9.5


