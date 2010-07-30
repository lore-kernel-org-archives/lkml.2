Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0G3TWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:22:45 -0400
Received: from kroah.org ([198.145.64.141]:46203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab0G3RRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:00 2010
Message-Id: <20100730171500.744564696@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [012/165] cpmac: do not leak struct net_device on phy_connect errors
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit ed770f01360b392564650bf1553ce723fa46afec upstream.

If the call to phy_connect fails, we will return directly instead of freeing
the previously allocated struct net_device.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cpmac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -1176,7 +1176,8 @@ static int __devinit cpmac_probe(struct
 		if (netif_msg_drv(priv))
 			printk(KERN_ERR "%s: Could not attach to PHY\n",
 			       dev->name);
-		return PTR_ERR(priv->phy);
+		rc = PTR_ERR(priv->phy);
+		goto fail;
 	}
 
 	if ((rc = register_netdev(dev))) {


