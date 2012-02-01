Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab2BAVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:50:28 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48105 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101Ab2BAVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:30 -0500
X-Sasl-enc: x1eiqKkl8BhBcyowenXBZ3YzLIO6CntCCORJgc3kSqvr 1328130509
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.770784621@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Torbj=C3=B6rn=20Lofterud?= <torbjorn@pi.nxs.se>,
        Johan Hovold <jhovold@gmail.com>
Subject: [26/65] USB: ftdi_sio: fix TIOCSSERIAL baud_base handling
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit eb833a9e0972f60beb4ab8104ad7ef6bf30f02fc upstream.

Return EINVAL if new baud_base does not match the current one.

The baud_base is device specific and can not be changed. This restores
the old (pre-2005) behaviour which was changed due to a
misunderstanding regarding this fact (see
https://lkml.org/lkml/2005/1/20/84).

Reported-by: Torbjörn Lofterud <torbjorn@pi.nxs.se>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1326,8 +1326,7 @@ static int set_serial_info(struct tty_st
 		goto check_and_exit;
 	}
 
-	if ((new_serial.baud_base != priv->baud_base) &&
-	    (new_serial.baud_base < 9600)) {
+	if (new_serial.baud_base != priv->baud_base) {
 		mutex_unlock(&priv->cfg_lock);
 		return -EINVAL;
 	}


