Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3ABM3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:29:16 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59913 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3ABM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:29:04 -0500
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: [patch net-next V5 06/15] bridge: remove usage of netdev_set_master()
Date: Wed,  2 Jan 2013 13:28:27 +0100
Message-Id: <1357129716-2450-7-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
References: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 net/bridge/br_if.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 1edd71d..2148d47 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -148,7 +148,7 @@ static void del_nbp(struct net_bridge_port *p)
 	netdev_rx_handler_unregister(dev);
 	synchronize_net();
 
-	netdev_set_master(dev, NULL);
+	netdev_upper_dev_unlink(dev, br->dev);
 
 	br_multicast_del_port(p);
 
@@ -364,7 +364,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	if (br_netpoll_info(br) && ((err = br_netpoll_enable(p, GFP_KERNEL))))
 		goto err3;
 
-	err = netdev_set_master(dev, br->dev);
+	err = netdev_master_upper_dev_link(dev, br->dev);
 	if (err)
 		goto err4;
 
@@ -403,7 +403,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	return 0;
 
 err5:
-	netdev_set_master(dev, NULL);
+	netdev_upper_dev_unlink(dev, br->dev);
 err4:
 	br_netpoll_disable(p);
 err3:
-- 
1.8.0

