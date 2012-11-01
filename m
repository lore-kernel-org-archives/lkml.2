Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275Ab2KANgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:36:06 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:49244 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756931Ab2KANgC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:36:02 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121101131609.GC12489@arwen.pp.htv.fi>
Date: Thu, 1 Nov 2012 15:35:55 +0200
Cc: "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
References: <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Nov 1, 2012, at 3:16 PM, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Nov 01, 2012 at 02:57:26PM +0200, Pantelis Antoniou wrote:
>>>>>>> Each cape will have their own DTS and based on some board id you
>>>>>>> will fix the DT dynamically.
>>>>>>> 
>>>>>>> My point is that the issue you are facing is a real limitation of
>>>>>>> DT, so you should fix the DT core and not workaround it by creating
>>>>>>> artificial bindings / drivers.
>>>>>>> 
>>>>>> 
>>>>>> You still haven't described any mechanism to deal with all the use
>>>>>> cases I described.
>>>>>> 
>>>>>> DT can't and will not deal with the complexity that we're facing right
>>>>>> now.
>>>>> 
>>>>> and DT-itself shouldn't. I agree with Benoit that this should be built
>>>>> at bootloader level, perhaps. Whatever you're doing in capebus, you
>>>>> could do at kernel space, build your DT bindings in runtime, and pass
>>>>> that DT blob to kernel.
>>>> 
>>>> We're just passing the buck someplace else. We're not fixing the problem.
>>>> What makes you think that dealing with this in the bootloader is going
>>>> to be simpler?
>>> 
>>> I never said it was supposed to be simpler, it just doesn't sound like
>>> something the kernel should care about. Kernel cares about the
>> 
>> I just disagree here. The kernel should provide services that make the life
>> of users easier, not the lives of the kernel developers easier.
> 
> and it's already doing that isn't it ? we have i2c framework for i2c
> clients. From a userland point of view, you have input layer, iio,
> hwmon, chardev and a whole bunch of other interfaces which standardize
> device accesses.
> 
> Look at your sentence again: "kernel should make life of users easier,
> not that of kernel developers"; IMHO capebus is just making it easier
> for the kernel developers who have to maintain a bunch of drivers for
> different devices on different capes ;-)
> 
> At the end of the day, capebus will just be creating devices which will
> be handled by the same I2C framework, iio, input, hwmon, and so on. So
> what was the great benefit from capebus other than decreasing the
> amount of changes to .dts files ?
> 

How about true plug and play, conflict resolution & real easy development of
new cape designs.

I fail to see how your convoluted method(s) fixes any of the above. And no
passing the buck to someone else (be it u-boot, u-dev, user-space) won't cut
it.

What you are proposing will just stop dead all cape development besides the
ones that dedicated teams at TI do. In fact the whole project, of a cheap
Linux based, hackable community board will fail.


>>>>> One question though, what do you mean by "some capes are full blown
>>>>> devices with their own drivers" ? Do you mean you have capes running
>>>>> some other (RT)OS and communicating with linux somehow ? How does it
>>>>> communicate to the bone ?
>>>> 
>>>> Some have FPGAs.
>>>> https://specialcomp.com/beaglebone/BeagleBone_FPGA.html
>>> 
>>> how does linux communicate with those ? What they are matters very
>>> little ;-) All we need is an interface to load binaries to the FPGA.
>>> 
>> 
>> We can not know what people will come up with. It might have a few GPIOs
>> to load the bitfile to the FPGA, but after that, no-one can tell.
>> I might not interface to Linux at all; it might interface via I2C, or RS232.
> 
> which means that whoever writes RTL for the FPGA needs to do so with
> bone's I/O choices in mind.
> 
> Let's assume the use UART to send bitfile to FPGA and bitfile is a model
> of an I2C Sensor, they'll have to use /dev/ttyOn to pass bitfile to FPGA
> and later an i2c-client driver (possibly using iio, since it's a sensor)
> will be loaded. Right ?
> 

No. I don't know details about what the actual cape design is, but they
certainly don't want to deal with the piece-meal method, of loading one
driver, and then creating a bunch of I2C devices, and then activating an
RS232 tty, and then using that to burn the bitfile and so on.

What they want, and what every user wants, is I plug this board in, and
the driver make sure everything is loaded and ready. No, the end users
don't want to see any of the implementation details of how the bitfile
is transported; the driver can handle it.

>> Chances are, it won't fit in any kind of known drivers of linux. 
>> Some guy is using an FPGA for SDR, another is making a radar cape.
> 
> awesome. That means we need to take care of those :-) Even with capebus,
> they will still have to write those drivers won't they ? So instead of
> writing some capebus driver, why can't the guy write a driver for his
> radar instead ? That way, if he ever turns that into an ASIC and decides
> to sell it as a chip, he doesn't have to write another driver just to
> strip the capebus away.

You have to build something working first, before you move on to make a custom
board based to it. FWIW, after a design gets to work as a cape, chances
are the hardware redesign will just end up with the same h/w connections
as a cape, and just use an override to avoid putting the EEPROM in there.

> 
>> These guys don't give a damn frankly about Linux. What they do care
>> about is having a cheap/easy to develop platform for their own little
>> widget.  If you are going to ask from the to hunt down their own dts
>> and assemble from various dtsi's they'll just move to something else.
> 
> I never asked that :-) What I'm claiming is that capebus doesn't sound
> like the best solution for the problem exposed.
> 
>> Which is a shame, cause we do have a nice platform here.
> 
> I agree with you, the bone is quite awesome ;-)

Not without any working capes, it isn't.

> 
>>>> Some capes have their own MCUs.
>>>> A recent one has an 6502 communicating with uio_pruss.
>>>> https://github.com/ohporter/b6502
>>> 
>>> that uses remoteproc, so I assume it's using OMAP's mailbox ?
>>> 
>>> Again I say that this is not a 'capebus', it's just another device
>>> which we use another interface to talk to.
>>> 
>>> i2c devices will be children of the omap i2c controller, spi devices
>>> will be children of the omap mcspi, GPMC devices will need the GPMC
>>> controller and so on, but none of this looks like argument to introduce
>>> a fake bus into the kernel.
>>> 
>> 
>> I'll let the users of said bus to do the talking. You're just flat out
>> wrong IMO.
> 
> fair enough, I feel the same way about your capebus ;-)

Let's agree to disagree then :)

> 
> -- 
> balbi

Regards

-- Pantelis

