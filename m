Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1KKBiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:38:46 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:57672 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab1KKBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:38:44 -0500
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v2 02/10] forcedeth: Add messages to indicate using MSI or MSI-X
Date: Thu, 10 Nov 2011 17:31:27 -0800
Message-Id: <e1c1111090a6c6c31b3d341844cf8050631ba2c8.1320974990.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Ditto <mditto@google.com>

This adds a few debug messages to indicate whether PCIe interrupts are
signaled with MSI or MSI-X.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 6e5213e..af285ac 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3735,6 +3735,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				writel(0, base + NvRegMSIXMap0);
 				writel(0, base + NvRegMSIXMap1);
 			}
+			netdev_info(dev, "MSI-X enabled\n");
 		}
 	}
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
@@ -3756,6 +3757,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 			writel(0, base + NvRegMSIMap1);
 			/* enable msi vector 0 */
 			writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+			netdev_info(dev, "MSI enabled\n");
 		}
 	}
 	if (ret != 0) {
-- 
1.7.3.1

