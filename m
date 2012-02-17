Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2BQBHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:07:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36162 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639Ab2BQA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:45 -0500
X-Sasl-enc: ik5a9YIoSYMFzuea5j76SuuUqlgfWVQHKu3r9fehsfsg 1329440384
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:11 2012
Message-Id: <20120217005511.269258043@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>
Subject: [10/15] hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


