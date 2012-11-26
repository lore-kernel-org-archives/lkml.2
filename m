Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab2KZRW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:22:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042Ab2KZRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 248/270] USB: mos7840: fix urb leak at release
Date: Mon, 26 Nov 2012 14:58:58 -0200
Message-Id: <1353949160-26803-249-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 65a4cdbb170e4ec1a7fa0e94936d47e24a17b0e8 upstream.

Make sure control urb is freed at release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mos7840.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 009c1d9..748bc6a 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2755,6 +2755,7 @@ static void mos7840_release(struct usb_serial *serial)
 				del_timer_sync(&mos7840_port->led_timer1);
 				del_timer_sync(&mos7840_port->led_timer2);
 			}
+			usb_free_urb(mos7840_port->control_urb);
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);
-- 
1.7.9.5

