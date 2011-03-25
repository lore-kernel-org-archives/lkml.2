Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab1CYX62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:58:28 -0400
Received: from kroah.org ([198.145.64.141]:48941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab1CYX6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:38 2011
Message-Id: <20110325235638.317645069@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:55:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [18/23] USB: cdc-acm: fix potential null-pointer dereference
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=usb-cdc-acm-fix-potential-null-pointer-dereference.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

commit 15e5bee33ffc11d0e5c6f819a65e7881c5c407be upstream.

Must check return value of tty_port_tty_get.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -534,6 +534,8 @@ static void acm_softint(struct work_stru
 	if (!ACM_READY(acm))
 		return;
 	tty = tty_port_tty_get(&acm->port);
+	if (!tty)
+		return;
 	tty_wakeup(tty);
 	tty_kref_put(tty);
 }


