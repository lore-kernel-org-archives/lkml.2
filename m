Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab0HLAVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:21:51 -0400
Received: from kroah.org ([198.145.64.141]:60335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759348Ab0HLAEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:39 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.502018592@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [46/54] xen: netfront: explicitly generate arp_notify event after migration.
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit 592970675c9522bde588b945388c7995c8b51328 upstream.

Use newly introduced netif_notify_peers() method to ensure a gratuitous ARP is
generated after a migration.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/xen-netfront.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1621,6 +1621,7 @@ static void backend_changed(struct xenbu
 		if (xennet_connect(netdev) != 0)
 			break;
 		xenbus_switch_state(dev, XenbusStateConnected);
+		netif_notify_peers(netdev);
 		break;
 
 	case XenbusStateClosing:


