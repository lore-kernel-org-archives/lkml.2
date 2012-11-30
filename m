Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2K3LI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:08:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2K3LH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:07:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ac-50b8936f43da
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCH 4/4] DMA: PL330: add device tree property for DMA_MEMCPY
 capability
Date: Fri, 30 Nov 2012 11:56:07 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Jassi Brar <jassisinghbrar@gmail.com>, kgene.kim@samsung.com,
        pawel.moll@arm.com, vinod.koul@intel.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        dinguyen@altera.com, linux-arm-kernel@lists.infradead.org
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <201210301021.42803.b.zolnierkie@samsung.com>
 <CAJe_ZhdOt+T65FdkE0SpQ37uGsS8SkFyJ9hHM3B_8S8f7GQAcQ@mail.gmail.com>
In-reply-to: <CAJe_ZhdOt+T65FdkE0SpQ37uGsS8SkFyJ9hHM3B_8S8f7GQAcQ@mail.gmail.com>
MIME-version: 1.0
Message-id: <201211301156.08060.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd38yTsCDJ4/krS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrouD+RueBdB2PFhkm7GRsY1+Z0MXJySAiYSFx9cI8Z
	whaTuHBvPVsXIxeHkMB0RomOX/9YIJwWJomHOy6ygVSxCVhJTGxfxQhiiwhoS+x59YYFxBYW
	iJQ4Ma0VrIZFQFWiZclbJhBbVMBBonPqBLCpzALbmCRmLnzGDDF1P6PEpBkTwSZxCgRLbOg+
	B9bNKyAo8WPyPRYI21Li05ZPYHFmAS2J5jebGCFseYnNa94yT2AUmIWkZRaSsllIyhYwMq9i
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7JZ1I7GFc2WBxiFOBgVOLh3bBhe4AQa2JZcWXu
	IUYJDmYlEd59gjsChHhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZ
	ODilGhh3z3zZ59ZsqZza6tXR12rL+eDazzVPFC5PLlqVlvVXROJq4q09nqVxFR59Ti373yRe
	Yrt1Y3/IwkXxDD6fo2V2f52aJuv5TvJ22t3kxMTbOqk9+9ZOfSUmX7X7qvNu7RXNfxXPbwlm
	Mt68crWII4f3F5Wo1pYS8/+Hj3zhSDAulL3EFdNgw6vEUpyRaKjFXFScCADZLkn4RQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 November 2012 07:11:30 Jassi Brar wrote:
> On 30 October 2012 14:51, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> >
> > Hi,
> >
> > On Monday 29 October 2012 22:45:48 Jassi Brar wrote:
> >> On Mon, Oct 29, 2012 at 10:59 AM, Bartlomiej Zolnierkiewicz
> >> <b.zolnierkie@samsung.com> wrote:
> >> > * Add device tree (DT) property ("pl330,dma-memcpy") for DMA_MEMCPY
> >> >   capability and instead of setting this capability unconditionally
> >> >   in pl330_probe() do it only when property is present.
> >> >
> >> Perhaps we should pass the array of peripheral interfaces via DT, the
> >> lack of which could imply MEMCPY capability ? (while it works, I doubt
> >> if pl330 is supposed to have SLAVE and MEMCPY capabilities in any
> >> instance)
> >
> > In case of PL330 on EXYNOS4 we have two interfaces with SLAVE capability
> > and one interface with MEMCPY capability.  Could you please explain more
> > the idea of passing the array of peripherals through DT so we can detect
> > which interface has MEMCPY capability?
> >
> The DT node of a 'pdma' should have the array of indices of
> peripherals it caters to (what is currently peri_id of 'struct
> dma_pl330_platdata'). The array would be missing in the DT node of
> 'mdma' since all channels are equal.
> During probe if the array, say as property 'peri_map', is missing from
> DT node of the dmac, that would imply the dmac is 'mdma' and hence the
> pl330.c sets DMA_MEMCPY in its cap_mask. Otherwise the peri_map
> implies a 'pdma' and hence SLAVE|CYCLIC is set.
> 
> 
> >> That would also be a step towards discarding "struct dma_pl330_platdata".
> >
> > I don't know if getting rid of "struct dma_pl330_platdata" is possible
> > but we still need to come up with some way to pass the needed information
> > through DT.  Do you have an idea how it could be done?
> >
> struct dma_pl330_platdata {
>   u8 nr_valid_peri;
>   u8 *peri_id;
>       As explain above, these two should move to DT node of the dma controller.
> 
>   dma_cap_mask_t cap_mask;
>       Should be set in pl330.c : MEMCPY for mdma,  SLAVE|CYCLIC for pdma
> 
>   unsigned mcbuf_sz;
>       Currently unused and already safe enough default value set in driver.
> }

Thank you for explaining it.  Here is a patch implementing the idea:

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] DMA: PL330: add peripherals map to the device tree

Add device tree (DT) property ("peri-map") for storing indices
of peripherals connected to DMAC and fix DT nodes of client
drivers to use 'dma peripheral id' instead of 'dma request id'.
Also instead of setting DMA_MEMCPY capability unconditionally in
pl330_probe() do it only when "peri-map" DT property is present
(idea from Jassi Brar).  It fixes the issue on ARM EXYNOS
platforms using DT where pdma controller erroneously was used
for DMA_MEMCPY operations instead of mdma one (it seems to work
correctly but at the cost of worse performance).

While at it:
- add missing kfree() to pl330_[probe,remove]()
- fix typo in samsung_dmadev_request()

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
I wonder whether "peri-map" also needs to be added to following files:

	arch/arm/boot/dts/highbank.dts
	arch/arm/boot/dts/socfpga.dtsi
	arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
	arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts

(since they're also using pl330)?

 Documentation/devicetree/bindings/dma/arm-pl330.txt |    5 
 arch/arm/boot/dts/exynos4.dtsi                      |   21 +-
 arch/arm/boot/dts/exynos5250.dtsi                   |   20 +-
 arch/arm/plat-samsung/dma-ops.c                     |    2 
 arch/arm/plat-samsung/include/plat/dma-pl330.h      |  155 +++++++++-----------
 drivers/dma/pl330.c                                 |   54 +++++-
 6 files changed, 152 insertions(+), 105 deletions(-)

Index: b/Documentation/devicetree/bindings/dma/arm-pl330.txt
===================================================================
--- a/Documentation/devicetree/bindings/dma/arm-pl330.txt	2012-11-28 17:41:36.997626033 +0100
+++ b/Documentation/devicetree/bindings/dma/arm-pl330.txt	2012-11-28 17:42:23.433626905 +0100
@@ -11,6 +11,7 @@ Required properties:
 
 Optional properties:
 - dma-coherent      : Present if dma operations are coherent
+- peri-map          : An array of indices of peripherals connected to DMAC
 
 Example:
 
@@ -24,9 +25,9 @@ Client drivers (device nodes requiring d
 mem-to-dev) should specify the DMA channel numbers using a two-value pair
 as shown below.
 
-  [property name]  = <[phandle of the dma controller] [dma request id]>;
+  [property name]  = <[phandle of the dma controller] [dma peripheral id]>;
 
-      where 'dma request id' is the dma request number which is connected
+      where 'dma peripheral id' is the id of peripheral which is connected
       to the client controller. The 'property name' is recommended to be
       of the form <name>-dma-channel.
 
Index: b/arch/arm/boot/dts/exynos4.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos4.dtsi	2012-11-28 17:41:37.033626034 +0100
+++ b/arch/arm/boot/dts/exynos4.dtsi	2012-11-28 17:42:23.433626905 +0100
@@ -256,8 +256,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x13920000 0x100>;
 		interrupts = <0 66 0>;
-		tx-dma-channel = <&pdma0 7>; /* preliminary */
-		rx-dma-channel = <&pdma0 6>; /* preliminary */
+		tx-dma-channel = <&pdma0 23>;
+		rx-dma-channel = <&pdma0 22>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
@@ -267,8 +267,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x13930000 0x100>;
 		interrupts = <0 67 0>;
-		tx-dma-channel = <&pdma1 7>; /* preliminary */
-		rx-dma-channel = <&pdma1 6>; /* preliminary */
+		tx-dma-channel = <&pdma1 25>;
+		rx-dma-channel = <&pdma1 24>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
@@ -278,8 +278,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x13940000 0x100>;
 		interrupts = <0 68 0>;
-		tx-dma-channel = <&pdma0 9>; /* preliminary */
-		rx-dma-channel = <&pdma0 8>; /* preliminary */
+		tx-dma-channel = <&pdma0 27>;
+		rx-dma-channel = <&pdma0 26>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
@@ -303,12 +303,21 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12680000 0x1000>;
 			interrupts = <0 35 0>;
+			peri-map = < 37 36 41 40 60 61 22 23 26 27
+				     17 15 16 20 21  0  1  4  5  8
+				      9 46 47 52 53 56 57 28 29 30
+				     64 65 >;
+
 		};
 
 		pdma1: pdma@12690000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12690000 0x1000>;
 			interrupts = <0 36 0>;
+			peri-map = < 37 36 39 38 62 63 24 25 17 15
+				     16 18 19  0  1  2  3  6  7 50
+				     51 54 55 58 59 48 49 33 66 67 >;
+
 		};
 
 		mdma1: mdma@12850000 {
Index: b/arch/arm/boot/dts/exynos5250.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos5250.dtsi	2012-11-28 17:41:37.021626034 +0100
+++ b/arch/arm/boot/dts/exynos5250.dtsi	2012-11-28 17:42:23.433626905 +0100
@@ -160,8 +160,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x12d20000 0x100>;
 		interrupts = <0 66 0>;
-		tx-dma-channel = <&pdma0 5>; /* preliminary */
-		rx-dma-channel = <&pdma0 4>; /* preliminary */
+		tx-dma-channel = <&pdma0 23>;
+		rx-dma-channel = <&pdma0 22>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
@@ -170,8 +170,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x12d30000 0x100>;
 		interrupts = <0 67 0>;
-		tx-dma-channel = <&pdma1 5>; /* preliminary */
-		rx-dma-channel = <&pdma1 4>; /* preliminary */
+		tx-dma-channel = <&pdma1 25>;
+		rx-dma-channel = <&pdma1 24>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
@@ -180,8 +180,8 @@
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x12d40000 0x100>;
 		interrupts = <0 68 0>;
-		tx-dma-channel = <&pdma0 7>; /* preliminary */
-		rx-dma-channel = <&pdma0 6>; /* preliminary */
+		tx-dma-channel = <&pdma0 27>;
+		rx-dma-channel = <&pdma0 26>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
@@ -229,12 +229,20 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x121A0000 0x1000>;
 			interrupts = <0 34 0>;
+			peri-map = < 37 36 41 40 22 23 26 27 17 15
+				     16 20 21  0  1  4  5  8  9 46
+				     47 52 53 56 57 28 29 30 60 62
+				     64 66 >;
 		};
 
 		pdma1: pdma@121B0000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x121B0000 0x1000>;
 			interrupts = <0 35 0>;
+			peri-map = < 37 36 39 38 24 25 32 33 17 15
+				     16 18 19  0  1  2  3  6  7 50
+				     51 54 55 58 59 48 49 68 61 63
+				     65 67 >;
 		};
 
 		mdma0: mdma@10800000 {
Index: b/arch/arm/plat-samsung/dma-ops.c
===================================================================
--- a/arch/arm/plat-samsung/dma-ops.c	2012-11-28 17:41:37.057626035 +0100
+++ b/arch/arm/plat-samsung/dma-ops.c	2012-11-28 17:42:23.433626905 +0100
@@ -29,7 +29,7 @@ static unsigned samsung_dmadev_request(e
 
 	/*
 	 * If a dma channel property of a device node from device tree is
-	 * specified, use that as the fliter parameter.
+	 * specified, use that as the filter parameter.
 	 */
 	filter_param = (dma_ch == DMACH_DT_PROP) ?
 		(void *)param->dt_dmach_prop : (void *)dma_ch;
Index: b/arch/arm/plat-samsung/include/plat/dma-pl330.h
===================================================================
--- a/arch/arm/plat-samsung/include/plat/dma-pl330.h	2012-11-28 17:41:37.045626034 +0100
+++ b/arch/arm/plat-samsung/include/plat/dma-pl330.h	2012-11-28 17:42:23.433626905 +0100
@@ -17,88 +17,87 @@
  * For the sake of consistency across client drivers,
  * We keep the channel names unchanged and only add
  * missing peripherals are added.
- * Order is not important since DMA PL330 API driver
- * use these just as IDs.
+ * Order is important since IDs are used by device tree.
  */
 enum dma_ch {
 	DMACH_DT_PROP = -1,
 	DMACH_UART0_RX = 0,
-	DMACH_UART0_TX,
-	DMACH_UART1_RX,
-	DMACH_UART1_TX,
-	DMACH_UART2_RX,
-	DMACH_UART2_TX,
-	DMACH_UART3_RX,
-	DMACH_UART3_TX,
-	DMACH_UART4_RX,
-	DMACH_UART4_TX,
-	DMACH_UART5_RX,
-	DMACH_UART5_TX,
-	DMACH_USI_RX,
-	DMACH_USI_TX,
-	DMACH_IRDA,
-	DMACH_I2S0_RX,
-	DMACH_I2S0_TX,
-	DMACH_I2S0S_TX,
-	DMACH_I2S1_RX,
-	DMACH_I2S1_TX,
-	DMACH_I2S2_RX,
-	DMACH_I2S2_TX,
-	DMACH_SPI0_RX,
-	DMACH_SPI0_TX,
-	DMACH_SPI1_RX,
-	DMACH_SPI1_TX,
-	DMACH_SPI2_RX,
-	DMACH_SPI2_TX,
-	DMACH_AC97_MICIN,
-	DMACH_AC97_PCMIN,
-	DMACH_AC97_PCMOUT,
-	DMACH_EXTERNAL,
-	DMACH_PWM,
-	DMACH_SPDIF,
-	DMACH_HSI_RX,
-	DMACH_HSI_TX,
-	DMACH_PCM0_TX,
-	DMACH_PCM0_RX,
-	DMACH_PCM1_TX,
-	DMACH_PCM1_RX,
-	DMACH_PCM2_TX,
-	DMACH_PCM2_RX,
-	DMACH_MSM_REQ3,
-	DMACH_MSM_REQ2,
-	DMACH_MSM_REQ1,
-	DMACH_MSM_REQ0,
-	DMACH_SLIMBUS0_RX,
-	DMACH_SLIMBUS0_TX,
-	DMACH_SLIMBUS0AUX_RX,
-	DMACH_SLIMBUS0AUX_TX,
-	DMACH_SLIMBUS1_RX,
-	DMACH_SLIMBUS1_TX,
-	DMACH_SLIMBUS2_RX,
-	DMACH_SLIMBUS2_TX,
-	DMACH_SLIMBUS3_RX,
-	DMACH_SLIMBUS3_TX,
-	DMACH_SLIMBUS4_RX,
-	DMACH_SLIMBUS4_TX,
-	DMACH_SLIMBUS5_RX,
-	DMACH_SLIMBUS5_TX,
-	DMACH_MIPI_HSI0,
-	DMACH_MIPI_HSI1,
-	DMACH_MIPI_HSI2,
-	DMACH_MIPI_HSI3,
-	DMACH_MIPI_HSI4,
-	DMACH_MIPI_HSI5,
-	DMACH_MIPI_HSI6,
-	DMACH_MIPI_HSI7,
-	DMACH_DISP1,
-	DMACH_MTOM_0,
-	DMACH_MTOM_1,
-	DMACH_MTOM_2,
-	DMACH_MTOM_3,
-	DMACH_MTOM_4,
-	DMACH_MTOM_5,
-	DMACH_MTOM_6,
-	DMACH_MTOM_7,
+	DMACH_UART0_TX = 1,
+	DMACH_UART1_RX = 2,
+	DMACH_UART1_TX = 3,
+	DMACH_UART2_RX = 4,
+	DMACH_UART2_TX = 5,
+	DMACH_UART3_RX = 6,
+	DMACH_UART3_TX = 7,
+	DMACH_UART4_RX = 8,
+	DMACH_UART4_TX = 9,
+	DMACH_UART5_RX = 10,
+	DMACH_UART5_TX = 11,
+	DMACH_USI_RX = 12,
+	DMACH_USI_TX = 13,
+	DMACH_IRDA = 14,
+	DMACH_I2S0_RX = 15,
+	DMACH_I2S0_TX = 16,
+	DMACH_I2S0S_TX = 17,
+	DMACH_I2S1_RX = 18,
+	DMACH_I2S1_TX = 19,
+	DMACH_I2S2_RX = 20,
+	DMACH_I2S2_TX = 21,
+	DMACH_SPI0_RX = 22,
+	DMACH_SPI0_TX = 23,
+	DMACH_SPI1_RX = 24,
+	DMACH_SPI1_TX = 25,
+	DMACH_SPI2_RX = 26,
+	DMACH_SPI2_TX = 27,
+	DMACH_AC97_MICIN = 28,
+	DMACH_AC97_PCMIN = 29,
+	DMACH_AC97_PCMOUT = 30,
+	DMACH_EXTERNAL = 31,
+	DMACH_PWM = 32,
+	DMACH_SPDIF = 33,
+	DMACH_HSI_RX = 34,
+	DMACH_HSI_TX = 35,
+	DMACH_PCM0_TX = 36,
+	DMACH_PCM0_RX = 37,
+	DMACH_PCM1_TX = 38,
+	DMACH_PCM1_RX = 39,
+	DMACH_PCM2_TX = 40,
+	DMACH_PCM2_RX = 41,
+	DMACH_MSM_REQ3 = 42,
+	DMACH_MSM_REQ2 = 43,
+	DMACH_MSM_REQ1 = 44,
+	DMACH_MSM_REQ0 = 45,
+	DMACH_SLIMBUS0_RX = 46,
+	DMACH_SLIMBUS0_TX = 47,
+	DMACH_SLIMBUS0AUX_RX = 48,
+	DMACH_SLIMBUS0AUX_TX = 49,
+	DMACH_SLIMBUS1_RX = 50,
+	DMACH_SLIMBUS1_TX = 51,
+	DMACH_SLIMBUS2_RX = 52,
+	DMACH_SLIMBUS2_TX = 53,
+	DMACH_SLIMBUS3_RX = 54,
+	DMACH_SLIMBUS3_TX = 55,
+	DMACH_SLIMBUS4_RX = 56,
+	DMACH_SLIMBUS4_TX = 57,
+	DMACH_SLIMBUS5_RX = 58,
+	DMACH_SLIMBUS5_TX = 59,
+	DMACH_MIPI_HSI0 = 60,
+	DMACH_MIPI_HSI1 = 61,
+	DMACH_MIPI_HSI2 = 62,
+	DMACH_MIPI_HSI3 = 63,
+	DMACH_MIPI_HSI4 = 64,
+	DMACH_MIPI_HSI5 = 65,
+	DMACH_MIPI_HSI6 = 66,
+	DMACH_MIPI_HSI7 = 67,
+	DMACH_DISP1 = 68,
+	DMACH_MTOM_0 = 69,
+	DMACH_MTOM_1 = 70,
+	DMACH_MTOM_2 = 71,
+	DMACH_MTOM_3 = 72,
+	DMACH_MTOM_4 = 73,
+	DMACH_MTOM_5 = 74,
+	DMACH_MTOM_6 = 75,
+	DMACH_MTOM_7 = 76,
 	/* END Marker, also used to denote a reserved channel */
 	DMACH_MAX,
 };
Index: b/drivers/dma/pl330.c
===================================================================
--- a/drivers/dma/pl330.c	2012-11-28 17:41:37.009626033 +0100
+++ b/drivers/dma/pl330.c	2012-11-28 17:50:27.301635989 +0100
@@ -306,6 +306,8 @@ struct pl330_config {
 struct pl330_info {
 	/* Owning device */
 	struct device *dev;
+	/* Array of valid peripherals */
+	u32 *peri_id;
 	/* Size of MicroCode buffers for each channel. */
 	unsigned mcbufsz;
 	/* ioremap'ed address of PL330 registers. */
@@ -2368,8 +2370,9 @@ bool pl330_filter(struct dma_chan *chan,
 		prop_value = ((struct property *)param)->value;
 		phandle = be32_to_cpup(prop_value++);
 		node = of_find_node_by_phandle(phandle);
-		return ((chan->private == node) &&
-				(chan->chan_id == be32_to_cpup(prop_value)));
+		peri_id = chan->private;
+		return chan->device->dev->of_node == node &&
+		       *peri_id == be32_to_cpup(prop_value);
 	}
 #endif
 
@@ -2911,8 +2914,28 @@ pl330_probe(struct amba_device *adev, co
 	/* Initialize channel parameters */
 	if (pdat)
 		num_chan = max_t(int, pdat->nr_valid_peri, pi->pcfg.num_chan);
-	else
-		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
+	else {
+		struct device_node *np = pi->dev->of_node;
+		int nr_valid_peri = 0;
+
+		of_find_property(np, "peri-map", &nr_valid_peri);
+		if (nr_valid_peri) {
+			nr_valid_peri /= 4;
+
+			pi->peri_id = kzalloc(nr_valid_peri * 4, GFP_KERNEL);
+			if (!pi->peri_id) {
+				ret = -ENOMEM;
+				dev_err(&adev->dev,
+					"unable to allocate pi->peri_id\n");
+				goto probe_err4;
+			}
+			of_property_read_u32_array(np, "peri-map", pi->peri_id,
+						   nr_valid_peri);
+		} else
+			nr_valid_peri = pi->pcfg.num_peri;
+
+		num_chan = max_t(int, nr_valid_peri, pi->pcfg.num_chan);
+	}
 
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
 	if (!pdmac->peripherals) {
@@ -2923,10 +2946,11 @@ pl330_probe(struct amba_device *adev, co
 
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];
-		if (!adev->dev.of_node)
-			pch->chan.private = pdat ? &pdat->peri_id[i] : NULL;
-		else
-			pch->chan.private = adev->dev.of_node;
+
+		if (pdat)
+			pch->chan.private = &pdat->peri_id[i];
+		else if (pi->peri_id)
+			pch->chan.private = &pi->peri_id[i];
 
 		INIT_LIST_HEAD(&pch->work_list);
 		spin_lock_init(&pch->lock);
@@ -2942,12 +2966,12 @@ pl330_probe(struct amba_device *adev, co
 	if (pdat) {
 		pd->cap_mask = pdat->cap_mask;
 	} else {
-		dma_cap_set(DMA_MEMCPY, pd->cap_mask);
-		if (pi->pcfg.num_peri) {
+		if (pi->peri_id) {
 			dma_cap_set(DMA_SLAVE, pd->cap_mask);
 			dma_cap_set(DMA_CYCLIC, pd->cap_mask);
 			dma_cap_set(DMA_PRIVATE, pd->cap_mask);
-		}
+		} else
+			dma_cap_set(DMA_MEMCPY, pd->cap_mask);
 	}
 
 	pd->device_alloc_chan_resources = pl330_alloc_chan_resources;
@@ -2962,7 +2986,7 @@ pl330_probe(struct amba_device *adev, co
 	ret = dma_async_device_register(pd);
 	if (ret) {
 		dev_err(&adev->dev, "unable to register DMAC\n");
-		goto probe_err4;
+		goto probe_err5;
 	}
 
 	dev_info(&adev->dev,
@@ -2975,7 +2999,10 @@ pl330_probe(struct amba_device *adev, co
 
 	return 0;
 
+probe_err5:
+	kfree(pdmac->peripherals);
 probe_err4:
+	kfree(pi->peri_id);
 	pl330_del(pi);
 probe_err3:
 	free_irq(irq, pi);
@@ -3013,8 +3040,11 @@ static int __devexit pl330_remove(struct
 		pl330_free_chan_resources(&pch->chan);
 	}
 
+	kfree(pdmac->peripherals);
+
 	pi = &pdmac->pif;
 
+	kfree(pi->peri_id);
 	pl330_del(pi);
 
 	irq = adev->irq[0];

