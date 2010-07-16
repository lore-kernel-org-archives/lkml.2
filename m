Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab0GPB2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:28:34 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56816 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935038Ab0GPB2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:28:33 -0400
Date: Thu, 15 Jul 2010 18:28:31 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
X-X-Sender: sbhatewara@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: [PATCH 2.6.35-rc1] net-next: fix LRO feature update in vmxnet3
In-Reply-To: <alpine.LRH.2.00.1007151458580.10176@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1007151821440.10176@localhost.localdomain>
References: <alpine.LRH.2.00.1007070202080.5939@localhost.localdomain> <alpine.LRH.2.00.1007070232300.5939@localhost.localdomain> <alpine.LRH.2.00.1007131750060.32055@localhost.localdomain> <20100714.141118.260092331.davem@davemloft.net>
 <alpine.LRH.2.00.1007151458580.10176@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Shreyas Bhatewara <sbhatewara@vmware.com>

Fix LRO feature update.

Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

---

 drivers/net/vmxnet3/vmxnet3_ethtool.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index de1ba14..7e4b5a8 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -291,10 +291,11 @@ vmxnet3_set_flags(struct net_device *netdev, u32 data)
 
 		/* update harware LRO capability accordingly */
 		if (lro_requested)
-			adapter->shared->devRead.misc.uptFeatures &= UPT1_F_LRO;
+			adapter->shared->devRead.misc.uptFeatures |=
+						cpu_to_le64(UPT1_F_LRO);
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
-								~UPT1_F_LRO;
+						cpu_to_le64(~UPT1_F_LRO);
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
 				       VMXNET3_CMD_UPDATE_FEATURE);
 	}
