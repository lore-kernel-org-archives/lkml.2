Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1CNL5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:57:34 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4924 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1CNL5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:57:30 -0400
Message-ID: <33b29bfb135fbe2ddcba88d342d67526.squirrel@webmail.xs4all.nl>
In-Reply-To: <201103141128.01259.linux@rainbow-software.org>
References: <201103121919.05657.linux@rainbow-software.org>
    <s5hei6ahvtu.wl%tiwai@suse.de>
    <df650e295afbf5651be743e58b06eb5b.squirrel@webmail.xs4all.nl>
    <201103141128.01259.linux@rainbow-software.org>
Date: Mon, 14 Mar 2011 12:57:27 +0100
Subject: Re: [alsa-devel] radio-maestro broken (conflicts with snd-es1968)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Ondrej Zary" <linux@rainbow-software.org>
Cc: "Takashi Iwai" <tiwai@suse.de>, jirislaby@gmail.com,
        alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 14 March 2011, Hans Verkuil wrote:
>> > At Sat, 12 Mar 2011 19:52:39 +0100,
>> >
>> > Hans Verkuil wrote:
>> >> On Saturday, March 12, 2011 19:19:00 Ondrej Zary wrote:
>> >> > Hello,
>> >> > the radio-maestro driver is badly broken. It's intended to drive
>> the
>> >>
>> >> radio on
>> >>
>> >> > MediaForte ESS Maestro-based sound cards with integrated radio
>> (like
>> >> > SF64-PCE2-04). But it conflicts with snd_es1968, ALSA driver for
>> the
>> >>
>> >> sound
>> >>
>> >> > chip itself.
>> >> >
>> >> > If one driver is loaded, the other one does not work - because a
>> >>
>> >> driver is
>> >>
>> >> > already registered for the PCI device (there is only one). This was
>> >>
>> >> probably
>> >>
>> >> > broken by conversion of PCI probing in 2006:
>> >> > ttp://lkml.org/lkml/2005/12/31/93
>> >> >
>> >> > How to fix it properly? Include radio functionality in snd-es1968
>> and
>> >>
>> >> delete
>> >>
>> >> > radio-maestro?
>> >>
>> >> Interesting. I don't know anyone among the video4linux developers who
>> >> has
>> >> this hardware, so the radio-maestro driver hasn't been tested in at
>> >> least
>> >> 6 or 7 years.
>> >>
>> >> The proper fix would be to do it like the fm801.c alsa driver does:
>> have
>> >> the radio functionality as an i2c driver. In fact, it would not
>> surprise
>> >> me at all if you could use the tea575x-tuner.c driver (in
>> >> sound/i2c/other)
>> >> for the es1968 and delete the radio-maestro altogether.
>> >
>> > I guess simply porting radio-maestro codes into snd-es1968 would work
>> > without much hustles, and it's a bit safe way to go for now; smaller
>> > changes have less chance for breakage, and as little people seem using
>> > this driver, it'd be better to take a safer option, IMO.
>>
>> I assume someone has hardware since someone reported this breakage. So
>> try
>> to use tuner-tea575x for the es1968. It shouldn't be too difficult.
>> Additional cleanup should probably wait until we find a tester for the
>> fm801 as well.
>
> I have the hardware - both ES1968 (SF64-PCE2-04) and FM801 cards
> (SF64-PCR)
> with these tuners. I remember fixing mute in tea5757x-tuner back in 2009
> (testing it on SF64-PCR).
>
>> I don't like the idea to duplicate code.
>
> I don't like that either. I've done a quick hack - copied radio support
> from
> fm801 and radio_bits_get() and radio_bits_set() from radio-maestro to
> es1968
> and it seems to basically work.
> Now I just need some more time to finish it, then move everything good
> from
> radio-maestro to tea575x-tuner and delete radio-maestro.

Great! Let me know if you have any v4l-related questions!

>
> IIRC, the TEA5757 tuner is also present on at least one ISA radio card -
> SF16-FMR2 (which I also have).

Interesting. I have a bunch of isa radio cards myself and I am planning a
major cleanup of those isa drivers. I might get back to you for testing.

Regards,

        Hans

>
> --
> Ondrej Zary
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

