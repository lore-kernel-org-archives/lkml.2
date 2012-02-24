Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2BXQFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:05:43 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53209 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab2BXQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:36 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] vmxnet3: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:18 +0100
Message-Id: <1330099282-4588-9-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330099296;0d6511d7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if given address is valid in .ndo_set_mac_address/
vmxnet3_set_mac_addr(), if invalid return -EADDRNOTAVAIL as
eth_mac_addr() already does if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index e1562e8..bd2a7cd 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2331,6 +2331,9 @@ vmxnet3_set_mac_addr(struct net_device *netdev, void *p)
 	struct sockaddr *addr = p;
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 	vmxnet3_write_mac_addr(adapter, addr->sa_data);
 
-- 
1.7.8.3

