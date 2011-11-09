Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab1KIWKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:10:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1KIWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:10:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=jOWLI2U2+Rkc4Une5Ji8C1aioiSqZd4rMjJO33HI+0gP4XrTZeoq4QZfj8edqNkMZ
	KB5GKiM87D5Or1JExzB8Q==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v1 1/9] forcedeth: Add messages to indicate using MSI or MSI-X
Date: Wed,  9 Nov 2011 14:09:15 -0800
Message-Id: <b5cfb29091b69238dda6f746add1c9a00ec7c5e7.1320875577.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
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
index d24c45b..39781c1b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3711,6 +3711,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				writel(0, base + NvRegMSIXMap0);
 				writel(0, base + NvRegMSIXMap1);
 			}
+			netdev_info(dev, "MSI-X enabled\n");
 		}
 	}
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
@@ -3732,6 +3733,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 			writel(0, base + NvRegMSIMap1);
 			/* enable msi vector 0 */
 			writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+			netdev_info(dev, "MSI enabled\n");
 		}
 	}
 	if (ret != 0) {
-- 
1.7.3.1

