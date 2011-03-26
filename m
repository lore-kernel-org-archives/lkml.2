Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab1CZAIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:08:21 -0400
Received: from kroah.org ([198.145.64.141]:35945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450Ab1CZAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:58 2011
Message-Id: <20110326000458.873251907@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:04:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [29/35] USB: cdc-acm: fix potential null-pointer dereference
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

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


