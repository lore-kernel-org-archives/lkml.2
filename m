Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1LCKDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 05:03:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40470 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1LCKDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 05:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <20111202172323.34f75234@lxorguk.ukuu.org.uk>
References: <20111121182910.GA2856@Boggieman>
	<20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
	<CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
	<20111124162014.GA2750@Boggieman>
	<20111202172323.34f75234@lxorguk.ukuu.org.uk>
Date: Sat, 3 Dec 2011 11:03:11 +0100
Message-ID: <CAMeQTsbJ+w08OxuTokc6TDmsy2MoD2gZr73xg-c8KT7cpxiOcw@mail.gmail.com>
Subject: Re: GMA500 support
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > I suspect this is just DVI with a HDMI connector. That is the case for Fit-PC2.
>> > It is hooked up to the SDVO and provides video but no audio.
>
> I've now got an HDMI capable display *and* the right cables. Testing the
> Dell mini 10 shows that it works although it's defaulting to the wrong
> mode and there is stuff on the display below the picture that shouldn't
> be.
>
> So I now also have a debug case for the scaling or whatever is actually
> going on problem.

>From what I've seen on my Asus 1201HA, the mode the framebuffer code gets is
the biggest common mode of both displays. Since we get garbage outside the
scan-out buffer on the LVDS output I assume that the common mode doesn't find
it's way to LVDS mode setting (or maybe it just ignores it).

Also, do we know if the LVDS panel fitter code actually works? I don't have
access to my hardware at the moment but it would be interesting to see what
happens if you set a non-native resolution for LVDS at boot that overrides the
native one (without having anything connected to SDVO). Maybe you have tried
this already?

One thing I recall reading somewhere is that the panel fitter needs to be
restored upon re-enabling the pipe, and that the PFIT_CONTROL register must
be written to while the pipe is off. Doing DPMS off and then DPMS on might
disable the panel fitter.
