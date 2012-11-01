Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417Ab2KAL0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:26:18 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:44264 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab2KAL0Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:26:16 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121101110418.GF410@arwen.pp.htv.fi>
Date: Thu, 1 Nov 2012 13:26:10 +0200
Cc: "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
References: <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <20121101110418.GF410@arwen.pp.htv.fi>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

On Nov 1, 2012, at 1:04 PM, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Nov 01, 2012 at 12:39:30PM +0200, Pantelis Antoniou wrote:
>>>>>                lcd@0 {
>>>>>                        compatible = "adafruit,tft-lcd-1.8-red", "sitronix,st7735";
>>>>>                        spi-max-frequency = <8000000>;
>>>>>                        reg = <0>;
>>>>>                        spi-cpol;
>>>>>                        spi-cpha;
>>>>>                        pinctrl-names = "default";
>>>>>                        pinctrl-0 = <&lcd_pins>;
>>>>>                        st7735-rst = <&gpio4 19 0>;
>>>>>                        st7735-dc = <&gpio4 21 0>;
>>>>>                };
>>>>> 
>>>>>        };
>>>>> };
>>>>> 
>>> 
>>> I guess there is no easy solution for that, but it looks to me that
>>> what you have to do is to make the DT creation dynamic in your case.
>>> Assuming you do not want to do that in the bootloader, you must do
>>> that pretty early during the boot process to end up with a full
>>> description of your DT tree before creating the devices.
>>> 
>> 
>> Do it pretty early in the boot processes ended up with the am335xevm board file in the PSP tree.
>> 
>> The whole set of possible cape designs cannot be controlled, nor do we want to.
>> We want to empower users to come up with their own designs without having to do any kernel/boot loader
>> hacking.
> 
> that's impossible since you will have to provide the capebus driver
> anyway.
> 

The generic cape bus driver can handle the easy stuff. More complex
stuff can be supported with per-cape drivers.

>>> Each cape will have their own DTS and based on some board id you
>>> will fix the DT dynamically.
>>> 
>>> My point is that the issue you are facing is a real limitation of
>>> DT, so you should fix the DT core and not workaround it by creating
>>> artificial bindings / drivers.
>>> 
>> 
>> You still haven't described any mechanism to deal with all the use
>> cases I described.
>> 
>> DT can't and will not deal with the complexity that we're facing right
>> now.
> 
> and DT-itself shouldn't. I agree with Benoit that this should be built
> at bootloader level, perhaps. Whatever you're doing in capebus, you
> could do at kernel space, build your DT bindings in runtime, and pass
> that DT blob to kernel.

We're just passing the buck someplace else. We're not fixing the problem.
What makes you think that dealing with this in the bootloader is going
to be simpler?

> 
> One question though, what do you mean by "some capes are full blown
> devices with their own drivers" ? Do you mean you have capes running
> some other (RT)OS and communicating with linux somehow ? How does it
> communicate to the bone ?

Some have FPGAs.
https://specialcomp.com/beaglebone/BeagleBone_FPGA.html

Some capes have their own MCUs. 
A recent one has an 6502 communicating with uio_pruss.
https://github.com/ohporter/b6502

What I'm saying is that there are simple capes, that are just DT devices
which can be handled via cape-generic. The complex ones need their own
drivers which need a place to live.

Capebus handles both.

> 
> cheers
> 
> -- 
> balbi

Regards

-- Pantelis

