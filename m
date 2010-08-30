Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0H3RhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:37:12 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:37966 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0H3RhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:37:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C7BED63.2010706@jic23.retrosnub.co.uk>
Date: Mon, 30 Aug 2010 18:41:55 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Felipe Balbi <me@felipebalbi.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hemanth V <hemanthv@ti.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, igor.stoppa@nokia.com, kai.svahn@nokia.com,
        mathias.nyman@nokia.com
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com> <20100830162855.GA17325@core.coreip.homeip.net> <d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com>
In-Reply-To: <d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/10 18:10, Felipe Balbi wrote:
> Hi,
> 
> On Mon, 30 Aug 2010 09:28:56 -0700, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>>> When we tried to push N900's accelerometer driver as an
>>> input device you commented you didn't want sensors such
>>> as accelerometers, magnetometers, proximity, etc on the
>>> input layer because "they are not user input", although
>>> I didn't fully agree with you, we had to modify the drivers
>>> and, I believe, one of them is sitting in staging under
>>> the industrial i/o subsystem.
>>>
>>> Are you now accepting sensor drivers on the input layer ?
>>> that will make our life a lot easier but we need some
>>> definition to avoid having to re-work drivers when we
>>> want to push them to mainline.
>>>
>>
>> I got persuaded that 3-axis accelerometers are most often indended to be
>> used as input devices so I decided I should take these in (adxl134x is
>> there). I still think that sensor devices in general are better suited
>> to IIO subsystem and I hope it will get out of staging soon.
>>
>> Once it is out of staging we may think about creating a IIO-to-input
>> bridge (copuld be either in kernel or a userspace solution based on
>> uinput) to route sensors that are indeed used as HIDs.
I'll look into the userspace option.  Might well be a quicker option
in the near future not to mention providing a good example of using
our userspace interfaces...
>>
>> Hope this makes sense.
> 
> It kinda does, but such sensors will be more and more used as
> input devices, specially for gaming on mobile devices.
> 
> For example a proximity sensor might be used as the trigger
> button on a first person shooting game; accelerometers will
> be used to walk through the map and a magnetometer might be
> used to look behind you and a gyroscope to turn around your
> own axis.
> 
> In the end, the user is the one moving the device around and
> generating such events, so why not avoiding yet another
> subsystem if we will have to resort to solutions such as
> iio-to-input bridge, which smells like a hackish solution
> to get input events from sensors anyway.
> 
> I really hope I could convince you that, on mobile at least,
> sensors will be mostly used as HID devices and will give
> app developers new ways for them to allow users to interact
> with their app.
> 
> Take a look at how a gyroscope is used on iphone, for
> instance [1].
> 
> [1] http://www.youtube.com/watch?v=ORcu-c-qnjg
> 
Kind of an obvious point, but there are lots of sensors in these
classes that no one is ever going to use for input. Take
a high g acceleromter (anything above c.10g for this purpose)
or the sorts of IMU's IIO currently has, which are simply too
expensive / large. Or take mid to high spec ADCs.
For other uses the requirements are typically very
different and could not be added to input without major disruption.
Personally I see no problem with having two drivers in kernel for
a device assuming they are sufficiently different in purpose.

I agree we have some fragmentation here and ideally
these device might all sit on some 'uber' subsystem providing
all things to all men.  Unfortunately that would probably come with
massive complexity and at the end of the day we already
have subsystems doing a very good job of handling some classes
of device.  The intent of IIO was always to cover the ground
that is out of scope for hwmon and input.  As you have probably
seen this does indeed add a fair bit of complexity!

We're working on cleaning things up.  Large set of fixes on
linux-iio today (including a few abi fixes for
the magnetometer you mention above :)  Still if anyone wants
to speed up our move to mainline we always appreciate code review!
*looks hopeful*  I'm always happy to direct people towards the
most dubious bits or advise anyone porting a driver.  We have
a reasonable team now (thanks partly to exposure we got by
being in staging!), but more help is always good.

Jonathan
(IIO 'maintainer' in case anyone didn't guess)
