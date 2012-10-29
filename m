Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab2J2WHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:07:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:47669 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761287Ab2J2Vhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>
Subject: [ 059/101] USB: quatech2: fix memory leak in error path
Date: Mon, 29 Oct 2012 14:35:12 -0700
Message-Id: <20121029213246.840410991@linuxfoundation.org>
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

commit b8a0055050b6294826171641b182c09f78f4cc63 upstream.

Fix memory leak in attach error path where the read urb was never freed.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/quatech2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -825,6 +825,7 @@ static int qt2_setup_urbs(struct usb_ser
 	if (status != 0) {
 		dev_err(&serial->dev->dev,
 			"%s - submit read urb failed %i\n", __func__, status);
+		usb_free_urb(serial_priv->read_urb);
 		return status;
 	}
 


