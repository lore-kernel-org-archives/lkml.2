Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2E3Onu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:43:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50817 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2E3OnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:43:02 -0400
Message-ID: <4FC631E5.9080000@ti.com>
Date: Wed, 30 May 2012 09:42:45 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Jiang <jgq516@gmail.com>
CC: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rnayak@ti.com>, <tony@atomide.com>,
        <wim@iguana.be>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm/dts: add wdt node for omap3 and omap4
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-2-git-send-email-jgq516@gmail.com> <4FC50CCD.7090404@ti.com> <4FC591C9.2050004@gmail.com>
In-Reply-To: <4FC591C9.2050004@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/29/2012 10:19 PM, Xiao Jiang wrote:
> Jon Hunter wrote:
>> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>>  
>>> From: Xiao Jiang <jgq516@gmail.com>
>>>
>>> Add wdt node to support dt.
>>>
>>> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
>>> ---
>>>  arch/arm/boot/dts/omap3.dtsi |    5 +++++
>>>  arch/arm/boot/dts/omap4.dtsi |    5 +++++
>>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>>> index 99474fa..039df5c 100644
>>> --- a/arch/arm/boot/dts/omap3.dtsi
>>> +++ b/arch/arm/boot/dts/omap3.dtsi
>>> @@ -215,5 +215,10 @@
>>>              compatible = "ti,omap3-hsmmc";
>>>              ti,hwmods = "mmc3";
>>>          };
>>> +
>>> +        wdt: wdt@48314000{
>>>     
>>
>> Minor comment, may be call this wdt2 as this is watchdog timer 2. Also
>> ass a space between the address and the "{".
>>
>>   
> Ok, will change it to "wdt2: wdt@48314000 {".
>>> +            compatible = "ti,omap3-wdt";
>>> +            ti,hwmods = "wd_timer2";
>>> +        };
>>>      };
>>>  };
>>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>>> index 359c497..d01403d 100644
>>> --- a/arch/arm/boot/dts/omap4.dtsi
>>> +++ b/arch/arm/boot/dts/omap4.dtsi
>>> @@ -272,5 +272,10 @@
>>>              ti,hwmods = "mmc5";
>>>              ti,needs-special-reset;
>>>          };
>>> +
>>> +        wdt: wdt@4a314000{
>>>     
>>
>> Same as above.
>>
>>   
> Ditto.
>>> +            compatible = "ti,omap4-wdt";
>>> +            ti,hwmods = "wd_timer2";
>>> +        };
>>>      };
>>>  };
>>>     
>>
>> Also we should add some documentation to describe the binding. Here it
>> is very simple, but nonetheless we should have something as we have for
>> gpio [1].
>>
>>   
> Thanks for reminding, how about below patch?
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
> b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
> new file mode 100644
> index 0000000..4272d06
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
> @@ -0,0 +1,15 @@
> +TI Watchdog Timer (WDT) Controller for OMAP
> +
> +Required properties:
> +- compatible:
> +  - "ti,omap2-wdt" for OMAP2
> +  - "ti,omap3-wdt" for OMAP3
> +  - "ti,omap4-wdt" for OMAP4
> +- ti,hwmods: Name of the hwmod associated to the WDT
> +
> +Examples:
> +
> +wdt2: wdt@73f98000 {
> +       compatible = "ti,omap4-wdt";
> +       ti,hwmods = "wd_timer2";
> +};

Yes looks good. Thanks! Minor nit-pick in the example I would just copy
the omap4 node completely with the actual omap4 address :-)

Cheers
Jon
