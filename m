Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab2JAXGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:06:33 -0400
Received: from 1wt.eu ([62.212.114.60]:35662 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab2JAXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:26 -0400
Message-Id: <20121001225205.033029235@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 175/180] net: feed /dev/random with the MAC address when registering a device
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7bf2357524408b97fec58344caf7397f8140c3fd upstream.

Cc: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/dev.c       |    3 +++
 net/core/rtnetlink.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 84a0705..46e2a29 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1133,6 +1133,7 @@ int dev_open(struct net_device *dev)
 		/*
 		 *	... and announce new interface.
 		 */
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 		call_netdevice_notifiers(NETDEV_UP, dev);
 	}
 
@@ -4268,6 +4269,7 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa)
 	err = ops->ndo_set_mac_address(dev, sa);
 	if (!err)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 	return err;
 }
 EXPORT_SYMBOL(dev_set_mac_address);
@@ -4871,6 +4873,7 @@ int register_netdevice(struct net_device *dev)
 	dev_init_scheduler(dev);
 	dev_hold(dev);
 	list_netdevice(dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d4fd895..9d70042 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -817,6 +817,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
 			goto errout;
 		send_addr_notify = 1;
 		modified = 1;
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	if (tb[IFLA_MTU]) {
-- 
1.7.2.1.45.g54fbc



