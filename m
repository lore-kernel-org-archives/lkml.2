Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab2KANdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:33:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36724 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2KANd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:33:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20121101130636.GB12489@arwen.pp.htv.fi>
Date: Thu, 1 Nov 2012 14:33:21 +0100
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CF8447C2-55E9-48AC-9C08-F1F48D47739B@dominion.thruhere.net>
References: <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <50925C49.7060004@ti.com> <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net> <20121101130636.GB12489@arwen.pp.htv.fi>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 1 nov. 2012, om 14:06 heeft Felipe Balbi <balbi@ti.com> het volgende geschreven:

> Hi,
> 
> On Thu, Nov 01, 2012 at 01:00:21PM +0100, Koen Kooi wrote:
>> tl;dr: please suggest an actual solution that allows plug&play when
>> plugging in multiple capes and applying power after that. Preferably
>> one that doesn't pass the buck to u-boot.
> 
> I can think of a few ways:
> 
> 1) ship your distribution with all necessary drivers and let udev handle
> 	driver probing.
> 
> 	clearly this will require constant updates for the distribution
> 	as new capes are developed. But IIUC, that's the same with
> 	Arduino where new "libraries" are added to the Arduino OS.

And how are you going to handle pinmuxing and conflict resolution? You're basically saying that people should just use /dev/mem to write drivers, since you don't consider their use case valid.

> 
> 2) ship with drivers for EEPROMs only and setup a repository of drivers
> 
> 	this would require every driver to be packaged separately, then
> 	you create a setup where bone's userland will use EEPROMs data
> 	to figure out which drivers it needs, pass that information to
> 	SDK via USB, then SDK downloads all necessary/missing packages,
> 	sends them to bone via USB and all packages are installed on the
> 	bone.
> 
> 	Note that since packages would be 'installed', this would be a
> 	one-time-only thing.

I lack the words to describe my emotions after reading this. Let's leave it at that.

> 3) realize that if your user can build an FPGA cape, s/he can most
> 	likely write code and adding/recompiling kernel shouldn't be the
> 	biggest of his/her worries
> 
> 	(no comments to this one, I understand it's not feasible)

You'd be surprised.

> in any case, capebus sounds like something which is hugely unnecessary.

On tablets and phones, yes. But TI chips are use for different use-cases, bone + capes being one of those.

> ps: at least for the I2C subsystem, i2c-core can detect for you if your
> driver provides ->detect() method.

So I just need to patch all i2c drivers and force people to use the "standard" address for the i2c chip when designing a board.

>> Op 1 nov. 2012, om 12:26 heeft "Cousson, Benoit" <b-cousson@ti.com> het volgende geschreven:
>>>>> FWIW, we do have a similar, but simpler, problem with the beagle /
>>>>> beagle-xm and panda / panda-es. But for the moment we are just
>>>>> using a different DTS for each board.
>>>> 
>>>> A different DTS for each board combination... There alot more capes
>>>> for the bone that they are for the beagle & the panda.  And more
>>>> are going to come, but not necessarily from people that have any
>>>> connection to TI or CCO.
>>> 
>>> Sure, but my point is that your solution will not solve our problem
>>> :-)
>>> This is a generic problem that you address with a very custom /
>>> specific approach.
>>> 
>>>> You still haven't described how I could solve the issue of
>>>> conflicting capes using a single DTS.
>>> 
>>> Well I don't have the solution otherwise I will have done it already
>>> :-)
>>> My point is that the solution has to be in the DT core if not in the
>>> bootloader.
>> 
>> <snarky comment>So when we at beagleboard.org handled the beagleboard
>> and beagleboard xM expansionboards in the bootloader (detection,
>> muxing, etc) we were told it was wrong and we should handle it in the
>> kernel and if we waited a bit, DT would solve everything. And now that
>> we actually handle it in the kernel you are saying that it is wrong
>> and we should handle it in the bootloader and that DT won't solve
>> everything. I guess someone will now tell us that uEFI will fix
>> everything.</snarky comment>
>> 
>> Apart from that, you and others still fail to tell us how you want to
>> handle a user (or customer) that buys a beaglebone, an LCD cape, a
>> weatherstation cape and a geiger counter cape and plugs those together
>> and powers them on. With the evil TI vendor tree and extra patches the
>> boardfile reads the eeproms and tries its best to instantiate all the
>> platform data. One of the capes won't have working LEDs since
>> appending to the leds-gpio struct is pretty much impossible in this
> 
> couldn't you just instantiate multiple leds-gpio device ?

No, and that is a problem in the driver core, see earlier discussions about similar problems.

>> situation. But it gets a picture on the screen, blinks LEDs and does
>> largely what the user expects.
>> 
>> With capebus we get:
>> 
>> 1) da8xx-fb which lacks DT bindingsp[1] receives plaftorm data to
>> match the LCD
> 
> this is something which could be fixed at the driver level, right ? :-)

You'd have to tell your coworkers that.

>> 2) the i2c sensors on the weathercape are registered
> 
> that will work with or without capebus.

Not in a plug and play way.

>> 3) the one-wire bus on the weathercape gets registered
> 
> also should work with or without capebus.

Not in a plug and play way.

>> 4) the LEDs on the lcd cape get registered5
> 
> also works with or without capebus.

Not in a plug and play way.

>> 5) the LED on the geigercape gets registered and adds a custom trigger
> 
> also works with or without capebus.

Not in a plug and play way.

> 
>> 6) the ADC, which again, lacks DT bindings[2], receives plaftorm data
>> and a custom IIO binding
> 
> driver problem.

Yes, beat up your coworkers, I can't.

> 
>> 7) pinctrl sets the pinmuxes for the above
> 
> also works with or without capebus.

Not in a plug and play way.

> 
>> In other words: plug & play, even for devices with drivers that are
>> still lacking DT support. 
> 
> I _do_ agree with you that we could have a "grace period" where DT and
> non-DT would boot together, but apparently that's not something which
> isn't trivial to do.
> 
> I guess Benoit might also be concerned that if we add such an
> infrastructure than conversion to DT will never finish heh.

Like I said, take that up with your coworkers. I want DT support for all TI IP blocks, apparently TI disagrees.

>> Now please explain to me why you think it's such an awesome idea that
>> the users will need to find the right dtsi files (multiple revisions
>> of the lcd cape exist), include them in the dts, run dtc, add a few
>> missing semicolons, run dtc again, copy it over to /boot and reboot to
>> have a change of making it work?
> 
> that shouldn't be necessary. At least for all the I2C devices, you can
> just implement ->detect() and it will just work. Maybe similar tricks
> can be done for 1-wire and SPI, I haven't looked into the details of
> those buses to be sure, though.
> 
>> I know you can't escape that for new or custom capes, but I do want
>> all the capes my company assembles work out of the box.
> 
> then push all drivers to mainline and start shipping your boards with
> those drivers enabled.

So how do you solve conflicts? The PRU pins are mixed with the LCD pins. So how can I enable both drivers? Same deal with mcasp and SPI.

> 
>> (Cross)compiling a kernel is a bridge too far for 95% of the intended
>> audience.
> 
> Agreed, but that doesn't prevent you from either shipping distribution
> with drivers enabled or providing pre-compiled modules.
> 
>> With capebus most capes can be supported by editing the DTS, your
>> bootloader proposal involves updating u-boot for every new cape as
>> well. That is downright scary. The RMA department will get flooded.
> 
> that's not true at all. If capebus can do all that from within kernel,
> it surely can do the same (with a few changes here and there) from
> within bootloader.

Yes, and then I have 2 places to add support for capes instead of one. And I seriously question why anyone thinks that having users replace their bootloader everytime they add a new i2c device or LED to their board is a good idea.

> 
>> More importantly: capebus is generic enough to work on beagleboard,
>> beagleboard xm, panda, panda es and even raspberry-pi. Basically on
>> any DT capable platform.
> 
> that doesn't matter much I guess. MTP is so cool that works on Exynos,
> OMAP, Tegra, x86, Cris, AVR, etc etc etc and we still don't have an MTP
> stack inside the kernel (ok a bit sarcastic... but you get the drift,
> hopefully).

Yes, I agree, we still don't have a working MUSB driver in the kernel either. But that shouldn't stop capebus from being considered.