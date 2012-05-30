Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2E3C1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:27:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50176 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2E3C1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:27:42 -0400
Message-ID: <4FC591C9.2050004@gmail.com>
Date: Wed, 30 May 2012 11:19:37 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: linux@arm.linux.org.uk, b-cousson@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rnayak@ti.com, tony@atomide.com,
        wim@iguana.be, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/3] arm/dts: add wdt node for omap3 and omap4
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-2-git-send-email-jgq516@gmail.com> <4FC50CCD.7090404@ti.com>
In-Reply-To: <4FC50CCD.7090404@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Hunter wrote:
> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>   
>> From: Xiao Jiang <jgq516@gmail.com>
>>
>> Add wdt node to support dt.
>>
>> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
>> ---
>>  arch/arm/boot/dts/omap3.dtsi |    5 +++++
>>  arch/arm/boot/dts/omap4.dtsi |    5 +++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>> index 99474fa..039df5c 100644
>> --- a/arch/arm/boot/dts/omap3.dtsi
>> +++ b/arch/arm/boot/dts/omap3.dtsi
>> @@ -215,5 +215,10 @@
>>  			compatible = "ti,omap3-hsmmc";
>>  			ti,hwmods = "mmc3";
>>  		};
>> +
>> +		wdt: wdt@48314000{
>>     
>
> Minor comment, may be call this wdt2 as this is watchdog timer 2. Also
> ass a space between the address and the "{".
>
>   
Ok, will change it to "wdt2: wdt@48314000 {".
>> +			compatible = "ti,omap3-wdt";
>> +			ti,hwmods = "wd_timer2";
>> +		};
>>  	};
>>  };
>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>> index 359c497..d01403d 100644
>> --- a/arch/arm/boot/dts/omap4.dtsi
>> +++ b/arch/arm/boot/dts/omap4.dtsi
>> @@ -272,5 +272,10 @@
>>  			ti,hwmods = "mmc5";
>>  			ti,needs-special-reset;
>>  		};
>> +
>> +		wdt: wdt@4a314000{
>>     
>
> Same as above.
>
>   
Ditto.
>> +			compatible = "ti,omap4-wdt";
>> +			ti,hwmods = "wd_timer2";
>> +		};
>>  	};
>>  };
>>     
>
> Also we should add some documentation to describe the binding. Here it
> is very simple, but nonetheless we should have something as we have for
> gpio [1].
>
>   
Thanks for reminding, how about below patch?

diff --git a/Documentation/devicetree/bindings/watchdog/omap-wdt.txt 
b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
new file mode 100644
index 0000000..4272d06
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/omap-wdt.txt
@@ -0,0 +1,15 @@
+TI Watchdog Timer (WDT) Controller for OMAP
+
+Required properties:
+- compatible:
+  - "ti,omap2-wdt" for OMAP2
+  - "ti,omap3-wdt" for OMAP3
+  - "ti,omap4-wdt" for OMAP4
+- ti,hwmods: Name of the hwmod associated to the WDT
+
+Examples:
+
+wdt2: wdt@73f98000 {
+       compatible = "ti,omap4-wdt";
+       ti,hwmods = "wd_timer2";
+};

Regards,
Xiao
> Cheers
> Jon
>
> [1]
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/devicetree/bindings/gpio/gpio-omap.txt;h=bff51a2fee1eae7d387b40ea913e04782554bf68;hb=HEAD
>   

