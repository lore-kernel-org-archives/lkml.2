Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab2J2WIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:08:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:47623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760691Ab2J2Vh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 055/101] USB: opticon: fix memory leak in error path
Date: Mon, 29 Oct 2012 14:35:08 -0700
Message-Id: <20121029213246.384131779@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acbf0e5263de563e25f7c104868e4490b9e72b13 upstream.

Fix memory leak in write error path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/opticon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -289,7 +289,7 @@ static int opticon_write(struct tty_stru
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
-		goto error;
+		goto error_no_dr;
 	}
 
 	dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
@@ -319,6 +319,8 @@ static int opticon_write(struct tty_stru
 
 	return count;
 error:
+	kfree(dr);
+error_no_dr:
 	usb_free_urb(urb);
 error_no_urb:
 	kfree(buffer);


