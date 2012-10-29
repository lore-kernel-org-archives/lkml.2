Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2J2KAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:00:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53766 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430Ab2J2KAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:00:46 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-8c-508e53cc57db
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: jassisinghbrar@gmail.com, vinod.koul@intel.com, kgene.kim@samsung.com,
        rob.herring@calxeda.com, dinguyen@altera.com, pawel.moll@arm.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4/4] DMA: PL330: add device tree property for DMA_MEMCPY
 capability
Date: Mon, 29 Oct 2012 10:59:56 +0100
Message-id: <1351504796-24788-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jQd0zwX0BBlN6TS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJOrr7OXjBHp2LKne9MDYzLlbsYOTkkBEwkel8cY4aw
	xSQu3FvP1sXIxSEkMJ1R4t67eYwgCSGBLiaJ10fsQWw2ASuJie2rwOIiAtkSP75NZgFpYBb4
	xiixuX8xG0hCWCBU4tazuWBTWQRUJfae2M0OYvMKeEgcWfaKCWKbvMTT+31g9ZwCnhKnJ65i
	hljmIfHv0372CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEe/+Z1A7GlQ0WhxgF
	OBiVeHgb3/QGCLEmlhVX5h5ilOBgVhLhXcoNFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JES
	ICSQnliSmp2aWpBaBJNl4uCUamDknrCN23ni74SsepYVO5UObkxpjLGf2KTcI7TF+FpE5NQs
	5tC+t+rX2IOr+FZ5fq6V5ZrktJlz63X5A0bvQnO4Fdlf/o950WP48ejDuiNVr34//Rg7uetS
	6lRn+X1TtJZGGq0x+vFmbvXyiYxFK44pLYuqmn3c3/8Bx3fVfYl7Ly7ymLrHweqmEktxRqKh
	FnNRcSIAw/xEzPoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add device tree (DT) property ("pl330,dma-memcpy") for DMA_MEMCPY
  capability and instead of setting this capability unconditionally
  in pl330_probe() do it only when property is present.

* Set the new "pl330,dma-memcpy" device tree property for all
  current pl330 driver users except pdma controllers on ARM EXYNOS
  platforms (so the DT case matches non-DT one).

It fixes the issue on ARM EXYNOS platforms using DT where pdma
controller erroneously was used for DMA_MEMCPY operations instead
of mdma one (it surprisingly seems to work but at the cost of
worse performance).

Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Dinh Nguyen <dinguyen@altera.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/dma/arm-pl330.txt |  1 +
 arch/arm/boot/dts/exynos4.dtsi                      |  1 +
 arch/arm/boot/dts/exynos5250.dtsi                   |  2 ++
 arch/arm/boot/dts/highbank.dts                      |  1 +
 arch/arm/boot/dts/socfpga.dtsi                      |  1 +
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts         |  1 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts          |  1 +
 drivers/dma/pl330.c                                 | 11 ++++++++---
 8 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/arm-pl330.txt b/Documentation/devicetree/bindings/dma/arm-pl330.txt
index 36e27d5..2661c7b 100644
--- a/Documentation/devicetree/bindings/dma/arm-pl330.txt
+++ b/Documentation/devicetree/bindings/dma/arm-pl330.txt
@@ -11,6 +11,7 @@ Required properties:
 
 Optional properties:
 - dma-coherent      : Present if dma operations are coherent
+- pl330,dma-memcpy  : Present if controller has DMA_MEMCPY capability
 
 Example:
 
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 96d4462..ce5b03f 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -249,6 +249,7 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12850000 0x1000>;
 			interrupts = <0 34 0>;
+			pl330,dma-memcpy;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 49546bc..d659e7b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -247,12 +247,14 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x10800000 0x1000>;
 			interrupts = <0 33 0>;
+			pl330,dma-memcpy;
 		};
 
 		mdma1: mdma@11C10000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x11C10000 0x1000>;
 			interrupts = <0 124 0>;
+			pl330,dma-memcpy;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index 0c6fc34..87f1d25 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -297,6 +297,7 @@
 			interrupts = <0 92 4>;
 			clocks = <&pclk>;
 			clock-names = "apb_pclk";
+			pl330,dma-memcpy;
 		};
 
 		ethernet@fff50000 {
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 0772f57..2fe1697 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -71,6 +71,7 @@
 				compatible = "arm,pl330", "arm,primecell";
 				reg = <0xffe01000 0x1000>;
 				interrupts = <0 180 4>;
+				pl330,dma-memcpy;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts b/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
index d12b34c..d82953c 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
@@ -94,6 +94,7 @@
 			     <0 89 4>,
 			     <0 90 4>,
 			     <0 91 4>;
+		pl330,dma-memcpy;
 	};
 
 	timer {
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 4890a81..b9e6ba2 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -114,6 +114,7 @@
 			     <0 89 4>,
 			     <0 90 4>,
 			     <0 91 4>;
+		pl330,dma-memcpy;
 	};
 
 	timer {
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index db7574b..e10290b 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2860,6 +2860,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	struct pl330_info *pi;
 	struct dma_device *pd;
 	struct resource *res;
+	struct device_node *node;
 	int i, ret, irq;
 	int num_chan;
 
@@ -2921,12 +2922,14 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		goto probe_err4;
 	}
 
+	node = adev->dev.of_node;
+
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];
-		if (!adev->dev.of_node)
+		if (!node)
 			pch->chan.private = pdat ? &pdat->peri_id[i] : NULL;
 		else
-			pch->chan.private = adev->dev.of_node;
+			pch->chan.private = node;
 
 		INIT_LIST_HEAD(&pch->work_list);
 		spin_lock_init(&pch->lock);
@@ -2942,7 +2945,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	if (pdat) {
 		pd->cap_mask = pdat->cap_mask;
 	} else {
-		dma_cap_set(DMA_MEMCPY, pd->cap_mask);
+		if (adev->dev.of_node &&
+		    of_find_property(node, "pl330,dma-memcpy", NULL))
+			dma_cap_set(DMA_MEMCPY, pd->cap_mask);
 		if (pi->pcfg.num_peri) {
 			dma_cap_set(DMA_SLAVE, pd->cap_mask);
 			dma_cap_set(DMA_CYCLIC, pd->cap_mask);
-- 
1.8.0

