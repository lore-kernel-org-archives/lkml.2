Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2BAVJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:19 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53390 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170Ab2BAVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:15 -0500
X-Sasl-enc: OG/M71lIL7ktjWxyk6WuOFtUZGhwixkg0/Wah5ZjVKMn 1328130553
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:42 2012
Message-Id: <20120201205742.812720125@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: [61/65] USB: cp210x: do not map baud rates to B0
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit be125d9c8d59560e7cc2d6e2b65c8fd233498ab7 upstream.

We do not implement B0 hangup yet so map low baudrates to 300bps.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Preston Fick <preston.fick@silabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -357,8 +357,8 @@ static inline int cp210x_set_config_sing
  * Quantises the baud rate as per AN205 Table 1
  */
 static unsigned int cp210x_quantise_baudrate(unsigned int baud) {
-	if      (baud <= 56)       baud = 0;
-	else if (baud <= 300)      baud = 300;
+	if (baud <= 300)
+		baud = 300;
 	else if (baud <= 600)      baud = 600;
 	else if (baud <= 1200)     baud = 1200;
 	else if (baud <= 1800)     baud = 1800;


