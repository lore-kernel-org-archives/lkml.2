Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2ISNUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:20:53 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:42647
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab2ISNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:20:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1155h)
From: <b16395@freescale.com>
To: <iommu@lists.linux-foundation.org>, <joerg.roedel@amd.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [RFC][PATCH 1/3] iommu/fsl: Store iommu domain information pointer in archdata.
Date: Wed, 19 Sep 2012 18:47:10 +0530
Message-ID: <1348060632-12997-2-git-send-email-b16395@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1348060632-12997-1-git-send-email-b16395@freescale.com>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varun Sethi <Varun.Sethi@freescale.com>

Add a new field in the device (powerpc) archdata structure for storing iommu domain
information pointer. This pointer is stored when the device is attached to a particular
domain.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 arch/powerpc/include/asm/device.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 77e97dd..6dc79fe 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -28,6 +28,10 @@ struct dev_archdata {
 		void		*iommu_table_base;
 	} dma_data;
 
+	/* IOMMU domain information pointer. This would be set
+	 * when this device is attached to an iommu_domain.
+	 */
+	void			*iommu_domain;
 #ifdef CONFIG_SWIOTLB
 	dma_addr_t		max_direct_dma_addr;
 #endif
-- 
1.7.4.1


