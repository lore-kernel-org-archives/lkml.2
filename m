Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2BQBFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:05:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43307 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785Ab2BQBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:00 -0500
X-Sasl-enc: x7I9R8hcznnRVwV534QrCJhU3vSwvgX3upMOFosF90iQ 1329440399
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:36 2012
Message-Id: <20120217005536.411014122@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>
Subject: [17/28] hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaus Schulz <schulz@macnetix.de>

commit 09e87e5c4f9af656af2a8a3afc03487c5d9287c3 upstream.

In order to enable temperature mode aka automatic mode for the F75373 and
F75375 chips, the two FANx_MODE bits in the fan configuration register
need be set to 01, not 10.

Signed-off-by: Nikolaus Schulz <mail@microschulz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/f75375s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -311,7 +311,7 @@ static int set_pwm_enable_direct(struct
 		fanmode  |= (3 << FAN_CTRL_MODE(nr));
 		break;
 	case 2: /* AUTOMATIC*/
-		fanmode  |= (2 << FAN_CTRL_MODE(nr));
+		fanmode  |= (1 << FAN_CTRL_MODE(nr));
 		break;
 	case 3: /* fan speed */
 		break;


