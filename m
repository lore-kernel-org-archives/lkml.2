Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1IXQQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 12:16:24 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:19038 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1IXQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 12:16:23 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-2.6] cxgb4: Fix EEH on IBM P7IOC
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dm@chelsio.com,
        swise@opengridcomputing.com, kxie@chelsio.com
Date: Sat, 24 Sep 2011 09:11:31 -0700
Message-ID: <20110924161130.18521.39558.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Fix EEH recovery on new P Series platform by
requesting fundamental reset.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb4/cxgb4_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index c9957b7..b4efa29 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -3712,6 +3712,9 @@ static int __devinit init_one(struct pci_dev *pdev,
 		setup_debugfs(adapter);
 	}
 
+	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
+	pdev->needs_freset = 1;
+
 	if (is_offload(adapter))
 		attach_ulds(adapter);
 

