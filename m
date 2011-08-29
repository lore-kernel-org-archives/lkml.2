Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1H2OQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:16:24 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46802
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362Ab1H2OQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:16:20 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz146fK1432N98dKzz1202h1082kzz8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQP0Z1-02-CN5-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 16:16:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Pavel Ivanov <paivanof@gmail.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110829141612.GB2025@gere.osrc.amd.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic>
 <1314624021.2816.30.camel@twins>
 <20110829133808.GA2025@gere.osrc.amd.com>
 <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 09:48:22AM -0400, Alex Deucher wrote:
> >> Should we make Kconfig pop up a dialog and ask for the whereabouts of
> >> these firmware thingies when you mark the driver =y?
> >>
> >> This all sounds like magic to me, having to know you need to add to
> >> EXTRA_FIRMWARE, having to know what file it needs etc.. For all intents
> >> and purposes =y just doesn't work and that's broken.
> >
> > Yep, you make a lot of sense. I had to fumble the build/reboot cycle a
> > couple of times and do some code staring even to figure this out. In
> > the end, I copied the whole radeon/ folder from David's firmware git
> > repo into /lib/firmware and made radeon.ko =m again so that I don't have
> > to add *.bin entries to CONFIG_EXTRA_FIRMWARE each time I'm building a
> > kernel on a different machine.
> >
> > Besides, there was this other issue on lkml today where
> > CONFIG_EXTRA_FIRMWARE can cause nconf to segfault when you overflow
> > its length of 256 by trying to include a bunch of firmware *bin files:
> > http://lkml.org/lkml/2011/8/29/86
> 
> If you are going to build the ucode into your kernel you'll need to
> pick the ones you want to include or increase the limit regardless of
> whether it's radeon ucode or ucode for some other chip.  For a
> particular card you only need the ones for that card (e.g.,
> CEDAR_*.bin or REDWOOD_*.bin, etc.)

Alex, Dave, yeah, that's all fine.

The question Peter asked is, how to make this much more understandable
to the user so that she/he doesn't have to figure it out on their own.
IOW, if one sets RADEON to =y in Kconfig, it should automatically
generate a selection menu with all the firmware required so that
the user can select from it either the CEDAR* or the REDWOOD* (or
the DOUGHNUT* :-)) ones for her/his card and when the user selects
one entry, the required strings are added to CONFIG_EXTRA_FIRMWARE
_automatically_.

Maybe even Kbuild should try to find them on the system, and, if unable
to, remind the user to install the needed firmware package.

Anyway, something to that effect, the above is just to illustrate the
intention, I don't know whether it would work. In any case, we're
lacking user help there and we don't want to put every user through
the process of finding which firmware files she/he needs when setting
RADEON=y.

Does that make more sense?

-- 
Regards/Gruss,
Boris.

