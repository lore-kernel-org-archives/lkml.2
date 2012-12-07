Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2LGBhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:37:07 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:16468 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2LGBhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:37:05 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>
Subject: RE: [v2 PATCH 13/14] ARM: dts: add spi nodes for atmel SoC
Thread-Topic: [v2 PATCH 13/14] ARM: dts: add spi nodes for atmel SoC
Thread-Index: AQHN0fWPufj8ex0uHEaViHHL/ie5upgLde+AgAEY2LA=
Date: Fri, 7 Dec 2012 01:34:01 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A01DEF5@penmbx01>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
 <1354607640-13229-14-git-send-email-wenyou.yang@atmel.com>
 <50C0C9C9.9000108@atmel.com>
In-Reply-To: <50C0C9C9.9000108@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB71b9K5023869

Hi Ludovic,

> -----Original Message-----
> From: Desroches, Ludovic
> Sent: 2012Äê12ÔÂ7ÈÕ 0:37
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
> richard.genoud@gmail.com; Lin, JM; Ferre, Nicolas; linux-kernel@vger.kernel.org;
> plagnioj@jcrosoft.com; Desroches, Ludovic
> Subject: Re: [v2 PATCH 13/14] ARM: dts: add spi nodes for atmel SoC
> 
> Hi,
> 
> On 12/04/2012 08:53 AM, Wenyou Yang wrote:
> > From: Richard Genoud <richard.genoud@gmail.com>
> >
> > Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> > [wenyou.yang@atmel.com: add spi nodes for other atmel SOC]
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: linux@arm.linux.org.uk
> > ---
> >   arch/arm/boot/dts/at91sam9260.dtsi |   30
> ++++++++++++++++++++++++++++++
> >   arch/arm/boot/dts/at91sam9263.dtsi |   30
> ++++++++++++++++++++++++++++++
> >   arch/arm/boot/dts/at91sam9g45.dtsi |   30
> ++++++++++++++++++++++++++++++
> >   arch/arm/boot/dts/at91sam9n12.dtsi |   30
> ++++++++++++++++++++++++++++++
> >   arch/arm/boot/dts/at91sam9x5.dtsi  |   30
> ++++++++++++++++++++++++++++++
> >   5 files changed, 150 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/at91sam9260.dtsi
> b/arch/arm/boot/dts/at91sam9260.dtsi
> > index d410581..87254aa 100644
> > --- a/arch/arm/boot/dts/at91sam9260.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> > @@ -212,6 +212,36 @@
> >   				status = "disabled";
> >   			};
> >
> > +			spi0: spi@fffc8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffc8000 0x200>;
> > +				interrupts = <12 4 3>;
> > +				cs-gpios = <&pioA 3 0
> > +					    &pioC 11 0
> > +					    &pioC 16 0
> > +					    &pioC 17 0
> > +					   >;
> 
>  From my point of view, the cs-gpios stuff should be in board dts files
> instead of the SoC dtsi file.
> 
> These pios can be shared with other devices. If only one chip select
> gpio is used on the board, it could avoid some useless pin conflicts.
> 
Thanks
These pins are defined as CS0, CS1, CS2 and CS3 for SoC. it is selected for the board.
And it will not be configured unless it is selected. So it doesn't cause pin conficts.

> Regards
> 
> Ludovic
>
Best Regards,
Wenyou Yang
 
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffcc000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffcc000 0x200>;
> > +				interrupts = <13 4 3>;
> > +				cs-gpios = <&pioB 3 0
> > +					    &pioC 5 0
> > +					    &pioC 4 0
> > +					    &pioC 3 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> >   			adc0: adc@fffe0000 {
> >   				compatible = "atmel,at91sam9260-adc";
> >   				reg = <0xfffe0000 0x100>;
> > diff --git a/arch/arm/boot/dts/at91sam9263.dtsi
> b/arch/arm/boot/dts/at91sam9263.dtsi
> > index 3e6e5c1..528395d 100644
> > --- a/arch/arm/boot/dts/at91sam9263.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> > @@ -195,6 +195,36 @@
> >   				#size-cells = <0>;
> >   				status = "disabled";
> >   			};
> > +
> > +			spi0: spi@fffa4000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa4000 0x200>;
> > +				interrupts = <14 4 3>;
> > +				cs-gpios = <&pioA 5 0
> > +					    &pioA 3 0
> > +					    &pioA 4 0
> > +					    &pioB 11 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffa8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa8000 0x200>;
> > +				interrupts = <15 4 3>;
> > +				cs-gpios = <&pioB 15 0
> > +					    &pioB 16 0
> > +					    &pioB 17 0
> > +					    &pioB 18 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> >   		};
> >
> >   		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi
> b/arch/arm/boot/dts/at91sam9g45.dtsi
> > index 3add030..8a6aae92 100644
> > --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> > @@ -262,6 +262,36 @@
> >   					trigger-value = <0x6>;
> >   				};
> >   			};
> > +
> > +			spi0: spi@fffa4000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa4000 0x200>;
> > +				interrupts = <14 4 3>;
> > +				cs-gpios = <&pioB 3 0
> > +					    &pioB 18 0
> > +					    &pioB 19 0
> > +					    &pioD 27 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffa8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa8000 0x200>;
> > +				interrupts = <15 4 3>;
> > +				cs-gpios = <&pioB 17 0
> > +					    &pioD 28 0
> > +					    &pioD 18 0
> > +					    &pioD 19 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> >   		};
> >
> >   		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi
> b/arch/arm/boot/dts/at91sam9n12.dtsi
> > index 82508d6..183cacf 100644
> > --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> > @@ -202,6 +202,36 @@
> >   				#size-cells = <0>;
> >   				status = "disabled";
> >   			};
> > +
> > +			spi0: spi@f0000000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0000000 0x100>;
> > +				interrupts = <13 4 3>;
> > +				cs-gpios = <&pioA 14 0
> > +					    &pioA 7 0
> > +					    &pioA 1 0
> > +					    &pioB 3 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@f0004000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0004000 0x100>;
> > +				interrupts = <14 4 3>;
> > +				cs-gpios = <&pioA 8 0
> > +					    &pioA 0 0
> > +					    &pioA 31 0
> > +					    &pioA 30 0
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> >   		};
> >
> >   		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
> b/arch/arm/boot/dts/at91sam9x5.dtsi
> > index 03fc136..95b55fd 100644
> > --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> > @@ -263,6 +263,36 @@
> >   					trigger-value = <0x6>;
> >   				};
> >   			};
> > +
> > +			spi0: spi@f0000000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0000000 0x100>;
> > +				interrupts = <13 4 3>;
> > +				cs-gpios = <&pioA 14 0
> > +					    &pioA 7 0 /* conflicts with TXD2 */
> > +					    &pioA 1 0 /* conflicts with RXD0 */
> > +					    &pioB 3 0 /* conflicts with ERXDV */
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@f0004000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0004000 0x100>;
> > +				interrupts = <14 4 3>;
> > +				cs-gpios = <&pioA 8 0 /* conflitcs with RXD2 */
> > +					    &pioA 0 0 /* conflitcs with TXD0 */
> > +					    &pioA 31 0 /* conflitcs with TWCK0 */
> > +					    &pioA 30 0 /* conflitcs with TWD0 */
> > +					   >;
> > +				dma-mask = <0xffffffff>;
> > +				status = "disabled";
> > +			};
> >   		};
> >
> >   		nand0: nand@40000000 {
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
