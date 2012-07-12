Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2GLWh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:37:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558Ab2GLWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Graf <tgraf@suug.ch>, Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 040/187] bridge: Assign rtnl_link_ops to bridge devices created via ioctl (v2)
Date: Thu, 12 Jul 2012 15:33:16 -0700
Message-Id: <20120712191526.046251183@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 149ddd83a92b02c658d6c61f3276eb6500d585e8 ]

This ensures that bridges created with brctl(8) or ioctl(2) directly
also carry IFLA_LINKINFO when dumped over netlink. This also allows
to create a bridge with ioctl(2) and delete it with RTM_DELLINK.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_if.c      |    1 +
 net/bridge/br_netlink.c |    2 +-
 net/bridge/br_private.h |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -240,6 +240,7 @@ int br_add_bridge(struct net *net, const
 		return -ENOMEM;
 
 	dev_net_set(dev, net);
+	dev->rtnl_link_ops = &br_link_ops;
 
 	res = register_netdev(dev);
 	if (res)
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -211,7 +211,7 @@ static int br_validate(struct nlattr *tb
 	return 0;
 }
 
-static struct rtnl_link_ops br_link_ops __read_mostly = {
+struct rtnl_link_ops br_link_ops __read_mostly = {
 	.kind		= "bridge",
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -538,6 +538,7 @@ extern int (*br_fdb_test_addr_hook)(stru
 #endif
 
 /* br_netlink.c */
+extern struct rtnl_link_ops br_link_ops;
 extern int br_netlink_init(void);
 extern void br_netlink_fini(void);
 extern void br_ifinfo_notify(int event, struct net_bridge_port *port);


