Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2L1Tgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:36:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932179Ab2L1TTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:00 -0500
Message-Id: <20121228190346.933518285@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 080/173] usb: ftdi_sio: fixup BeagleBone A5+ quirk
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1807,7 +1807,7 @@ static int ftdi_8u2232c_probe(struct usb
 	dbg("%s", __func__);
 
 	if ((udev->manufacturer && !strcmp(udev->manufacturer, "CALAO Systems")) ||
-	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100")))
+	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100V2")))
 		return ftdi_jtag_probe(serial);
 
 	return 0;


