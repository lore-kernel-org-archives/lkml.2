Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0H3RKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:10:42 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60605 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0H3RKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:10:40 -0400
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 12:10:41 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hemanth V <hemanthv@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <igor.stoppa@nokia.com>, <kai.svahn@nokia.com>,
        <mathias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
In-Reply-To: <20100830162855.GA17325@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com> <20100830162855.GA17325@core.coreip.homeip.net>
Message-ID: <d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 30 Aug 2010 09:28:56 -0700, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> When we tried to push N900's accelerometer driver as an
>> input device you commented you didn't want sensors such
>> as accelerometers, magnetometers, proximity, etc on the
>> input layer because "they are not user input", although
>> I didn't fully agree with you, we had to modify the drivers
>> and, I believe, one of them is sitting in staging under
>> the industrial i/o subsystem.
>> 
>> Are you now accepting sensor drivers on the input layer ?
>> that will make our life a lot easier but we need some
>> definition to avoid having to re-work drivers when we
>> want to push them to mainline.
>> 
> 
> I got persuaded that 3-axis accelerometers are most often indended to be
> used as input devices so I decided I should take these in (adxl134x is
> there). I still think that sensor devices in general are better suited
> to IIO subsystem and I hope it will get out of staging soon.
> 
> Once it is out of staging we may think about creating a IIO-to-input
> bridge (copuld be either in kernel or a userspace solution based on
> uinput) to route sensors that are indeed used as HIDs.
> 
> Hope this makes sense.

It kinda does, but such sensors will be more and more used as
input devices, specially for gaming on mobile devices.

For example a proximity sensor might be used as the trigger
button on a first person shooting game; accelerometers will
be used to walk through the map and a magnetometer might be
used to look behind you and a gyroscope to turn around your
own axis.

In the end, the user is the one moving the device around and
generating such events, so why not avoiding yet another
subsystem if we will have to resort to solutions such as
iio-to-input bridge, which smells like a hackish solution
to get input events from sensors anyway.

I really hope I could convince you that, on mobile at least,
sensors will be mostly used as HID devices and will give
app developers new ways for them to allow users to interact
with their app.

Take a look at how a gyroscope is used on iphone, for
instance [1].

[1] http://www.youtube.com/watch?v=ORcu-c-qnjg

-- 
balbi
