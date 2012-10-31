Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371Ab2JaKgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:36:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50536 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2JaKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:35:56 -0400
Message-ID: <5090FEE1.5070206@ti.com>
Date: Wed, 31 Oct 2012 11:35:13 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 16/16] ARM: dts: add AM33XX SPI support
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-17-git-send-email-mporter@ti.com> <518397C60809E147AF5323E0420B992E3E9D597B@DBDE01.ent.ti.com> <5090FA92.1080400@ti.com>
In-Reply-To: <5090FA92.1080400@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/31/2012 11:16 AM, Benoit Cousson wrote:
> Hi Avinash,
> 
> On 10/30/2012 10:41 AM, Philip, Avinash wrote:
>> On Mon, Oct 29, 2012 at 14:40:02, Philip, Avinash wrote:
>>> On Thu, Oct 18, 2012 at 18:56:55, Porter, Matt wrote:
>>>> Adds AM33XX SPI support for am335x-bone and am335x-evm.
>>
>> Matt,
>>
>> Can you build SPI DT patch with DMA support on top of SPI DT patch
>> I submitted [1]. With the patch [1] SPI can work on PIO mode.
>> So we can have basic SPI support available in 3.8.
>>
>> Benoit,
>> Can you accept the SPI DT patch [1]
> 
> Yes, I've just applied it in for_3.8/dts branch

Well, in fact I did not, it does not apply :-(

Can you rebase on top of the for_3.8/dts branch? I've just applied the
RTC patch on top that was OK.

Thanks,
Benoit

> 
>> In case if you want I will resubmit a patch with subject line modified.
> 
> No, that's fine.
> 
> Thanks,
> Benoit
> 
>>
>> Current subject line
>> arm/dts: AM33XX: Add SPI device tree data
>>
>> 1. https://patchwork.kernel.org/patch/1470661/
>>
>> Thanks
>> Avinash
>>
>>>>
>>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>>> ---
>>>>  arch/arm/boot/dts/am335x-bone.dts |   17 +++++++++++++++
>>>>  arch/arm/boot/dts/am335x-evm.dts  |    9 ++++++++
>>>>  arch/arm/boot/dts/am33xx.dtsi     |   43 +++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 69 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
>>>> index 5510979..23edfd8 100644
>>>> --- a/arch/arm/boot/dts/am335x-bone.dts
>>>> +++ b/arch/arm/boot/dts/am335x-bone.dts
>>>> @@ -18,6 +18,17 @@
>>>>  		reg = <0x80000000 0x10000000>; /* 256 MB */
>>>>  	};
>>>>  
>>>> +	am3358_pinmux: pinmux@44e10800 {
>>>> +		spi1_pins: pinmux_spi1_pins {
>>>> +			pinctrl-single,pins = <
>>>> +				0x190 0x13	/* mcasp0_aclkx.spi1_sclk, OUTPUT_PULLUP | MODE3 */
>>>> +				0x194 0x33	/* mcasp0_fsx.spi1_d0, INPUT_PULLUP | MODE3 */
>>>> +				0x198 0x13	/* mcasp0_axr0.spi1_d1, OUTPUT_PULLUP | MODE3 */
>>>> +				0x19c 0x13	/* mcasp0_ahclkr.spi1_cs0, OUTPUT_PULLUP | MODE3 */
>>>> +			>;
>>>> +		};
>>>> +	};
>>>> +
>>>
>>> Change to am33xx_pinmux.
>>>
>>>>  	ocp {
>>>>  		uart1: serial@44e09000 {
>>>>  			status = "okay";
>>>> @@ -84,3 +95,9 @@
>>>>  &mmc1 {
>>>>  	vmmc-supply = <&ldo3_reg>;
>>>>  };
>>>> +
>>>> +&spi1 {
>>>> +	status = "okay";
>>>> +	pinctrl-names = "default";
>>>> +	pinctrl-0 = <&spi1_pins>;
>>>> +};
>>>> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
>>>> index d63fce8..8d5f660 100644
>>>> --- a/arch/arm/boot/dts/am335x-evm.dts
>>>> +++ b/arch/arm/boot/dts/am335x-evm.dts
>>>> @@ -124,3 +124,12 @@
>>>>  &mmc1 {
>>>>  	vmmc-supply = <&vmmc_reg>;
>>>>  };
>>>> +
>>>> +&spi0 {
>>>> +	status = "okay";
>>>> +	spi-flash@0 {
>>>> +		compatible = "spansion,s25fl064k", "m25p80";
>>>> +		spi-max-frequency = <24000000>;
>>>> +		reg = <0>;
>>>> +	};
>>>> +};
>>>
>>> In AM335x-evm, SPI flash available in profile #2 (am335x evm specific profiles).
>>> So can you drop this changes as if I understood correctly, am335x-evm.dts will be
>>> populated for devices present only on profile #0.
>>>
>>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>>>> index 26a6af7..063ecea 100644
>>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>>> @@ -40,6 +40,15 @@
>>>>  		};
>>>>  	};
>>>>  
>>>> +	am3358_pinmux: pinmux@44e10800 {
>>>> +		compatible = "pinctrl-single";
>>>> +		reg = <0x44e10800 0x0238>;
>>>> +		#address-cells = <1>;
>>>> +		#size-cells = <0>;
>>>> +		pinctrl-single,register-width = <32>;
>>>> +		pinctrl-single,function-mask = <0x7f>;
>>>> +	};
>>>> +
>>>
>>> Pin ctrl support already submitted
>>> http://git.kernel.org/?p=linux/kernel/git/bcousson/linux-omap-dt.git;a=commitdiff;h=3e0603e905d9ba662e8c1885ecb1d28bc454e448
>>>
>>> Thanks
>>> Avinash
>>>
>>>>  	/*
>>>>  	 * XXX: Use a flat representation of the AM33XX interconnect.
>>>>  	 * The real AM33XX interconnect network is quite complex.Since
>>>> @@ -261,6 +270,40 @@
>>>>  			status = "disabled";
>>>>  		};
>>>>  
>>>> +		spi0: spi@48030000 {
>>>> +			compatible = "ti,omap4-mcspi";
>>>> +			ti,hwmods = "spi0";
>>>> +			#address-cells = <1>;
>>>> +			#size-cells = <0>;
>>>> +			reg = <0x48030000 0x400>;
>>>> +			interrupt-parent = <&intc>;
>>>> +			interrupt = <65>;
>>>> +			dmas = <&edma 16
>>>> +				&edma 17
>>>> +				&edma 18
>>>> +				&edma 19>;
>>>> +			dma-names = "tx0", "rx0", "tx1", "rx1";
>>>> +			ti,spi-num-cs = <2>;
>>>> +			status = "disabled";
>>>> +		};
>>>> +
>>>> +		spi1: spi@481a0000 {
>>>> +			compatible = "ti,omap4-mcspi";
>>>> +			ti,hwmods = "spi1";
>>>> +			#address-cells = <1>;
>>>> +			#size-cells = <0>;
>>>> +			reg = <0x481a0000 0x400>;
>>>> +			interrupt-parent = <&intc>;
>>>> +			interrupt = <125>;
>>>> +			dmas = <&edma 42
>>>> +				&edma 43
>>>> +				&edma 44
>>>> +				&edma 45>;
>>>> +			dma-names = "tx0", "rx0", "tx1", "rx1";
>>>> +			ti,spi-num-cs = <2>;
>>>> +			status = "disabled";
>>>> +		};
>>>> +
>>>>  		wdt2: wdt@44e35000 {
>>>>  			compatible = "ti,omap3-wdt";
>>>>  			ti,hwmods = "wd_timer2";
>>>> -- 
>>>> 1.7.9.5
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-arm-kernel mailing list
>>>> linux-arm-kernel@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>>
>>>
>>>
>>
> 

