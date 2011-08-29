Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1H2NUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:20:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1H2NUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:20:30 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 29 Aug 2011 15:20:21 +0200
In-Reply-To: <20110828053624.GC12851@liondog.tnic>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
	 <1314435638.2321.12.camel@thor.local>
	 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
	 <20110828053624.GC12851@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314624021.2816.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-28 at 07:36 +0200, Borislav Petkov wrote:
> > > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> > > loaded from userspace, so it needs to be built into the kernel as well.
> > 
> > How should I do that? I've tried to set all "m"s to "y" in .config and
> > still saw this issue. Should I set some special parameter?
> 
> You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
> configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
> 
> The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
> most probably be located in /lib/firmware or to whatever you have set
> CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
> a warning at the end of the kernel build). This way, it works for both
> radeon being =m and =y.

Should we make Kconfig pop up a dialog and ask for the whereabouts of
these firmware thingies when you mark the driver =y? 

This all sounds like magic to me, having to know you need to add to
EXTRA_FIRMWARE, having to know what file it needs etc.. For all intents
and purposes =y just doesn't work and that's broken.
