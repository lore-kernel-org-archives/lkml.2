Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1AWJdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 04:33:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63501 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1AWJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 04:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=sIjk28IiF73k0PvOi2ai6/QxNObCqMRKzTXYNF4F+ZCNUTEqZucKtmWcjKm4RLNBPT
         FSLSkqRrfLkdqKMKWeHUkat/EuPuZxcEyB/k11Z5x++yDBTn3YoFKp9R4E4WIN4xN/hs
         j+biJTtqTLbVL9HWmYHBsbhFlsiwaFe0wTCKo=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Date: Sun, 23 Jan 2011 09:32:49 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <:201101220935.03623.chris2553@googlemail.com> <0d30dc$kr3ing@orsmga001.jf.intel.com> <201101230856.42744.chris2553@googlemail.com>
In-Reply-To: <201101230856.42744.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101230932.49998.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 January 2011, Chris Clayton wrote:
> On Saturday 22 January 2011, Chris Wilson wrote:
> > On Sat, 22 Jan 2011 11:18:53 +0000, Chris Clayton
> > <chris2553@googlemail.com>
>
> wrote:
> > > On Saturday 22 January 2011, Chris Wilson wrote:
> > > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > > ---
> > > >
> > > > Chris, does this help?
> > >
> > > Sorry Chris, X still doesn't start with this patch applied. The
> > > symptoms are slightly different in that the monitor doesn't go into
> > > power saving mode, but the screen is still black and I have to recycle
> > > the power to get the machine back.
> > > The messages in the log file has changed though.We now have:
> >
> > Despite appearances to the contrary, it is a step forward. We have the
> > crash under control, and now need to tackle the underlying problem.
> >
> > However, I'm worried by the fact that no CRTCs are attached. Is this not
> > using KMS?
>
> No KMS is not configured in. I found that under an earlier version of the
> kernel it caused my kernel to lock up, so I configured it out. I meant to
> investigate further and report it, but then forgot. I'll turn KMS on and
> report the outcome.
>

Mmmm, I get a lock up when turning KMS on in 2.3.38-rc2+ and it looks like KMS 
is inducing a crash in X. The Xorg log contains:

Backtrace:
0: /usr/X11/bin/X(xorg_backtrace+0x3b) [0x81352db]
1: /usr/X11/bin/X(xf86SigHandler+0x51) [0x80ba0b1]
2: [0xb78b5400]
3: /usr/X11R6/lib/libdrm_intel.so.1(+0x624b) [0xb72d024b]
4: /usr/X11R6/lib/libdrm_intel.so.1(drm_intel_bo_unreference+0x16) [0xb72cb446]
5: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(intel_batch_flush+0xb6) 
[0xb72ec876]
6: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(+0x4b5d0) [0xb73215d0]
7: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(uxa_fill_region_tiled+0x264) 
[0xb7338fc4]
8: /usr/X11/lib/xorg/modules/drivers//intel_drv.so(+0x6343b) [0xb733943b]
9: /usr/X11/bin/X() [0x817b8c6]
10: /usr/X11/bin/X(miPaintWindow+0x1cb) [0x811484b]
11: /usr/X11/bin/X(miWindowExposures+0xbf) [0x8114bbf]
12: /usr/X11/bin/X() [0x80b364f]
13: /usr/X11/bin/X(MapWindow+0x3a8) [0x8072cc8]
14: /usr/X11/bin/X(InitRootWindow+0x10c) [0x8072dfc]
15: /usr/X11/bin/X(main+0x40a) [0x806be0a]
16: /lib/libc.so.6(__libc_start_main+0xe6) [0xb7412b86]
17: /usr/X11/bin/X() [0x806b2c1]

Fatal server error:
Caught signal 11.  Server aborting

and the kernel log contains:

Jan 23 09:07:38 upstairs kernel: X[1273]: segfault at 3fe8 ip b72ebc95 sp 
bfdbf4b0 error 6 in intel_drv.so[b72d6000+76000]

So it looks like there are two problems. I'm happy to help fix both, but would 
prefer to get the non-KMS setup working first, so that I can run the 
development kernel to see if I find any other problems. Once the graphics mode 
has been switched, the text on the screen as the kernel boots is so small, that 
my old eyes struggle to see it, so normally I will probably run without KMS, as 
long as that is supported.

<snip>

Chris
-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
