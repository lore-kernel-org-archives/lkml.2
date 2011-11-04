Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1KDBmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:42:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1KDBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:42:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=oVvbWM4Bazj18uwMs5Qs7j5CmDAlk1xyZPDFKIgPZDsbvdrjIxW8TkFGfiEcezxkK
	HTmo9GypXz3IR0sSA61qQ==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v2 5/8] forcedeth: Add messages to indicate using MSI or MSI-X
Date: Thu,  3 Nov 2011 18:41:20 -0700
Message-Id: <babd8cee0670f797c4c520857671a6268ea47a7d.1320369398.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
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
index 4a45a46..0af12a8 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3761,6 +3761,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				writel(0, base + NvRegMSIXMap0);
 				writel(0, base + NvRegMSIXMap1);
 			}
+			netdev_info(dev, "MSI-X enabled\n");
 		}
 	}
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
@@ -3782,6 +3783,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 			writel(0, base + NvRegMSIMap1);
 			/* enable msi vector 0 */
 			writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+			netdev_info(dev, "MSI enabled\n");
 		}
 	}
 	if (ret != 0) {
-- 
1.7.3.1

