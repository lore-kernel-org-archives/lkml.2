Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2LGG6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:58:39 -0500
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:33546 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149Ab2LGG6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:58:37 -0500
Date: Fri, 7 Dec 2012 07:56:45 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "ludovic.desroches" <ludovic.desroches@atmel.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, richard.genoud@gmail.com, JM.Lin@atmel.com,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [v2 PATCH 13/14] ARM: dts: add spi nodes for atmel SoC
Message-ID: <20121207065645.GG4398@game.jcrosoft.org>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
 <1354607640-13229-14-git-send-email-wenyou.yang@atmel.com>
 <50C0C9C9.9000108@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C0C9C9.9000108@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10640880020101508005
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:37 Thu 06 Dec     , ludovic.desroches wrote:
> Hi,
> 
> On 12/04/2012 08:53 AM, Wenyou Yang wrote:
> >From: Richard Genoud <richard.genoud@gmail.com>
> >
> >Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> >[wenyou.yang@atmel.com: add spi nodes for other atmel SOC]
> >Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> >Cc: linux@arm.linux.org.uk
> >---
> >  arch/arm/boot/dts/at91sam9260.dtsi |   30 ++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9263.dtsi |   30 ++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9g45.dtsi |   30 ++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9n12.dtsi |   30 ++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9x5.dtsi  |   30 ++++++++++++++++++++++++++++++
> >  5 files changed, 150 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
> >index d410581..87254aa 100644
> >--- a/arch/arm/boot/dts/at91sam9260.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9260.dtsi
> >@@ -212,6 +212,36 @@
> >  				status = "disabled";
> >  			};
> >
> >+			spi0: spi@fffc8000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffc8000 0x200>;
> >+				interrupts = <12 4 3>;
> >+				cs-gpios = <&pioA 3 0
> >+					    &pioC 11 0
> >+					    &pioC 16 0
> >+					    &pioC 17 0
> >+					   >;
> 
> From my point of view, the cs-gpios stuff should be in board dts
> files instead of the SoC dtsi file.
> 
> These pios can be shared with other devices. If only one chip select
> gpio is used on the board, it could avoid some useless pin
> conflicts.
agree and you MUST based on work on what I send on the ML and Grant applyed

Best Regards,
J.
> 
> Regards
> 
> Ludovic
> 
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >+			spi1: spi@fffcc000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffcc000 0x200>;
> >+				interrupts = <13 4 3>;
> >+				cs-gpios = <&pioB 3 0
> >+					    &pioC 5 0
> >+					    &pioC 4 0
> >+					    &pioC 3 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >  			adc0: adc@fffe0000 {
> >  				compatible = "atmel,at91sam9260-adc";
> >  				reg = <0xfffe0000 0x100>;
> >diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
> >index 3e6e5c1..528395d 100644
> >--- a/arch/arm/boot/dts/at91sam9263.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9263.dtsi
> >@@ -195,6 +195,36 @@
> >  				#size-cells = <0>;
> >  				status = "disabled";
> >  			};
> >+
> >+			spi0: spi@fffa4000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffa4000 0x200>;
> >+				interrupts = <14 4 3>;
> >+				cs-gpios = <&pioA 5 0
> >+					    &pioA 3 0
> >+					    &pioA 4 0
> >+					    &pioB 11 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >+			spi1: spi@fffa8000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffa8000 0x200>;
> >+				interrupts = <15 4 3>;
> >+				cs-gpios = <&pioB 15 0
> >+					    &pioB 16 0
> >+					    &pioB 17 0
> >+					    &pioB 18 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> >diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> >index 3add030..8a6aae92 100644
> >--- a/arch/arm/boot/dts/at91sam9g45.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> >@@ -262,6 +262,36 @@
> >  					trigger-value = <0x6>;
> >  				};
> >  			};
> >+
> >+			spi0: spi@fffa4000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffa4000 0x200>;
> >+				interrupts = <14 4 3>;
> >+				cs-gpios = <&pioB 3 0
> >+					    &pioB 18 0
> >+					    &pioB 19 0
> >+					    &pioD 27 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >+			spi1: spi@fffa8000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9260-spi";
> >+				reg = <0xfffa8000 0x200>;
> >+				interrupts = <15 4 3>;
> >+				cs-gpios = <&pioB 17 0
> >+					    &pioD 28 0
> >+					    &pioD 18 0
> >+					    &pioD 19 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> >diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> >index 82508d6..183cacf 100644
> >--- a/arch/arm/boot/dts/at91sam9n12.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> >@@ -202,6 +202,36 @@
> >  				#size-cells = <0>;
> >  				status = "disabled";
> >  			};
> >+
> >+			spi0: spi@f0000000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9x5-spi";
> >+				reg = <0xf0000000 0x100>;
> >+				interrupts = <13 4 3>;
> >+				cs-gpios = <&pioA 14 0
> >+					    &pioA 7 0
> >+					    &pioA 1 0
> >+					    &pioB 3 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >+			spi1: spi@f0004000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9x5-spi";
> >+				reg = <0xf0004000 0x100>;
> >+				interrupts = <14 4 3>;
> >+				cs-gpios = <&pioA 8 0
> >+					    &pioA 0 0
> >+					    &pioA 31 0
> >+					    &pioA 30 0
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> >diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> >index 03fc136..95b55fd 100644
> >--- a/arch/arm/boot/dts/at91sam9x5.dtsi
> >+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> >@@ -263,6 +263,36 @@
> >  					trigger-value = <0x6>;
> >  				};
> >  			};
> >+
> >+			spi0: spi@f0000000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9x5-spi";
> >+				reg = <0xf0000000 0x100>;
> >+				interrupts = <13 4 3>;
> >+				cs-gpios = <&pioA 14 0
> >+					    &pioA 7 0 /* conflicts with TXD2 */
> >+					    &pioA 1 0 /* conflicts with RXD0 */
> >+					    &pioB 3 0 /* conflicts with ERXDV */
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >+
> >+			spi1: spi@f0004000 {
> >+				#address-cells = <1>;
> >+				#size-cells = <0>;
> >+				compatible = "atmel,at91sam9x5-spi";
> >+				reg = <0xf0004000 0x100>;
> >+				interrupts = <14 4 3>;
> >+				cs-gpios = <&pioA 8 0 /* conflitcs with RXD2 */
> >+					    &pioA 0 0 /* conflitcs with TXD0 */
> >+					    &pioA 31 0 /* conflitcs with TWCK0 */
> >+					    &pioA 30 0 /* conflitcs with TWD0 */
> >+					   >;
> >+				dma-mask = <0xffffffff>;
> >+				status = "disabled";
> >+			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> >
> 
