Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534Ab2C3VDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:03:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761404Ab2C3VDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:34 -0400
Message-Id: <20120330195722.999979387@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>
Subject: [ 006/108] USB: ftdi_sio: add support for BeagleBone rev A5+
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 444aa7fa9bd752d19ce472d3e02558b987c3cc67 upstream.

BeagleBone changed to the default FTDI 0403:6010 id in rev A5 to make life
easier for Windows users, so we need a similar workaround as the Calao
board to support it.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1755,8 +1755,8 @@ static int ftdi_8u2232c_probe(struct usb
 
 	dbg("%s", __func__);
 
-	if ((udev->manufacturer) &&
-	    (strcmp(udev->manufacturer, "CALAO Systems") == 0))
+	if ((udev->manufacturer && !strcmp(udev->manufacturer, "CALAO Systems")) ||
+	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100")))
 		return ftdi_jtag_probe(serial);
 
 	return 0;


