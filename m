Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2JGXl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:41:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab2JGXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:23 -0400
Message-Id: <20121007225846.588487699@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 086/108] netxen: check for root bus in  netxen_mask_aer_correctable
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit e4d1aa40e363ed3e0486aeeeb0d173f7f822737e ]

Add a check if pdev->bus->self == NULL (root bus). When attaching
a netxen NIC to a VM it can be on the root bus and the guest would
crash in netxen_mask_aer_correctable() because of a NULL pointer
dereference if CONFIG_PCIEAER is present.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 8cf3173..da5204d 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1351,6 +1351,10 @@ static void netxen_mask_aer_correctable(struct netxen_adapter *adapter)
 	struct pci_dev *root = pdev->bus->self;
 	u32 aer_pos;
 
+	/* root bus? */
+	if (!root)
+		return;
+
 	if (adapter->ahw.board_type != NETXEN_BRDTYPE_P3_4_GB_MM &&
 		adapter->ahw.board_type != NETXEN_BRDTYPE_P3_10G_TP)
 		return;


