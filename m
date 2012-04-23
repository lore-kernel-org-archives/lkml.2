Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2DWL72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:59:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11601 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DWL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:59:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Apr 2012 04:59:25 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] arm/dts: Tegra30: Add device tree support for SMMU
Date: Mon, 23 Apr 2012 14:58:55 +0300
Message-Id: <1335182340-17237-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
References: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for Tegra30 IOMMU(SMMU).

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 15200a9..f4929d5 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -224,4 +224,14 @@
 			nvidia,ahub-cif-ids = <8 8>;
 		};
 	};
+
+	smmu: smmu@7000f000 {
+		compatible = "nvidia,tegra30-smmu";
+		reg = <0x7000f010 0x2c		/* controller registers */
+		       0x7000f1f0 0x10		/* statics */
+		       0x7000f228 0x5c>;	/* module configuration */
+		interrupts = <0 13 0x40>;
+		asids = <4>;			/* # of ASIDs */
+		dma-window = <0 0x40000000>;	/* IOVA start & length */
+	};
 };
-- 
1.7.5.4

