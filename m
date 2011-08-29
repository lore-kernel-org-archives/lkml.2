Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1H2Nnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:43:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37261 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1H2Nn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110829133808.GA2025@gere.osrc.amd.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
	<1314435638.2321.12.camel@thor.local>
	<CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
	<20110828053624.GC12851@liondog.tnic>
	<1314624021.2816.30.camel@twins>
	<20110829133808.GA2025@gere.osrc.amd.com>
Date: Mon, 29 Aug 2011 14:43:28 +0100
Message-ID: <CAPM=9tyW7GYa0HSeqDb1WPs5K5ov=K2yOPKu1s0mMzhSJVvqPQ@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Dave Airlie <airlied@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Pavel Ivanov <paivanof@gmail.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/29 Borislav Petkov <bp@alien8.de>:
> On Mon, Aug 29, 2011 at 03:20:21PM +0200, Peter Zijlstra wrote:
>> On Sun, 2011-08-28 at 07:36 +0200, Borislav Petkov wrote:
>> > > > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
>> > > > loaded from userspace, so it needs to be built into the kernel as well.
>> > >
>> > > How should I do that? I've tried to set all "m"s to "y" in .config and
>> > > still saw this issue. Should I set some special parameter?
>> >
>> > You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
>> > configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
>> >
>> > The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
>> > most probably be located in /lib/firmware or to whatever you have set
>> > CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
>> > a warning at the end of the kernel build). This way, it works for both
>> > radeon being =m and =y.
>>
>> Should we make Kconfig pop up a dialog and ask for the whereabouts of
>> these firmware thingies when you mark the driver =y?
>>
>> This all sounds like magic to me, having to know you need to add to
>> EXTRA_FIRMWARE, having to know what file it needs etc.. For all intents
>> and purposes =y just doesn't work and that's broken.
>
> Yep, you make a lot of sense. I had to fumble the build/reboot cycle a
> couple of times and do some code staring even to figure this out. In
> the end, I copied the whole radeon/ folder from David's firmware git
> repo into /lib/firmware and made radeon.ko =m again so that I don't have
> to add *.bin entries to CONFIG_EXTRA_FIRMWARE each time I'm building a
> kernel on a different machine.

That asks the question is your distro isn't shipping those firmware for you.

The main thing is you build in the driver which firmware to include?
granted all the radeon firmware is only about 580k so its probably not
a problem to somehow magically add them all to CONFIG_EXTRA_FIRMWARE
if RADEON=y, if someone thinks to make kbuild do it, but you really
only 3 or 4 of them on any one card.

Dave.
