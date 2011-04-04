Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1DDUIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:08:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40460 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1DDUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i7R2Lh9soM/MCIhUlNNHVFX+4wEfPCzeET7mSqqaBEVI9+R3yg4K37fe3IiaF85hkz
         YQOqiqnP7iCyFfNkWT1PO8TjdWkSSg8n9u9PO+SeCZWzNhjsfGoWfly3vwuI+SDHt4AY
         ZJzYMXNiuyzaSL+kjW/8pgDPwFsfFh7m3wvTQ=
MIME-Version: 1.0
In-Reply-To: <1301925445.417.54.camel@e102391-lin.cambridge.arm.com>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<201104031726.37420.arnd@arndb.de>
	<20110403160324.GA8050@n2100.arm.linux.org.uk>
	<201104040259.26601.arnd@arndb.de>
	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
	<20110404112104.GB19854@n2100.arm.linux.org.uk>
	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>
	<20110404133104.GA23266@n2100.arm.linux.org.uk>
	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com>
Date: Mon, 4 Apr 2011 22:08:50 +0200
X-Google-Sender-Auth: 3U0XLF_AfFh34mB9nQfjDfdbX1s
Message-ID: <BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Detlef Vollmann <dv@vollmann.ch>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/4 Marc Zyngier <Marc.Zyngier@arm.com>:
> On Mon, 2011-04-04 at 14:31 +0100, Russell King - ARM Linux wrote:
>>
>> If ARM are going to architect a set of timers into the hardware, let's
>> make sure that all such hardware has them so we can dig ourselves out
>> of this crappy mess that we find ourselves in today.
>
> As far as I know, A15 always has a set of generic timers.
>
> It may be that they are not available (frequency not programmed into the
> CNTFREQ register), or that someone decided to use a better alternative
> (for some particular interpretation of "better").

I guess this thing is inside that A15 core?

First, what happens the day any vendors start making SoCs on this is
they turn the A15 core off whenever it is not used, loosing all state
including this timer, I believe.

This forces them all to add some totally different clocksource, event and
wakeup in some always-on voltage domain and rate that higher than
the A15 timer(s). They will then implement sched_clock() and
clocksource on that instead and only use A15 for localtimers.

(Leading to the proliferation of board/SoC timer hacks discussed
so much recently...)

The only way to reuse that poor thing in practice is if you engineer
a separate power domain with stuff that is supposed to be always-on
in the A15 macro (including these timers) so vendors must implement
this so as not to loose its state. Is this the case?

Else, in effect it will only be used as clocksource and sched_clock()
with these Versatile boards where the power is always on anyway.

Second, have you taken into account the effect of changing the
frequency of the A15 core, which is something every vendor also
does, as you know Colin Cross already has a patch pending
for that on the TWD localtimer which has not yet reached
the kernel. (Or is A15 fixed frequency? Forgive my ignorance...)

(And third it will also eventually need to hook into the timer-based
delay framework that I think Nokia is working on to be really
useful, else all delays become unpredictable.)

Yours,
Linus Walleij
