Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1H2Ftf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:49:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50879 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1H2Ftb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:49:31 -0400
Date: Mon, 29 Aug 2011 07:49:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110829054926.GA7123@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Pavel Ivanov <paivanof@gmail.com>,
	Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
	dri-devel@lists.freedesktop.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic>
 <CAG1a4rv8YirPpyYP735Zn3gpp-kcvvECd=-haZ-qx90_99x8aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG1a4rv8YirPpyYP735Zn3gpp-kcvvECd=-haZ-qx90_99x8aQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 05:47:59PM -0400, Pavel Ivanov wrote:
> On Sun, Aug 28, 2011 at 1:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> >> > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> >> > loaded from userspace, so it needs to be built into the kernel as well.
> >>
> >> How should I do that? I've tried to set all "m"s to "y" in .config and
> >> still saw this issue. Should I set some special parameter?
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
> Everything else in /lib/firmware/radeon is needed after user space
> become available?

You mean the other *.bin files? If so, not for your case, AFAICT - your
driver is requesting CEDAR_pfp.bin only, correct? But I mean, it won't
hurt if you leave them all there, they're under 1M.

You should recheck and add any other .bin files to the
CONFIG_EXTRA_FIRMWARE string so that radeon.ko is satisfied :).

HTH.

-- 
Regards/Gruss,
    Boris.
