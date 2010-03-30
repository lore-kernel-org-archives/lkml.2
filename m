Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0C3U6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:58:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1274 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab0C3U6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:58:42 -0400
Subject: Re: [PATCH] Staging: quatech_usb2: fix coding style issues
From: Joe Perches <joe@perches.com>
To: Soeren Moeller <soerenmoeller2001@gmail.com>
Cc: gregkh@suse.de, richard@audacityteam.org, andre.goddard@gmail.com,
       nm127@freemail.hu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1269979872-14677-1-git-send-email-soerenmoeller2001@gmail.com>
References: <1269979872-14677-1-git-send-email-soerenmoeller2001@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 13:58:39 -0700
Message-ID: <1269982719.1507.71.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 20:11 +0000, Soeren Moeller wrote:
> This is a patch to the file quatech_usb2.c that fixes two space before tabular and one line of more than 80 characters warnings found by checkpatch.pl
> -				tty_insert_flip_string(tty_st,
> -					&((unsigned char *)(urb->transfer_buffer)
> -						)[i],
> -					1);
> +				tty_insert_flip_string(tty_st, &(
> +						(unsigned char *)
> +						(urb->transfer_buffer)
> +					)[i], 1);

I think this is unsightly.
Perhaps a macro instead?

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/quatech_usb2/quatech_usb2.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 1561f74..d14792a 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -109,12 +109,15 @@ static int debug;
 #define  QT2_LINE_STATUS_REGISTER       0x05
 #define  QT2_MODEM_STATUS_REGISTER      0x06
 
+/* handy macro for extracting a byte from a data read transfer buffer */
+#define URB_TBUF(urb, pos) (((unsigned char *)(urb->transfer_buffer))[pos])
+
 /* handy macros for doing escape sequence parsing on data reads */
-#define THISCHAR	((unsigned char *)(urb->transfer_buffer))[i]
-#define NEXTCHAR	((unsigned char *)(urb->transfer_buffer))[i + 1]
-#define THIRDCHAR	((unsigned char *)(urb->transfer_buffer))[i + 2]
-#define FOURTHCHAR	((unsigned char *)(urb->transfer_buffer))[i + 3]
-#define FIFTHCHAR	((unsigned char *)(urb->transfer_buffer))[i + 4]
+#define THISCHAR	URB_TBUF(urb, i + 0)
+#define NEXTCHAR	URB_TBUF(urb, i + 1)
+#define THIRDCHAR	URB_TBUF(urb, i + 2)
+#define FOURTHCHAR	URB_TBUF(urb, i + 3)
+#define FIFTHCHAR	URB_TBUF(urb, i + 4)
 
 static const struct usb_device_id quausb2_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU2_100)},
@@ -1649,9 +1652,7 @@ __func__);
 			if (tty_st && urb->actual_length) {
 				tty_buffer_request_room(tty_st, 1);
 				tty_insert_flip_string(tty_st,
-					&((unsigned char *)(urb->transfer_buffer)
-						)[i],
-					1);
+						       &URB_TBUF(urb, i), 1);
 			}
 		} /*endfor*/
 		tty_flip_buffer_push(tty_st);


