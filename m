Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab0GAV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:58:46 -0400
Received: from kroah.org ([198.145.64.141]:33886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809Ab0GAVNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:12 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.464250952@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [036/200] USB: visor: fix memory leak
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 199b113978015309dd02c69844c19a1be3f4dbcf upstream.

Fix memory leak for some devices (Sony Clie 3.5) due to port private
data not being freed on release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/visor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -249,6 +249,7 @@ static struct usb_serial_driver clie_3_5
 	.throttle =		visor_throttle,
 	.unthrottle =		visor_unthrottle,
 	.attach =		clie_3_5_startup,
+	.release =		visor_release,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.write_bulk_callback =	visor_write_bulk_callback,


