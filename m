Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1H2QKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:10:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46434 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1H2QKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110829155501.GC2025@gere.osrc.amd.com>
References: <20110829141612.GB2025@gere.osrc.amd.com>
	<1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	<20110829155501.GC2025@gere.osrc.amd.com>
Date: Mon, 29 Aug 2011 12:10:45 -0400
Message-ID: <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Arnaud Lacombe <lacombar@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: David Airlie <airlied@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 29, 2011 at 11:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Aug 29, 2011 at 11:47:24AM -0400, David Airlie wrote:
>> > On Mon, Aug 29, 2011 at 09:48:22AM -0400, Alex Deucher wrote:
>> > > >> Should we make Kconfig pop up a dialog and ask for the
>> > > >> whereabouts of
>> > > >> these firmware thingies when you mark the driver =y?
>> > > >>
>> > > >> This all sounds like magic to me, having to know you need to add
>> > > >> to
>> > > >> EXTRA_FIRMWARE, having to know what file it needs etc.. For all
>> > > >> intents
>> > > >> and purposes =y just doesn't work and that's broken.
>> > > >
>> > > > Yep, you make a lot of sense. I had to fumble the build/reboot
>> > > > cycle a
>> > > > couple of times and do some code staring even to figure this out.
>> > > > In
>> > > > the end, I copied the whole radeon/ folder from David's firmware
>> > > > git
>> > > > repo into /lib/firmware and made radeon.ko =m again so that I
>> > > > don't have
>> > > > to add *.bin entries to CONFIG_EXTRA_FIRMWARE each time I'm
>> > > > building a
>> > > > kernel on a different machine.
>> > > >
>> > > > Besides, there was this other issue on lkml today where
>> > > > CONFIG_EXTRA_FIRMWARE can cause nconf to segfault when you
>> > > > overflow
>> > > > its length of 256 by trying to include a bunch of firmware *bin
>> > > > files:
>> > > > http://lkml.org/lkml/2011/8/29/86
>> > >
>> > > If you are going to build the ucode into your kernel you'll need to
>> > > pick the ones you want to include or increase the limit regardless
>> > > of
>> > > whether it's radeon ucode or ucode for some other chip. For a
>> > > particular card you only need the ones for that card (e.g.,
>> > > CEDAR_*.bin or REDWOOD_*.bin, etc.)
>> >
>> > Alex, Dave, yeah, that's all fine.
>> >
>> > The question Peter asked is, how to make this much more understandable
>> > to the user so that she/he doesn't have to figure it out on their own.
>> > IOW, if one sets RADEON to =y in Kconfig, it should automatically
>> > generate a selection menu with all the firmware required so that
>> > the user can select from it either the CEDAR* or the REDWOOD* (or
>> > the DOUGHNUT* :-)) ones for her/his card and when the user selects
>> > one entry, the required strings are added to CONFIG_EXTRA_FIRMWARE
>> > _automatically_.
>> >
>> > Maybe even Kbuild should try to find them on the system, and, if
>> > unable
>> > to, remind the user to install the needed firmware package.
>> >
>> > Anyway, something to that effect, the above is just to illustrate the
>> > intention, I don't know whether it would work. In any case, we're
>> > lacking user help there and we don't want to put every user through
>> > the process of finding which firmware files she/he needs when setting
>> > RADEON=y.
>> >
>> > Does that make more sense?
>>
>> Oh it makes sense, just neither of us are Kbuild hackers and I'm not sure that'll change at any point :)
>>
>> It also sounds like something that could apply to any driver with external firmware.
>
> So it seems like all the request_firmware() drivers could use a Kbuild
> functionality of some sort which presents the user with an option to
> select the firmware blobs for his hw when those drivers are =y. Hairy.
>
> Adding kbuild ML.
>
do you want something ala:

config EXTRA_FIRMWARE
    string
    default ""
    append "FOO" if BAR
    append "FOZ" if BAZ

or maybe a new type "list" which would behave as a comma/space separated value.

config EXTRA_FIRMWARE
    list "bla"
    append "FOO" if BAR
    append "FOZ" if BAZ

?

Thanks,
 - Arnaud

> --
> Regards/Gruss,
> Boris.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
