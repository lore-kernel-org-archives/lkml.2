Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab2JKBUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:20:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52787 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933794Ab2JKBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:19:54 -0400
X-Sasl-enc: Uwj7Nf+tEYpwcdd5ZNrdN2WaW7Son7qltTEELKeKqvvY 1349918393
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 035/120] netxen: check for root bus in netxen_mask_aer_correctable
Date: Thu, 11 Oct 2012 09:59:47 +0900
Message-Id: <20121011005831.981603934@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit e4d1aa40e363ed3e0486aeeeb0d173f7f822737e ]

Add a check if pdev->bus->self == NULL (root bus). When attaching
a netxen NIC to a VM it can be on the root bus and the guest would
crash in netxen_mask_aer_correctable() because of a NULL pointer
dereference if CONFIG_PCIEAER is present.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1370,6 +1370,10 @@ static void netxen_mask_aer_correctable(
 	struct pci_dev *root = pdev->bus->self;
 	u32 aer_pos;
 
+	/* root bus? */
+	if (!root)
+		return;
+
 	if (adapter->ahw.board_type != NETXEN_BRDTYPE_P3_4_GB_MM &&
 		adapter->ahw.board_type != NETXEN_BRDTYPE_P3_10G_TP)
 		return;


