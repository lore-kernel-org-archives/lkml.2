Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2JWPJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:09:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53228 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab2JWPJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:09:24 -0400
Message-ID: <5086B316.6000001@ti.com>
Date: Tue, 23 Oct 2012 17:09:10 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap5: Update GPIO with address space
 and interrupts
References: <1350981432-6750-1-git-send-email-s-guiriec@ti.com> <1350981432-6750-2-git-send-email-s-guiriec@ti.com> <5086AE8E.60106@ti.com>
In-Reply-To: <5086AE8E.60106@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 04:49 PM, Jon Hunter wrote:
> Hi Seb,
> 
> On 10/23/2012 03:37 AM, Sebastien Guiriec wrote:
>> Add base address and interrupt line inside Device Tree data for
>> OMAP5
>>
>> Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
>> ---
>>  arch/arm/boot/dts/omap5.dtsi |   16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
>> index 42c78be..9e39f9f 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -104,6 +104,8 @@
>>  
>>  		gpio1: gpio@4ae10000 {
>>  			compatible = "ti,omap4-gpio";
>> +			reg = <0x4ae10000 0x200>;
>> +			interrupts = <0 29 0x4>;
>>  			ti,hwmods = "gpio1";
>>  			gpio-controller;
>>  			#gpio-cells = <2>;
> 
> I am wondering if we should add the "interrupt-parent" property to add
> nodes in the device-tree source. I know that today the interrupt-parent
> is being defined globally, but when device-tree maps an interrupt for a
> device it searches for the interrupt-parent starting the current device
> node.
> 
> So in other words, for gpio1 it will search the gpio1 binding for
> "interrupt-parent" and if not found move up a level and search again. It
> will keep doing this until it finds the "interrupt-parent".
> 
> Therefore, I believe it will improve search time and hence, boot time if
> we have interrupt-parent defined in each node.

Mmm, I'm not that sure. it will increase the size of the blob, so
increase the time to load it and then to parse it. Where in the current
case, it is just going up to the parent node using the already
un-flatten tree in memory and thus that should not take that much time.

That being said, it might be interesting to benchmark that to see what
is the real impact.

Regards,
Benoit

