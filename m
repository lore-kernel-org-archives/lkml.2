Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2GIOoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:44:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38238 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab2GIOiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:16 -0400
Message-Id: <20120709143122.404608942@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen hemminger <shemminger@vyatta.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: [ 40/48] bridge: Assign rtnl_link_ops to bridge devices created  via ioctl (v2)
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 149ddd83a92b02c658d6c61f3276eb6500d585e8 ]

This ensures that bridges created with brctl(8) or ioctl(2) directly
also carry IFLA_LINKINFO when dumped over netlink. This also allows
to create a bridge with ioctl(2) and delete it with RTM_DELLINK.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_if.c      |    1 +
 net/bridge/br_netlink.c |    2 +-
 net/bridge/br_private.h |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f603e5b..f3f75ad 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -240,6 +240,7 @@ int br_add_bridge(struct net *net, const char *name)
 		return -ENOMEM;
 
 	dev_net_set(dev, net);
+	dev->rtnl_link_ops = &br_link_ops;
 
 	res = register_netdev(dev);
 	if (res)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a1daf82..cbf9ccd 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -211,7 +211,7 @@ static int br_validate(struct nlattr *tb[], struct nlattr *data[])
 	return 0;
 }
 
-static struct rtnl_link_ops br_link_ops __read_mostly = {
+struct rtnl_link_ops br_link_ops __read_mostly = {
 	.kind		= "bridge",
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 93264df..b9bba8f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -536,6 +536,7 @@ extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr)
 #endif
 
 /* br_netlink.c */
+extern struct rtnl_link_ops br_link_ops;
 extern int br_netlink_init(void);
 extern void br_netlink_fini(void);
 extern void br_ifinfo_notify(int event, struct net_bridge_port *port);


