Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0FFKAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:00:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42043 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0FFKAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W80HpPKSmSjxAsI6nF5YBD3Xx6rec7XKlN9Ld8wK20vtsl2MZoIi7HRNC3M6Rhp92v
         gxq8kbKIMeatw1lkRiBYcZRwC/PfCPn3jeyfkkp2dhyKp/EytqN+Y2KUj4xwsK9R3sPr
         TNFTztdB2xD30kVGx5CsYJ/Pnq3vmQvBsAtaE=
MIME-Version: 1.0
In-Reply-To: <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
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
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
Date: Sun, 6 Jun 2010 12:00:47 +0200
Message-ID: <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 11:21 AM, Brian Swetland <swetland@google.com> wrote:
>
> The common case for a phone is to be sitting around.  Even for heavy
> smartphone users, unless they power on, use the device screen-on for 4
> hours solid or whatnot and drain the battery straight away, the device
> is going to spend a significant portion of its operating time in
> screen-off standby modes (conserving power for when you take a call,
> browse the web, etc).

Sure, but my point was, some non-trivial (still kind of natural for a
smartphone) activities with the device will prevent it from suspending
for quite some time. Even worse, the suspend wakelock will keep the
whole kernel active, as opposed to powering off unused devices
separately as it's done in runtime PM. Yep, I know about the "early
suspend" type of thing; yet it's excess, not mainlined and lacks
granularity.

> For typical users on typical android devices, this means the device
> stays suspended for 5-10 minutes at a time, coming up for air when a
> network packet (mail sync, im, etc) or alarm (battery monitor) wakes
> the device briefly.  Obviously with the right combination of bad apps
> you will see a device suspending more rarely.

Wasn't that you who stated that you so successfully tolerate bad apps
with opportunistic suspend that anything of the kind should not really
be the case? :)

>> E. g. when the wireless is connected to an AP, it takes a wake lock
>> which is released on 15 minutes touchscreen inactivity timeout, as far
>> as I can tell. So:
>>
>> * the system will never hit suspend during this period;
>> * if the download was ongoing and had not been completed during this
>> period, it will be terminated.
>
> I'm pretty sure the wifi subsystem does not actually take a wakelock
> while its connected -- it does have an alarm to spin down wifi after
> 15 minutes (by default, and user disableable) largely due to power
> inefficiencies in the wifi solution in some early devices.

Oh? How does it make sure it's not powered off while scanning for APs,
for instance?

> Users do like that to work too -- I recall Arve leaving a device in
> his filing cabinet with the radio off while he was out of the country
> for three weeks once, and him discovering it was still running with
> something like 25% battery remaining when he returned.

So what you're actually up to is that a user should restart the phone
and turn the radio off if he wants to find it running when he's back
from a long business trip or something. Nice...

> In any case, I'm saying that suspending for minutes at a time
> (typical, 10s of minutes or more in some cases, hours in others), does
> happen and it does represent an improvement over suspending or
> otherwise entering your lowest power state for seconds at a time.

That's for sure, if _all_ the other parameters *are* *equal*. This is
obviously not the case.

~Vitaly
