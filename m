Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1H2NiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:38:21 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:36977
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674Ab1H2NiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:38:16 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz936eK1432N98dKzz1202h1082kzz8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQOZ7M-02-9TX-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 15:38:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Alex Deucher <alexdeucher@gmail.com>
CC: Pavel Ivanov <paivanof@gmail.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110829133808.GA2025@gere.osrc.amd.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic>
 <1314624021.2816.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314624021.2816.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 03:20:21PM +0200, Peter Zijlstra wrote:
> On Sun, 2011-08-28 at 07:36 +0200, Borislav Petkov wrote:
> > > > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> > > > loaded from userspace, so it needs to be built into the kernel as well.
> > > 
> > > How should I do that? I've tried to set all "m"s to "y" in .config and
> > > still saw this issue. Should I set some special parameter?
> > 
> > You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
> > configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
> > 
> > The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
> > most probably be located in /lib/firmware or to whatever you have set
> > CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
> > a warning at the end of the kernel build). This way, it works for both
> > radeon being =m and =y.
> 
> Should we make Kconfig pop up a dialog and ask for the whereabouts of
> these firmware thingies when you mark the driver =y? 
> 
> This all sounds like magic to me, having to know you need to add to
> EXTRA_FIRMWARE, having to know what file it needs etc.. For all intents
> and purposes =y just doesn't work and that's broken.

Yep, you make a lot of sense. I had to fumble the build/reboot cycle a
couple of times and do some code staring even to figure this out. In
the end, I copied the whole radeon/ folder from David's firmware git
repo into /lib/firmware and made radeon.ko =m again so that I don't have
to add *.bin entries to CONFIG_EXTRA_FIRMWARE each time I'm building a
kernel on a different machine.

Besides, there was this other issue on lkml today where
CONFIG_EXTRA_FIRMWARE can cause nconf to segfault when you overflow
its length of 256 by trying to include a bunch of firmware *bin files:
http://lkml.org/lkml/2011/8/29/86

Alex?

-- 
Regards/Gruss,
Boris.

