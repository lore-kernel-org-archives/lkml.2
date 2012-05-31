Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab2EaVAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:00:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2EaVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:00:17 -0400
Message-ID: <4FC7DBC9.7090406@ti.com>
Date: Thu, 31 May 2012 22:59:53 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Xiao Jiang <jgq516@gmail.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <rnayak@ti.com>, <tony@atomide.com>, <wim@iguana.be>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm/dts: add wdt node for omap3 and omap4
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-2-git-send-email-jgq516@gmail.com> <4FC50CCD.7090404@ti.com> <4FC591C9.2050004@gmail.com> <4FC631E5.9080000@ti.com> <4FC706D7.2010801@gmail.com> <4FC78672.6040805@ti.com>
In-Reply-To: <4FC78672.6040805@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2012 4:55 PM, Jon Hunter wrote:
> On 05/31/2012 12:51 AM, Xiao Jiang wrote:
>> Hi Jon and Benoit,
>>>> Thanks for reminding, how about below patch?
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
>>>> b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
>>>> new file mode 100644
>>>> index 0000000..4272d06
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
>>>> @@ -0,0 +1,15 @@
>>>> +TI Watchdog Timer (WDT) Controller for OMAP
>>>> +
>>>> +Required properties:
>>>> +- compatible:
>>>> +  - "ti,omap2-wdt" for OMAP2
>>>> +  - "ti,omap3-wdt" for OMAP3
>>>> +  - "ti,omap4-wdt" for OMAP4
>>>> +- ti,hwmods: Name of the hwmod associated to the WDT
>>>> +
>>>> +Examples:
>>>> +
>>>> +wdt2: wdt@73f98000 {
>>>> +       compatible = "ti,omap4-wdt";
>>>> +       ti,hwmods = "wd_timer2";
>>>> +};
>>>>
>>>
>>> Yes looks good. Thanks! Minor nit-pick in the example I would just copy
>>> the omap4 node completely with the actual omap4 address :-)
>>>
>>>
>> Oops, wrong addr, :). Perhaps we can drop address as you said, since the
>> right addresses are defined
>> in wd_timer2 hwmod (see [1]), and wdt also works without the address as
>> follows.
>>
>> diff --git a/arch/arm/boot/dts/omap2.dtsi b/arch/arm/boot/dts/omap2.dtsi
>> index f2ab4ea..0017bd8 100644
>> --- a/arch/arm/boot/dts/omap2.dtsi
>> +++ b/arch/arm/boot/dts/omap2.dtsi
>> @@ -63,5 +63,10 @@
>>                         ti,hwmods = "uart3";
>>                         clock-frequency =<48000000>;
>>                 };
>> +
>> +               wdt2: wdt {
>> +                       compatible = "ti,omap2-wdt";
>> +                       ti,hwmods = "wd_timer2";
>> +               };
>>         };
>> };
>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>> index 99474fa..dbf8a5b 100644
>> --- a/arch/arm/boot/dts/omap3.dtsi
>> +++ b/arch/arm/boot/dts/omap3.dtsi
>> @@ -215,5 +215,10 @@
>>                         compatible = "ti,omap3-hsmmc";
>>                         ti,hwmods = "mmc3";
>>                 };
>> +
>> +               wdt2: wdt {
>> +                       compatible = "ti,omap3-wdt", "ti,omap2-wdt";
>> +                       ti,hwmods = "wd_timer2";
>> +               };
>>         };
>> };
>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>> index 359c497..ce74e87 100644
>> --- a/arch/arm/boot/dts/omap4.dtsi
>> +++ b/arch/arm/boot/dts/omap4.dtsi
>> @@ -272,5 +272,10 @@
>>                         ti,hwmods = "mmc5";
>>                         ti,needs-special-reset;
>>                 };
>> +
>> +               wdt2: wdt {
>> +                       compatible = "ti,omap4-wdt", "ti,omap2-wdt";
>> +                       ti,hwmods = "wd_timer2";
>> +               };
>>         };
>> };
>>
>> Infos for omap3:
>> # dmesg|grep Machine
>> <6>[    0.000000] Machine: Generic OMAP3 (Flattened Device Tree), model:
>> TI OMAP3 EVM (OMAP3530, AM/DM37x)
>> # dmesg|grep omap_wdt_probe
>> <4>[    2.552825] in omap_wdt_probe: 299, res->start = 0x48314000
>>
>> Infos for omap4:
>> root@localhost:/root>  dmesg|grep Machine
>> [    0.000000] Machine: Generic OMAP4 (Flattened Device Tree), model: TI
>> OMAP4 SDP board
>> root@localhost:/root>  dmesg|grep omap_wdt_probe
>> [    1.687896] in omap_wdt_probe: 299, res->start = 0x4a314000
>>
>> So can I drop the wdt addr from dts file? otherwise it is not feasible
>> to add omap2 wdt node in omap2.dtsi
>> due to different addrs for omap2420 and omap2430.
>
> Benoit, what is your preference here?

Get rid of both omap2420 and 2430 :-)

The point is that only OMAP3 and OMAP4 are supposed to be migrated to DT 
for the moment.

If you do not have any OMAP2 board to test that, it is anyway safer to 
not touch the omap2.dtsi file.

If the 2 or 3 remaining users of OMAP2 boards want to have DT support, 
they'll be able to add that themselves.

Regards,
Benoit

