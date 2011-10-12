Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1JLAjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:39:00 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16812 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab1JLAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:38:59 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2 v2] pch_dma: Reduce wasting memory
Date: Wed, 12 Oct 2011 09:38:35 +0900
Message-Id: <1318379915-8697-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_channels is defined in "struct pch_dma".
and struct pch_dma_chan is defined in "struct pch_dma".
So, "sizeof(struct pch_dma_chan) * nr_channels" is unnecessary.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
v2: Change sizeof(struct pch_dma) to sizeof(*pd)
---
 drivers/dma/pch_dma.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 326fedc..58b215c 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -997,8 +997,7 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
 	int i;
 
 	nr_channels = id->driver_data;
-	pd = kzalloc(sizeof(struct pch_dma)+
-		sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return -ENOMEM;
 
-- 
1.7.4.4

