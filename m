Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0FFJVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:21:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab0FFJVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:21:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=uPJ/zRbLj717BgSn1hs1qCSJnRMpLVKU+w/X+OH0G8HAho3vA7vrUiBz6lNQPXcTu
	6ArBvS/wcSO2K9GSljlBg==
MIME-Version: 1.0
In-Reply-To: <AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
Date: Sun, 6 Jun 2010 02:21:11 -0700
Message-ID: <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 1:32 AM, Vitaly Wool <vitalywool@gmail.com> wrote:
>>
>> It varies depending on device and usage.  The battery monitoring on
>> NexusOne happens every ten minutes, so that's the longest you'll see a
>> N1 suspended for.  On a G1 or Dream/myTouch you can see 20-30 minutes
>> between wakeups (depending on network issues and background data sync
>> traffic), and if you have background data sync off those devices can
>> sit in suspend for days at a time (unless you receive a phone call or
>> something).  In "airplane mode", with no local alarms, a device can
>> easily sit in the lowest power state for a month or so, until the
>> battery finally runs out.
>
> That only concerns the case when you have just turned on the phone and
> left it laying around.
> You have to admit that it's not the common case for a smartphone. The
> common case is that you've played with it for a bit, turning on things
> like BT/WIFI, running some apps and so on. And doing so you'll end up
> having wake locks taken from everywhere, so I can hardly see a second
> of suspend for Nexus.

The common case for a phone is to be sitting around.  Even for heavy
smartphone users, unless they power on, use the device screen-on for 4
hours solid or whatnot and drain the battery straight away, the device
is going to spend a significant portion of its operating time in
screen-off standby modes (conserving power for when you take a call,
browse the web, etc).

For typical users on typical android devices, this means the device
stays suspended for 5-10 minutes at a time, coming up for air when a
network packet (mail sync, im, etc) or alarm (battery monitor) wakes
the device briefly.  Obviously with the right combination of bad apps
you will see a device suspending more rarely.

> E. g. when the wireless is connected to an AP, it takes a wake lock
> which is released on 15 minutes touchscreen inactivity timeout, as far
> as I can tell. So:
>
> * the system will never hit suspend during this period;
> * if the download was ongoing and had not been completed during this
> period, it will be terminated.

I'm pretty sure the wifi subsystem does not actually take a wakelock
while its connected -- it does have an alarm to spin down wifi after
15 minutes (by default, and user disableable) largely due to power
inefficiencies in the wifi solution in some early devices.  There's
some room for improvement here, obviously.  With a decent wifi chipset
and implementation, depending on local wifi traffic patterns, you can
see power usage competitive to cellular.

> So the bottom line is: the approach is very inflexible. Of course it
> can give you the best power savings if you turn the Airplane mode on
> as soon as you switched on the phone, but this is not what a typical
> user would do.

The savings in airplane mode (apart from preventing data connections,
which saves power by preventing data-hungry background apps from doing
much) is the difference between standby with radio (3-5mA) and without
(1-2mA).  I'm not suggesting that airplane mode is a typical case,
just using it as in illustration of the more extreme standby case.

Users do like that to work too -- I recall Arve leaving a device in
his filing cabinet with the radio off while he was out of the country
for three weeks once, and him discovering it was still running with
something like 25% battery remaining when he returned.

In any case, I'm saying that suspending for minutes at a time
(typical, 10s of minutes or more in some cases, hours in others), does
happen and it does represent an improvement over suspending or
otherwise entering your lowest power state for seconds at a time.

Brian
