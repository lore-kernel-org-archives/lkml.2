Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1KPEnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 23:43:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64764 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1KPEnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 23:43:16 -0500
Subject: [PATCH] usb : gadget : usbstring : fix style problems
From: Tonylijo <mail@tonylijo.in>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 10:13:02 +0530
Message-ID: <1321418582.2443.4.camel@debian1.ic>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fixes for problems found by checkpatch.pl in usbstring.c.

Signed-off-by: Tonylijo Jose <mail@tonylijo.in>
---
diff --git a/drivers/usb/gadget/usbstring.c
b/drivers/usb/gadget/usbstring.c
index 58c4d37..2bdc56a 100644
--- a/drivers/usb/gadget/usbstring.c
+++ b/drivers/usb/gadget/usbstring.c
@@ -32,8 +32,9 @@ static int utf8_to_utf16le(const char *s, __le16 *cp,
unsigned len)
 	 */
 	while (len != 0 && (c = (u8) *s++) != 0) {
 		if (unlikely(c & 0x80)) {
-			// 2-byte sequence:
-			// 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
+			/* 2-byte sequence:
+			 * 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
+			 */
 			if ((c & 0xe0) == 0xc0) {
 				uchar = (c & 0x1f) << 6;
 
@@ -43,8 +44,9 @@ static int utf8_to_utf16le(const char *s, __le16 *cp,
unsigned len)
 				c &= 0x3f;
 				uchar |= c;
 
-			// 3-byte sequence (most CJKV characters):
-			// zzzzyyyyyyxxxxxx = 1110zzzz 10yyyyyy 10xxxxxx
+			/* 3-byte sequence (most CJKV characters):
+			 * zzzzyyyyyyxxxxxx = 1110zzzz 10yyyyyy 10xxxxxx
+			 */
 			} else if ((c & 0xf0) == 0xe0) {
 				uchar = (c & 0x0f) << 12;
 
@@ -64,12 +66,12 @@ static int utf8_to_utf16le(const char *s, __le16
*cp, unsigned len)
 				if (0xd800 <= uchar && uchar <= 0xdfff)
 					goto fail;
 
-			// 4-byte sequence (surrogate pairs, currently rare):
-			// 11101110wwwwzzzzyy + 110111yyyyxxxxxx
-			//     = 11110uuu 10uuzzzz 10yyyyyy 10xxxxxx
-			// (uuuuu = wwww + 1)
-			// FIXME accept the surrogate code points (only)
-
+			/* 4-byte sequence (surrogate pairs, currently rare):
+			 * 11101110wwwwzzzzyy + 110111yyyyxxxxxx
+			 *     = 11110uuu 10uuzzzz 10yyyyyy 10xxxxxx
+			 * (uuuuu = wwww + 1)
+			 * FIXME accept the surrogate code points (only)
+			 */
 			} else
 				goto fail;
 		} else
@@ -85,7 +87,7 @@ fail:
 
 
 /**
- * usb_gadget_get_string - fill out a string descriptor 
+ * usb_gadget_get_string - fill out a string descriptor
  * @table: of c strings encoded using UTF-8
  * @id: string id, from low byte of wValue in get string descriptor
  * @buf: at least 256 bytes
@@ -102,17 +104,17 @@ fail:
  * characters (which are also widely used in C strings).
  */
 int
-usb_gadget_get_string (struct usb_gadget_strings *table, int id, u8
*buf)
+usb_gadget_get_string(struct usb_gadget_strings *table, int id, u8
*buf)
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
@@ -124,13 +126,13 @@ usb_gadget_get_string (struct usb_gadget_strings
*table, int id, u8 *buf)
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
 


