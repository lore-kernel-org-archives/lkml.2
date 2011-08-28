Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab1H1Fgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 01:36:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43936 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1H1Fg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 01:36:29 -0400
Date: Sun, 28 Aug 2011 07:36:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110828053624.GC12851@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Pavel Ivanov <paivanof@gmail.com>,
	Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
	dri-devel@lists.freedesktop.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 06:50:37PM -0400, Pavel Ivanov wrote:
> 2011/8/27 Michel Dänzer <michel@daenzer.net>:
> >> I observe very strange behavior dependent on value of
> >> CONFIG_DRM_RADEON parameter. When it's set to m everything works very
> >> good, no problem. When I set it to y I see kernel hang during boot. Or
> >> I should better say it "almost hangs" because during last boot attempt
> >> I accidentally waited a little bit longer and saw that after more than
> >> a minute waiting system continued to boot. Dmesg after "hang" shows
> >> these messages:
> >>
> >> [    8.542639] [drm] Loading CEDAR Microcode
> >> [   69.161605] r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
> >> [   69.161670] [drm:evergreen_startup] *ERROR* Failed to load firmware!
> >>
> >> While during normal boot
> >>
> >> [    9.898870] [drm] Loading CEDAR Microcode
> >> [    9.908425] radeon 0000:05:00.0: WB enabled
> >
> > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> > loaded from userspace, so it needs to be built into the kernel as well.
> 
> How should I do that? I've tried to set all "m"s to "y" in .config and
> still saw this issue. Should I set some special parameter?

You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.

The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
most probably be located in /lib/firmware or to whatever you have set
CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
a warning at the end of the kernel build). This way, it works for both
radeon being =m and =y.

HTH.

-- 
Regards/Gruss,
    Boris.
