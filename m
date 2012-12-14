Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2LNW1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:27:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:38308 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab2LNW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:27:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: [ 12/22] usb: ftdi_sio: fixup BeagleBone A5+ quirk
Date: Fri, 14 Dec 2012 14:25:57 -0800
Message-Id: <20121214222252.546959515@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 1a88d5eee2ef2ad1d3c4e32043e9c4c5347d4fc1 upstream.

BeagleBone A5+ devices ended up getting shipped with the
'BeagleBone/XDS100V2' product string, and not XDS100 like it
was agreed, so adjust the quirk to match.

For details, see the thread on the beagle list:

https://groups.google.com/forum/#!msg/beagleboard/zrFPew9_Wvo/ibWr1-eE8JwJ

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1798,7 +1798,7 @@ static int ftdi_8u2232c_probe(struct usb
 	dbg("%s", __func__);
 
 	if ((udev->manufacturer && !strcmp(udev->manufacturer, "CALAO Systems")) ||
-	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100")))
+	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100V2")))
 		return ftdi_jtag_probe(serial);
 
 	return 0;


