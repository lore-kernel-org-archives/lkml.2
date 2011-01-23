Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1AWKxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 05:53:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:17342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1AWKw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 05:52:59 -0500
Message-Id: <b7da2f$q7auf0@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,365,1291622400"; 
   d="scan'208";a="880114144"
Date: Sun, 23 Jan 2011 10:52:56 +0000
To: chris2553@googlemail.com
Subject: Re: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Cc: linux-kernel@vger.kernel.org
References: <:201101220935.03623.chris2553@googlemail.com> <0d30dc$kr3ing@orsmga001.jf.intel.com> <201101230856.42744.chris2553@googlemail.com> <201101230932.49998.chris2553@googlemail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201101230932.49998.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 09:32:49 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> On Sunday 23 January 2011, Chris Clayton wrote:
> > On Saturday 22 January 2011, Chris Wilson wrote:
> > > On Sat, 22 Jan 2011 11:18:53 +0000, Chris Clayton
> > > <chris2553@googlemail.com>
> >
> > wrote:
> > > > On Saturday 22 January 2011, Chris Wilson wrote:
> > > > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > > > ---
> > > > >
> > > > > Chris, does this help?
> > > >
> > > > Sorry Chris, X still doesn't start with this patch applied. The
> > > > symptoms are slightly different in that the monitor doesn't go into
> > > > power saving mode, but the screen is still black and I have to recycle
> > > > the power to get the machine back.
> > > > The messages in the log file has changed though.We now have:
> > >
> > > Despite appearances to the contrary, it is a step forward. We have the
> > > crash under control, and now need to tackle the underlying problem.
> > >
> > > However, I'm worried by the fact that no CRTCs are attached. Is this not
> > > using KMS?
> >
> > No KMS is not configured in. I found that under an earlier version of the
> > kernel it caused my kernel to lock up, so I configured it out. I meant to
> > investigate further and report it, but then forgot. I'll turn KMS on and
> > report the outcome.
> >
> 
> Mmmm, I get a lock up when turning KMS on in 2.3.38-rc2+ and it looks like KMS 
> is inducing a crash in X. The Xorg log contains:
> 
> Backtrace:
> 0: /usr/X11/bin/X(xorg_backtrace+0x3b) [0x81352db]
> 1: /usr/X11/bin/X(xf86SigHandler+0x51) [0x80ba0b1]
> 2: [0xb78b5400]
> 3: /usr/X11R6/lib/libdrm_intel.so.1(+0x624b) [0xb72d024b]
> 4: /usr/X11R6/lib/libdrm_intel.so.1(drm_intel_bo_unreference+0x16) [0xb72cb446]
> 5: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(intel_batch_flush+0xb6) 
> [0xb72ec876]
> 6: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(+0x4b5d0) [0xb73215d0]
> 7: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(uxa_fill_region_tiled+0x264) 
> [0xb7338fc4]
> 8: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(+0x6343b) [0xb733943b]
> 9: /usr/X11/bin/X() [0x817b8c6]
> 10: /usr/X11/bin/X(miPaintWindow+0x1cb) [0x811484b]
> 11: /usr/X11/bin/X(miWindowExposures+0xbf) [0x8114bbf]
> 12: /usr/X11/bin/X() [0x80b364f]
> 13: /usr/X11/bin/X(MapWindow+0x3a8) [0x8072cc8]
> 14: /usr/X11/bin/X(InitRootWindow+0x10c) [0x8072dfc]
> 15: /usr/X11/bin/X(main+0x40a) [0x806be0a]
> 16: /lib/libc.so.6(__libc_start_main+0xe6) [0xb7412b86]
> 17: /usr/X11/bin/X() [0x806b2c1]

This looks more like typical memory corruption, and the usual requests to
make sure you have the latest stable drivers apply: Xorg-1.9,
xf86-video-intel-2.14, libdrm-2.4.23, [mesa-7.10].
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
