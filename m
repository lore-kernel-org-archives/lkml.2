Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2BAVfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:35:06 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50351 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932519Ab2BAVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:07 -0500
X-Sasl-enc: V1kNcF7Oz4bGFxsHPEVkH9b6a+zkho1Ll0ZccQmDFHzz 1328130606
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:47 2012
Message-Id: <20120201210047.428318096@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Torbj=C3=B6rn=20Lofterud?= <torbjorn@pi.nxs.se>,
        Johan Hovold <jhovold@gmail.com>
Subject: [40/89] USB: ftdi_sio: fix TIOCSSERIAL baud_base handling
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1333,8 +1333,7 @@ static int set_serial_info(struct tty_st
 		goto check_and_exit;
 	}
 
-	if ((new_serial.baud_base != priv->baud_base) &&
-	    (new_serial.baud_base < 9600)) {
+	if (new_serial.baud_base != priv->baud_base) {
 		mutex_unlock(&priv->cfg_lock);
 		return -EINVAL;
 	}


