Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1HSNcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:32:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9852 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1HSNaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:03 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158361"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mark Einon <mark.einon@gmail.com>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Subject: [PATCH 67/75] et131x: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:39 +0100
Message-ID: <1313760467-8598-67-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Einon <mark.einon@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/et131x/et1310_tx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 8fb3051..03e7a4e 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -519,12 +519,12 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 			 * returned by pci_map_page() is always 32-bit
 			 * addressable (as defined by the pci/dma subsystem)
 			 */
-			desc[frag++].addr_lo =
-			    pci_map_page(etdev->pdev,
-					 frags[i - 1].page,
-					 frags[i - 1].page_offset,
-					 frags[i - 1].size,
-					 PCI_DMA_TODEVICE);
+			desc[frag++].addr_lo = skb_frag_dma_map(
+							&etdev->pdev->dev,
+							&frags[i - 1],
+							0,
+							frags[i - 1].size,
+							PCI_DMA_TODEVICE);
 		}
 	}
 
-- 
1.7.2.5

