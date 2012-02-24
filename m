Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2BXQBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:01:43 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53220 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689Ab2BXQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:38 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] wan/lapbether: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:19 +0100
Message-Id: <1330099282-4588-10-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330099298;9b1f5155;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if given address is valid in .ndo_set_mac_address/
lapbeth_set_mac_address(), if invalid return -EADDRNOTAVAIL as
eth_mac_addr() already does if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/wan/lapbether.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 7beeb9b..b6d4cbc 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -45,6 +45,7 @@
 #include <linux/module.h>
 #include <linux/lapb.h>
 #include <linux/init.h>
+#include <linux/etherdevice.h>
 
 #include <net/x25device.h>
 
@@ -254,6 +255,10 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
 static int lapbeth_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *sa = addr;
+
+	if (!is_valid_ether_addr(sa->sa_data))
+		return -EADDRNOTAVAIL;
+
 	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
 	return 0;
 }
-- 
1.7.8.3

