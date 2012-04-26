Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2DZGmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:42:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52442 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2DZGmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:42:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="182791996"
X-IronPort-AV: E=Sophos;i="4.75,484,1330934400"; 
   d="scan'208";a="241388905"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 10/10] atl1c: add flag of PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG
Date: Thu, 26 Apr 2012 14:41:01 +0800
Message-ID: <1335422461-16588-3-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335422461-16588-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335422461-16588-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

supported devices all have one issue that msi interrupt doesn't assert
if pci command register bit (PCI_COMMAND_INTX_DISABLE) is set.
that bit should be effect only for INTx style interrupt.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 25b7b00..07b6018 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2434,6 +2434,7 @@ static int __devinit atl1c_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "cannot map device registers\n");
 		goto err_ioremap;
 	}
+	pdev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 
 	/* init mii data */
 	adapter->mii.dev = netdev;
-- 
1.7.7

