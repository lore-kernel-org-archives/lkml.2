Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0KSWen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:34:43 -0500
Received: from kroah.org ([198.145.64.141]:44931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab0KSV6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:23 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.320143733@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [07/82] pcmcia: synclink_cs: fix information leak to userland
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit 5b917a1420d3d1a9c8da49fb0090692dc9aaee86 upstream.

Structure new_line is copied to userland with some padding fields unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/pcmcia/synclink_cs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -4132,6 +4132,8 @@ static int hdlcdev_ioctl(struct net_devi
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
+	memset(&new_line, 0, size);
+
 	switch(ifr->ifr_settings.type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 


