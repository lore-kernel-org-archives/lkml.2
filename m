Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2HMWEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33116 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab2HMWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, David Miller <davem@davemloft.net>
Subject: [ 24/44] net: feed /dev/random with the MAC address when registering a device
Date: Mon, 13 Aug 2012 15:02:31 -0700
Message-Id: <20120813220144.254312872@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7bf2357524408b97fec58344caf7397f8140c3fd upstream.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c       |    3 +++
 net/core/rtnetlink.c |    1 +
 2 files changed, 4 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1163,6 +1163,7 @@ static int __dev_open(struct net_device
 		net_dmaengine_get();
 		dev_set_rx_mode(dev);
 		dev_activate(dev);
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	return ret;
@@ -4730,6 +4731,7 @@ int dev_set_mac_address(struct net_devic
 	err = ops->ndo_set_mac_address(dev, sa);
 	if (!err)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 	return err;
 }
 EXPORT_SYMBOL(dev_set_mac_address);
@@ -5507,6 +5509,7 @@ int register_netdevice(struct net_device
 	dev_init_scheduler(dev);
 	dev_hold(dev);
 	list_netdevice(dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1304,6 +1304,7 @@ static int do_setlink(struct net_device
 			goto errout;
 		send_addr_notify = 1;
 		modified = 1;
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	if (tb[IFLA_MTU]) {


