Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2KUJkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:40:05 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:36909 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2KUJkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:40:00 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/3] arm: dma mapping: Export a dma ops function arm_dma_set_mask
Date: Wed, 21 Nov 2012 10:39:40 +0100
Message-Id: <1353490783-23101-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353490783-23101-1-git-send-email-gregory.clement@free-electrons.com>
References: <1353490783-23101-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose another DMA operations function: arm_dma_set_mask. This
function will be added to a custom DMA ops for Armada 370/XP.
Depending of its configuration Armada 370/XP can be set as a "nearly"
coherent architecture. In this case the DMA ops is made of:
- specific functions for this architecture
- already exposed arm DMA related functions
- the arm_dma_set_mask which was not exposed yet.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/include/asm/dma-mapping.h |    2 ++
 arch/arm/mm/dma-mapping.c          |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 2300484..98d4dab 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -111,6 +111,8 @@ static inline void dma_free_noncoherent(struct device *dev, size_t size,
 
 extern int dma_supported(struct device *dev, u64 mask);
 
+extern int arm_dma_set_mask(struct device *dev, u64 dma_mask);
+
 /**
  * arm_dma_alloc - allocate consistent memory for DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 58bc3e4..5383bc0 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -124,8 +124,6 @@ static void arm_dma_sync_single_for_device(struct device *dev,
 	__dma_page_cpu_to_dev(page, offset, size, dir);
 }
 
-static int arm_dma_set_mask(struct device *dev, u64 dma_mask);
-
 struct dma_map_ops arm_dma_ops = {
 	.alloc			= arm_dma_alloc,
 	.free			= arm_dma_free,
@@ -971,7 +969,7 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-static int arm_dma_set_mask(struct device *dev, u64 dma_mask)
+int arm_dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
-- 
1.7.9.5

