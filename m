Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2DSVKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:10:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab2DSVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:10:15 -0400
Message-Id: <20120419210612.803662978@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, =?UTF-8?q?S=C3=B8ren=20Holm?= <sgh@sgh.dk>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 20/59] USB: pl2303: fix DTR/RTS being raised on baud rate change
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ce5c9851855bab190c9a142761d54ba583ab094c upstream.

DTR/RTS should only be raised when changing baudrate from B0 and not on
any baud rate change (> B0).

Reported-by: Søren Holm <sgh@sgh.dk>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -424,7 +424,7 @@ static void pl2303_set_termios(struct tt
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else
+	else if ((old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;


