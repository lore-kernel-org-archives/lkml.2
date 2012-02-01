Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2BAVJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:31 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51753 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2BAVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:21 -0500
X-Sasl-enc: GpL6iN2DR2hI76hmaOb7hoxV+nE6FC19o3rIs6j2I3Vs 1328130559
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:43 2012
Message-Id: <20120201205743.159447354@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: [65/65] USB: cp210x: allow more baud rates above 1Mbaud
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d1620ca9e7bb0030068c3b45b653defde8839dac upstream.

Allow more baud rates to be set in [1M,2M] baud.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Preston Fick <preston.fick@silabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -388,10 +388,10 @@ static unsigned int cp210x_quantise_baud
 	else if (baud <= 491520)   baud = 460800;
 	else if (baud <= 567138)   baud = 500000;
 	else if (baud <= 670254)   baud = 576000;
-	else if (baud <= 1053257)  baud = 921600;
-	else if (baud <= 1474560)  baud = 1228800;
-	else if (baud <= 2457600)  baud = 1843200;
-	else                       baud = 3686400;
+	else if (baud < 1000000)
+		baud = 921600;
+	else if (baud > 2000000)
+		baud = 2000000;
 	return baud;
 }
 
@@ -611,7 +611,8 @@ static void cp210x_change_speed(struct t
 
 	baud = tty->termios->c_ospeed;
 
-	/* This maps the requested rate to a rate valid on cp2102 or cp2103.
+	/* This maps the requested rate to a rate valid on cp2102 or cp2103,
+	 * or to an arbitrary rate in [1M,2M].
 	 *
 	 * NOTE: B0 is not implemented.
 	 */


