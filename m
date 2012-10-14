Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2JNLN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:13:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2JNLN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:13:58 -0400
Message-ID: <507A9E72.2030800@gmail.com>
Date: Sun, 14 Oct 2012 13:13:54 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <5076847A.3010705@gmail.com> <5076ED22.3060803@gmail.com> <50785EBF.3060508@gmail.com> <507A9AF6.4030008@gmail.com>
In-Reply-To: <507A9AF6.4030008@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14.10.2012 12:59, Sebastian Hesselbarth wrote:
> Adding LAKML and devtree as there might be people willing to comment about
> DT representation of i2c-attached clock generators, too.
> 
> On 10/12/2012 08:17 PM, Daniel Mack wrote:
>> On 11.10.2012 18:00, Sebastian Hesselbarth wrote:
>  >> [...]
>>> Does any of you work rely on a working si5351 driver?
>>
>> Yes, it does actually. I can hack around it for now, but at some point,
>> a proper driver is needed. And yours looks quite feature complete, so it
>> would be easiest to finish this one :)
> 
> Well, yes it is some kind of feature complete except regmap and DT. Adding
> regmap to the driver should be quite easy but with DT I am still thinking
> of the best way to represent the internal connections between OSC, PLLs, and
> CLKOUTs. In the last version of the driver I had a callback that was
> board specific to setup these connections but with DT there will be no board
> specific code anymore.
> 
> Maybe one of the common clk maintainers can give a hint how this could be
> done in a clean way. The question is how to represent a i2c-attached clock
> generator config in DT where you want to setup clock parents of CLKOUTs and
> PLLs.
> 
> A possible solution would be something like this:
> 
> si5351a@60 {
> 	compatible = "silabs,si5351a";
> 	reg = <0x60>;
> 
> 	si_osc: osc {
> 		compatible = "fixed-clock";
> 		clock-frequency = <270000000>;
> 	};
> 
> 	si_plla: pll@0 {
> 		compatible = "silabs,si5351-pll";
> 		/* hook-up plla to osc input */
> 		clocks = <&si_osc>;
> 	};
> 
> 	si_clkout0: clkout@0 {
> 		compatible = "silabs,si5351-clkout";
> 		/* hook-up clkout0 to plla */
> 		clocks = <&si_plla>;
> 		/* request target frequency */
> 		clock-frequency = <148500000>;
> 	};	
> };
> 
> Although this perfectly describes the clock hierarchy I still don't like
> the sub-node style. Another flat solution would be something like:

I think the sub-node style above it nicer because it allows referencing
the individual clocks outputs with a phandle. We use this chip to
generate base-frequencies for audio clocks, and so we have to switch
between two freqs for the multiples of 22.5KHz and 24KHz at runtime.

>> Do you still have access to hardware you wrote the driver for? Let me
>> know if you need any help around here.
> 
> Yes, hardware is still available although I only have access to the Si5351a
> with 3 clkouts. The code should be compatible for Si5351a with 8 clkouts and
> code skeleton for 5351b (OSC and VXCO input) and 5351c (OSC and CLKIN) is
> there but untested.

The 3 clkout model is the only one I have access to as well.

> I've transferred the current driver version to my repository to work on. As soon
> as I have regmap done, I will push it online and give you a note.

That's great. Let me know if you want me to test anything.


Thanks,
Daniel


