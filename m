Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab1KQR37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:29:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46962 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab1KQR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:29:58 -0500
Subject: [PATCH v2] usb : gadget : usbstring : fix style problems
From: tonylijo <mail@tonylijo.in>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 22:58:57 +0530
Message-ID: <1321550937.2727.9.camel@tonylijo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fixes for problems found by checkpatch.pl in usbstring.c.

checkpatch.pl -f --terse drivers/usb/gadget/usbstring.c

drivers/usb/gadget/usbstring.c:35: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:36: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:46: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:47: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:67: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:68: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:69: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:70: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:71: ERROR: do not use C99 // comments
drivers/usb/gadget/usbstring.c:88: ERROR: trailing whitespace
drivers/usb/gadget/usbstring.c:105: WARNING: space prohibited between function name and open parenthesis '('
drivers/usb/gadget/usbstring.c:112: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:113: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:114: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:115: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:127: WARNING: space prohibited between function name and open parenthesis '('
drivers/usb/gadget/usbstring.c:127: WARNING: space prohibited between function name and open parenthesis '('
drivers/usb/gadget/usbstring.c:128: WARNING: space prohibited between function name and open parenthesis '('
drivers/usb/gadget/usbstring.c:132: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:133: ERROR: space prohibited before open square bracket '['
drivers/usb/gadget/usbstring.c:134: ERROR: space prohibited before open square bracket '['
total: 17 errors, 4 warnings, 136 lines checked

Signed-off-by: Tonylijo Jose <mail@tonylijo.in>
---

diff --git a/drivers/usb/gadget/usbstring.c b/drivers/usb/gadget/usbstring.c
index 58c4d37..d9faf8d 100644
--- a/drivers/usb/gadget/usbstring.c
+++ b/drivers/usb/gadget/usbstring.c
@@ -26,14 +26,17 @@ static int utf8_to_utf16le(const char *s, __le16 *cp, unsigned len)
 	u8	c;
 	u16	uchar;
 
-	/* this insists on correct encodings, though not minimal ones.
+	/*
+	 * this insists on correct encodings, though not minimal ones.
 	 * BUT it currently rejects legit 4-byte UTF-8 code points,
 	 * which need surrogate pairs.  (Unicode 3.1 can use them.)
 	 */
 	while (len != 0 && (c = (u8) *s++) != 0) {
 		if (unlikely(c & 0x80)) {
-			// 2-byte sequence:
-			// 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
+			/*
+			 * 2-byte sequence:
+			 * 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
+			 */
 			if ((c & 0xe0) == 0xc0) {
 				uchar = (c & 0x1f) << 6;
 
@@ -42,9 +45,10 @@ static int utf8_to_utf16le(const char *s, __le16 *cp, unsigned len)
 					goto fail;
 				c &= 0x3f;
 				uchar |= c;
-
-			// 3-byte sequence (most CJKV characters):
-			// zzzzyyyyyyxxxxxx = 1110zzzz 10yyyyyy 10xxxxxx
+			/*
+			 * 3-byte sequence (most CJKV characters):
+			 * zzzzyyyyyyxxxxxx = 1110zzzz 10yyyyyy 10xxxxxx
+			 */
 			} else if ((c & 0xf0) == 0xe0) {
 				uchar = (c & 0x0f) << 12;
 
@@ -63,12 +67,13 @@ static int utf8_to_utf16le(const char *s, __le16 *cp, unsigned len)
 				/* no bogus surrogates */
 				if (0xd800 <= uchar && uchar <= 0xdfff)
 					goto fail;
-
-			// 4-byte sequence (surrogate pairs, currently rare):
-			// 11101110wwwwzzzzyy + 110111yyyyxxxxxx
-			//     = 11110uuu 10uuzzzz 10yyyyyy 10xxxxxx
-			// (uuuuu = wwww + 1)
-			// FIXME accept the surrogate code points (only)
+			/*
+			 * 4-byte sequence (surrogate pairs, currently rare):
+			 * 11101110wwwwzzzzyy + 110111yyyyxxxxxx
+			 *     = 11110uuu 10uuzzzz 10yyyyyy 10xxxxxx
+			 * (uuuuu = wwww + 1)
+			 * FIXME accept the surrogate code points (only)
+			 */
 
 			} else
 				goto fail;
@@ -85,7 +90,7 @@ fail:
 
 
 /**
- * usb_gadget_get_string - fill out a string descriptor 
+ * usb_gadget_get_string() - fill out a string descriptor
  * @table: of c strings encoded using UTF-8
  * @id: string id, from low byte of wValue in get string descriptor
  * @buf: at least 256 bytes
@@ -102,17 +107,17 @@ fail:
  * characters (which are also widely used in C strings).
  */
 int
-usb_gadget_get_string (struct usb_gadget_strings *table, int id, u8 *buf)
+usb_gadget_get_string(struct usb_gadget_strings *table, int id, u8 *buf)
 {
 	struct usb_string	*s;
 	int			len;
 
 	/* descriptor 0 has the language id */
 	if (id == 0) {
-		buf [0] = 4;
-		buf [1] = USB_DT_STRING;
-		buf [2] = (u8) table->language;
-		buf [3] = (u8) (table->language >> 8);
+		buf[0] = 4;
+		buf[1] = USB_DT_STRING;
+		buf[2] = (u8) table->language;
+		buf[3] = (u8) (table->language >> 8);
 		return 4;
 	}
 	for (s = table->strings; s && s->s; s++)
@@ -124,13 +129,13 @@ usb_gadget_get_string (struct usb_gadget_strings *table, int id, u8 *buf)
 		return -EINVAL;
 
 	/* string descriptors have length, tag, then UTF16-LE text */
-	len = min ((size_t) 126, strlen (s->s));
-	memset (buf + 2, 0, 2 * len);	/* zero all the bytes */
+	len = min((size_t) 126, strlen(s->s));
+	memset(buf + 2, 0, 2 * len);	/* zero all the bytes */
 	len = utf8_to_utf16le(s->s, (__le16 *)&buf[2], len);
 	if (len < 0)
 		return -EINVAL;
-	buf [0] = (len + 1) * 2;
-	buf [1] = USB_DT_STRING;
-	return buf [0];
+	buf[0] = (len + 1) * 2;
+	buf[1] = USB_DT_STRING;
+	return buf[0];
 }
 



