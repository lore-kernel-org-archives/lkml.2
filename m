Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0G3Rss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:48:48 -0400
Received: from kroah.org ([198.145.64.141]:36024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab0G3Rfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:11 2010
Message-Id: <20100730173111.461950963@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Povey <jon.povey@racelogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [097/140] USB: g_serial: fix tty cleanup on unload
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Povey <jon.povey@racelogic.co.uk>

commit b23097b793081358a6d943263c91bae4c955c4e3 upstream.

Call put_tty_driver() in cleanup function, to fix Oops when trying to open
gadget serial char device after module unload.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/u_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -1183,6 +1183,7 @@ void gserial_cleanup(void)
 	n_ports = 0;
 
 	tty_unregister_driver(gs_tty_driver);
+	put_tty_driver(gs_tty_driver);
 	gs_tty_driver = NULL;
 
 	pr_debug("%s: cleaned up ttyGS* support\n", __func__);


