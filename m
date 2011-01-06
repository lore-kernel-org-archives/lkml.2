Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1AFA3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:54 -0500
Received: from kroah.org ([198.145.64.141]:35713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab1AFA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:52 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.316209582@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [060/152] r8169: fix sleeping while holding spinlock.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: françois romieu <romieu@fr.zoreil.com>

[ Upstream commit ea80907ff066edd1dd43c5fe90ae6677d15e6384 ]

As device_set_wakeup_enable can now sleep, move the call to outside
the critical section.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -855,10 +855,10 @@ static int rtl8169_set_wol(struct net_de
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
 	__rtl8169_set_wol(tp, wol->wolopts);
-	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
-
 	spin_unlock_irq(&tp->lock);
 
+	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
+
 	return 0;
 }
 


