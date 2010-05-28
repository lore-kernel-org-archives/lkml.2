Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0E1JcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:32:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42685 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab0E1JcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
Date: Fri, 28 May 2010 02:32:11 -0700
Message-ID: <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/28 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> Android does not only run on phones. It is possible that no android
>> devices have ACPI, but I don't know that for a fact. What I do know is
>> that people want to run Android on x86 hardware and supporting suspend
>> could be very benficial.
>
> Sufficently beneficial to justify putting all this stuff all over the
> kernel and apps ? That is a *very* high hurdle, doubly so when those

In my opinion yes.

> vendors who have chosen to be part of the community are shipping phones
> and PDAs just fine without them.
>
>> > I would imagine the existing laptops will handle power management limited
>> > by the functionality they have available. Just like any other piece of
>> > hardware.
>>
>> I think existing laptops (and desktops) can benefit from opportunistic
>> suspend support. If opportunistic suspend is used for auto-sleep after
>> inactivity instead of forced suspend, the user space suspend blocker
>> api will allow an application to delay this auto sleep until for
>> instance a download completes. This part could also be done with a
>
> This assumes you modify all the applications.

No it does not. You only have to modify the applications were you want
to improved behavior compared to what you have now.

> That isn't going to happen.
> The hardware is going to catch up anyway.

I want it work today.

>
>> alarms. I know my desktops can wakeup at a specific time by
>> programming an RTC alarm, but without suspend blockers how do you
>> ensure that the system does not suspend right after the alarm
>> triggered? I have a system that wakes up at specific times requested
>
> How do you know that isn't the correct behavior.

If the inactivity timeout happens to expire at the same time as my
alarm that would wake up the system to run my scheduled task if it was
already suspended my sceduled task will not run when scheduled. How
can you argue that this is the correct behavior.

> My laptop behaves in
> that way if for example the battery is almost flat. Your suspend blocker
> would cause me to lose all my work with a flat battery. This is another
> example of why the application must not be the policy manager.
>

You can still force suspend when the battery gets low.

> In the normal case in the PC world outside of corner cases like flat
> batteries the answer is really simple. The laptop suspend to RAM
> on idle intervals set in the BIOS and the like are sufficient that
> progress will have been made before it considers going back to sleep
> again. Right now its about ten seconds in each direction plus other costs
> (wear on LCD backlight, disc parking etc).
>

I'm not sure what you are trying to say here. Are you saying your
laptop enters S3 from idle?

-- 
Arve Hjønnevåg
