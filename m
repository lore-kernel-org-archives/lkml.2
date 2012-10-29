Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab2J2Vty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:49:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:48711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995Ab2J2Vlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 30/54] USB: mos7840: fix urb leak at release
Date: Mon, 29 Oct 2012 14:40:31 -0700
Message-Id: <20121029213806.102289219@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 65a4cdbb170e4ec1a7fa0e94936d47e24a17b0e8 upstream.

Make sure control urb is freed at release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2657,6 +2657,7 @@ static void mos7840_release(struct usb_s
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
+			usb_free_urb(mos7840_port->control_urb);
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);


