Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3AJHiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:38:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49868 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3AJHiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:38:04 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, "hs@denx.de" <hs@denx.de>
Subject: RE: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
Thread-Topic: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
Thread-Index: AQHN7XjyHRW1+KNxCk+Xv+44IjJmqJhAl+YAgAGAZIA=
Date: Thu, 10 Jan 2013 07:37:40 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412B80CA@DBDE01.ent.ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
 <1357633220-29827-4-git-send-email-anilkumar.v@ti.com>
 <50ED66F2.8050006@ti.com>
In-Reply-To: <50ED66F2.8050006@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0A7c7hk013041

On Wed, Jan 09, 2013 at 18:17:46, Nori, Sekhar wrote:
> On 1/8/2013 1:50 PM, Kumar, Anil wrote:
> > Add NAND driver entries to export NAND functionality on da850 EVM and
> > NAND pinctrl node to do pin mux according to pinctrl-single driver.
> 
> Subject line should have DT and da850 evm somewhere.
> Otherwise NAND has been supported on DA850 for long.

I will update it in V3 of this patch series.

> 
> > 
> > Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> > ---
> > :100644 100644 c7609d0... 382a7da... M	arch/arm/boot/dts/da850-evm.dts
> > :100644 100644 e9c6e82... 16e2ac2... M	arch/arm/boot/dts/da850.dtsi
> >  arch/arm/boot/dts/da850-evm.dts |   19 +++++++++++++++++++
> >  arch/arm/boot/dts/da850.dtsi    |   13 +++++++++++++
> >  2 files changed, 32 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> > index c7609d0..382a7da 100644
> > --- a/arch/arm/boot/dts/da850-evm.dts
> > +++ b/arch/arm/boot/dts/da850-evm.dts
> > @@ -28,4 +28,23 @@
> >  			status = "okay";
> >  		};
> >  	};
> > +	nand_cs3@62000000 {
> > +		status = "okay";
> > +	};
> > +};
> > +&pmx_core{
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <
> > +		&nand_cs3_pins
> > +	>;
> 
> This means that the NAND pins are configured even if NAND is not
> probed. Right?

Right 

> This can be moved into the nand_cs3 node to avoid that. 
> And then when used with Linus Walleij's patch "drivers/pinctrl: grab 
> default handles from device core" which should be accepted soon, the 
> pins will be automatically setup when the NAND gets probed.

It is better. I will do it in V3 of this patch series.

> 
> > +
> > +	nand_cs3_pins: pinmux_nand_pins {
> > +		pinctrl-single,bits = <
> > +			0x1c 0x00110000  0x00ff0000     /* EMA_OE, EMA_WE */
> > +			0x1c 0x00000110  0x00000ff0     /* EMA_CS[4],EMA_CS[3]*/
> > +			0x24 0x11111111  0xffffffff     /* EMA_D[0], EMA_D[1], EMA_D[2], EMA_D[3],
> > +							   EMA_D[4], EMA_D[5], EMA_D[6], EMA_D[7] */
> > +			0x30 0x01100000  0x0ff00000     /* EMA_A[1], EMA_A[2] */
> > +		>;
> > +	};
> 
> I suspect a number of other boards using NAND on CS3 would have to 
> repeat these configurations. It will be better to move them into the 
> da850.dtsi file so it can be reused.

> 
> Since I am new to the DT and pinctrl stuff, I had to actually try these to 
> make sure what I am suggesting isn't nonsense. I came up with this 
> patch on top of your series. Please test it at your end

Tested. It is working. 

> and also see if you 
> are happy with the changes.

I do not think that it is good idea to move NAND pin mux information
into da850.dtsi because this information is evm specific.
if we will use this approach then we must use the same approach for
other modules also as ASoC etc.   

Thanks,
Anil

> ---8<----
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 382a7da..52abb9d 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -30,21 +30,8 @@
>  	};
>  	nand_cs3@62000000 {
>  		status = "okay";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&nand_cs3_pins>;
>  	};
>  };
> -&pmx_core{
> -	pinctrl-names = "default";
> -	pinctrl-0 = <
> -		&nand_cs3_pins
> -	>;
>  
> -	nand_cs3_pins: pinmux_nand_pins {
> -		pinctrl-single,bits = <
> -			0x1c 0x00110000  0x00ff0000     /* EMA_OE, EMA_WE */
> -			0x1c 0x00000110  0x00000ff0     /* EMA_CS[4],EMA_CS[3]*/
> -			0x24 0x11111111  0xffffffff     /* EMA_D[0], EMA_D[1], EMA_D[2], EMA_D[3],
> -							   EMA_D[4], EMA_D[5], EMA_D[6], EMA_D[7] */
> -			0x30 0x01100000  0x0ff00000     /* EMA_A[1], EMA_A[2] */
> -		>;
> -	};
> -};
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 6ab9730..c4b21a8 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -38,7 +38,25 @@
>  			pinctrl-single,register-width = <32>;
>  			pinctrl-single,function-mask = <0xffffffff>;
>  			status = "disabled";
> +
> +			nand_cs3_pins: pinmux_nand_pins {
> +				pinctrl-single,bits = <
> +					/* EMA_OE, EMA_WE */
> +					0x1c 0x00110000  0x00ff0000
> +					/* EMA_CS[4],EMA_CS[3]*/
> +					0x1c 0x00000110  0x00000ff0
> +					/*
> +					 * EMA_D[0], EMA_D[1], EMA_D[2],
> +					 * EMA_D[3], EMA_D[4], EMA_D[5],
> +					 * EMA_D[6], EMA_D[7]
> +					 */
> +					0x24 0x11111111  0xffffffff
> +					/* EMA_A[1], EMA_A[2] */
> +					0x30 0x01100000  0x0ff00000
> +				>;
> +			};
>  		};
> +
>  		serial0: serial@1c42000 {
>  			compatible = "ns16550a";
>  			reg = <0x42000 0x100>;
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
