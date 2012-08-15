Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2HOTxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:37410 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2HOTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 160/165] net: feed /dev/random with the MAC address when registering a device
Date: Wed, 15 Aug 2012 15:48:24 -0400
Message-ID: <1345060109-9187-161-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7bf2357524408b97fec58344caf7397f8140c3fd upstream.

Cc: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c       | 3 +++
 net/core/rtnetlink.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index bcd5f6e..7daff00 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1177,6 +1177,7 @@ static int __dev_open(struct net_device *dev)
 		 *	Wakeup transmit queue engine
 		 */
 		dev_activate(dev);
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	return ret;
@@ -4492,6 +4493,7 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa)
 	err = ops->ndo_set_mac_address(dev, sa);
 	if (!err)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 	return err;
 }
 EXPORT_SYMBOL(dev_set_mac_address);
@@ -5141,6 +5143,7 @@ int register_netdevice(struct net_device *dev)
 	dev_init_scheduler(dev);
 	dev_hold(dev);
 	list_netdevice(dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 31e85d3..835f38c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -974,6 +974,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
 			goto errout;
 		send_addr_notify = 1;
 		modified = 1;
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	if (tb[IFLA_MTU]) {
-- 
1.7.12.rc2

