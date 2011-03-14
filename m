Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1CNJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:59:54 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1834 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1CNJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:59:52 -0400
Message-ID: <df650e295afbf5651be743e58b06eb5b.squirrel@webmail.xs4all.nl>
In-Reply-To: <s5hei6ahvtu.wl%tiwai@suse.de>
References: <201103121919.05657.linux@rainbow-software.org>
    <201103121952.39850.hverkuil@xs4all.nl>
    <s5hei6ahvtu.wl%tiwai@suse.de>
Date: Mon, 14 Mar 2011 10:59:47 +0100
Subject: Re: [alsa-devel] radio-maestro broken (conflicts with snd-es1968)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Ondrej Zary" <linux@rainbow-software.org>, jirislaby@gmail.com,
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

> At Sat, 12 Mar 2011 19:52:39 +0100,
> Hans Verkuil wrote:
>>
>> On Saturday, March 12, 2011 19:19:00 Ondrej Zary wrote:
>> > Hello,
>> > the radio-maestro driver is badly broken. It's intended to drive the
>> radio on
>> > MediaForte ESS Maestro-based sound cards with integrated radio (like
>> > SF64-PCE2-04). But it conflicts with snd_es1968, ALSA driver for the
>> sound
>> > chip itself.
>> >
>> > If one driver is loaded, the other one does not work - because a
>> driver is
>> > already registered for the PCI device (there is only one). This was
>> probably
>> > broken by conversion of PCI probing in 2006:
>> > ttp://lkml.org/lkml/2005/12/31/93
>> >
>> > How to fix it properly? Include radio functionality in snd-es1968 and
>> delete
>> > radio-maestro?
>>
>> Interesting. I don't know anyone among the video4linux developers who
>> has
>> this hardware, so the radio-maestro driver hasn't been tested in at
>> least
>> 6 or 7 years.
>>
>> The proper fix would be to do it like the fm801.c alsa driver does: have
>> the radio functionality as an i2c driver. In fact, it would not surprise
>> me at all if you could use the tea575x-tuner.c driver (in
>> sound/i2c/other)
>> for the es1968 and delete the radio-maestro altogether.
>
> I guess simply porting radio-maestro codes into snd-es1968 would work
> without much hustles, and it's a bit safe way to go for now; smaller
> changes have less chance for breakage, and as little people seem using
> this driver, it'd be better to take a safer option, IMO.

I assume someone has hardware since someone reported this breakage. So try
to use tuner-tea575x for the es1968. It shouldn't be too difficult.
Additional cleanup should probably wait until we find a tester for the
fm801 as well.

I don't like the idea to duplicate code.

Regards,

      Hans

> If we have active testers for both devices, it's nicer to go forward
> to clean-up works indeed, though.
>
>
> thanks,
>
> Takashi
>
>> Both are for the tea575x tuner, although radio-maestro seems to have
>> better
>> support for the g_tuner operation. It doesn't seem difficult to add that
>> to
>> tea575x-tuner.c.
>>
>> The fm801 code for driving the tea575x is pretty horrible and it should
>> be
>> possible to improve that. I suspect that those read/write/mute functions
>> really belong in tea575x-tuner.c and that only the low-level gpio
>> actions
>> need to be in the fm801/es1968 drivers.
>>
>> Hope this helps.
>>
>> Regards,
>>
>> 	Hans
>>
>> BTW: if anyone has spare hardware for testing the
>> radio-maestro/tea575x-tuner,
>> then I'm interested.
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by Cisco
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

