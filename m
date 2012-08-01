Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2HAQAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:00:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40535 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2HAQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:00:37 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Mike McCormack <mikem@ring3k.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 32/32] PCI/rtl8192e: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:37 +0800
Message-Id: <1343836477-7287-33-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify rtl8192e driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
index ddadcc3..820cc68 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
@@ -31,12 +31,10 @@ static void rtl8192_parse_pci_configuration(struct pci_dev *pdev,
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
 
 	u8 tmp;
-	int pos;
-	u8 LinkCtrlReg;
+	u16 LinkCtrlReg;
 
-	pos = pci_find_capability(priv->pdev, PCI_CAP_ID_EXP);
-	pci_read_config_byte(priv->pdev, pos + PCI_EXP_LNKCTL, &LinkCtrlReg);
-	priv->NdisAdapter.LinkCtrlReg = LinkCtrlReg;
+	pci_pcie_capability_read_word(priv->pdev, PCI_EXP_LNKCTL, &LinkCtrlReg);
+	priv->NdisAdapter.LinkCtrlReg = (u8)LinkCtrlReg;
 
 	RT_TRACE(COMP_INIT, "Link Control Register =%x\n",
 		 priv->NdisAdapter.LinkCtrlReg);
-- 
1.7.9.5

