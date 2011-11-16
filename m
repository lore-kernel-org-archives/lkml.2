Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1KPWPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:15:39 -0500
Received: from mail-qy0-f202.google.com ([209.85.216.202]:51346 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1KPWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:15:35 -0500
X-Greylist: delayed 61146 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 17:15:35 EST
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>, Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v6 5/9] forcedeth: Add messages to indicate using MSI or MSI-X
Date: Wed, 16 Nov 2011 14:15:11 -0800
Message-Id: <f9863a91fd0aecd6d881341daa2f24bf0e8e4765.1321481064.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Ditto <mditto@google.com>

This adds a few kernel messages to indicate whether PCIe interrupts
are signaled with MSI or MSI-X.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 374625b..fe17e42 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3810,6 +3810,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				writel(0, base + NvRegMSIXMap0);
 				writel(0, base + NvRegMSIXMap1);
 			}
+			netdev_info(dev, "MSI-X enabled\n");
 		}
 	}
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
@@ -3831,6 +3832,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 			writel(0, base + NvRegMSIMap1);
 			/* enable msi vector 0 */
 			writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+			netdev_info(dev, "MSI enabled\n");
 		}
 	}
 	if (ret != 0) {
-- 
1.7.3.1

