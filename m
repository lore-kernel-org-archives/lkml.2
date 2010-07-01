Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0GASvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:51:43 -0400
Received: from kroah.org ([198.145.64.141]:35401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab0GASWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:52 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:08 2010
Message-Id: <20100701173208.920665288@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [patch 025/149] USB: visor: fix memory leak
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 199b113978015309dd02c69844c19a1be3f4dbcf upstream.

Fix memory leak for some devices (Sony Clie 3.5) due to port private
data not being freed on release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 0949427..fb7fc40 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -249,6 +249,7 @@ static struct usb_serial_driver clie_3_5_device = {
 	.throttle =		visor_throttle,
 	.unthrottle =		visor_unthrottle,
 	.attach =		clie_3_5_startup,
+	.release =		visor_release,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.write_bulk_callback =	visor_write_bulk_callback,


