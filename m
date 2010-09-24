Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0IXNUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:20:50 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:50063 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0IXNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:20:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9CA6E9.30707@cam.ac.uk>
Date: Fri, 24 Sep 2010 14:26:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
References: <20100830214025.2f9677a1@lxorguk.ukuu.org.uk> <20100830204412.GA28711@core.coreip.homeip.net> <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com> <20100830214355.GB28865@core.coreip.homeip.net> <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com> <20100830224352.GF28865@core.coreip.homeip.net> <20100831104446.321fd4f4@lxorguk.ukuu.org.uk> <20100831161730.GA30947@core.coreip.homeip.net> <20100831175937.70a59a91@lxorguk.ukuu.org.uk> <20100831170923.GB30947@core.coreip.homeip.net> <20100924130241.GB1810@ucw.cz>
In-Reply-To: <20100924130241.GB1810@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/10 14:02, Pavel Machek wrote:
> Hi!
> 
>>> So a voltmeter really makes no sense. It's not a set of keys and it
>>> doesn't give X/Y/Z style readings. Nor does a camera. But a lot of things
>>> do fit this to varying degrees.
>>>
>>> I'm actually more dubious than Linus about ALS - because ALS tends not
>>> produce 'events' but to be sampled, and there are significant power
>>> implications to unnecessary polling.
> 
> That's very similar to analog joysticks, no?
Yes, but typically much slower. Maybe a couple of times a second at most.
Some of them do support events.  The original proposal didn't include these
as no driver at the time supported them. drivers/staging/iio/light/tsl2563.c
does now though. Given the low rates, we did discuss doing this via select
on sysfs attributes (driven off underlying hardware interrupts).
> 
>>> And the more it's used the less special
>>> code is needed in user or kernel space for PDAs and phones - instead they
>>> just work.
>>
>> OK, so let's say we start moving some of the devices into input. Which
>> ones we consider suitable for input? I guess some 3-digit
>> accelerometers, what else? Also, what new event types would we need?
>> Let's take GPS - I do not think that ABS_X and ABS_Y are the best events
>> to be used for such devices: I am trying to allow applications being
> 
> I'd not put GPS into input; yes, they do present 'x,y,z' in meters,
> but that's not what users want. 'lat,lon,alt' is better, but it is
> actually 'lat,lon,herror,alt,verror,time' and a lot of other
> metadata...
> 
> Also, we already have driver for GPSes, its called gpsd. I'd leave
> GPSes out of input.
> 
>> Also, GPS, liek ALS, would probably be polling, no?
> 
> Normally, GPS just sends you position info once a second.

