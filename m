Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1ESAPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:15:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40216 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1ESAPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:15:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=puye012+Gh6mgctDyVhXxTQszPrqCBHUkxXKgvusg0Vu/lfxa4hQJKBPyLKCervit
	yi12h0Imj0+RG68aLU92A==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel-net-upstream@google.com, Mike Ditto <mditto@google.com>,
        David Decotigny <decot@google.com>
Subject: [PATCH 5/6] forcedeth: Add messages to indicate using MSI or MSI-X
Date: Wed, 18 May 2011 17:14:39 -0700
Message-Id: <1305764080-24853-5-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305764080-24853-1-git-send-email-decot@google.com>
References: <1305764080-24853-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Ditto <mditto@google.com>

This adds a few debug messages to indicate whether PCIe interrupts are
signaled with MSI or MSI-X.


Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/forcedeth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 17e79de..2712ddc 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -3745,6 +3745,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				writel(0, base + NvRegMSIXMap0);
 				writel(0, base + NvRegMSIXMap1);
 			}
+			netdev_info(dev, "forcedeth: MSI-X enabled\n");
 		}
 	}
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
@@ -3766,6 +3767,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 			writel(0, base + NvRegMSIMap1);
 			/* enable msi vector 0 */
 			writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+			netdev_info(dev, "forcedeth: MSI enabled\n");
 		}
 	}
 	if (ret != 0) {
-- 
1.7.3.1

