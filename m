Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2HMOO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:14:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49089 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2HMOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:14:55 -0400
Date: Mon, 13 Aug 2012 16:15:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: George Spelvin <linux@horizon.com>
Cc: ben@bwidawsk.net, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: v3.5  Oops in i2c_algo_bit.c:bit_xfer+0x23/0x870: i915 or i2c?
Message-ID: <20120813141513.GC5248@phenom.ffwll.local>
Mail-Followup-To: George Spelvin <linux@horizon.com>, ben@bwidawsk.net,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <e6945e875aa0667550285cd5da6d473f@bwidawsk.net>
 <20120813034922.24517.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813034922.24517.qmail@science.horizon.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 11:49:22PM -0400, George Spelvin wrote:
> (Bringing this back to the mailing lists after a bit of uninteresting private
> conversation.)
> 
> > Honestly, I think we need a way to force disable gmbus with a module 
> > parameter or something anyway. It's not the first time gmbus has been 
> > implicated with an issue. Maybe it even exists already, but I couldn't 
> > find this. So if you confirm that fixes the problem for you on the ml, 
> > at least maybe such a patch will be the result.
> >
> > If you feel it's a software bug (which I agree it seems likely), a
> > bisect is always much appreciated. Personally, I'll usually step back
> > major releases until something works, or I hit 3.2ish. Even knowing it
> > never worked through 3.2 is helpful.
> 
> It's a friend's machine, which I normally only have remote access to,
> so it's a bit pf a pain, but I can manage.  I just thought a basic
> i3 motherboard was so common I couldn't possibly be the only one with
> this problem.
> 
> Here's the 3.2 dmesg showing the fallback working, but this is an
> Ubuntu-patched kernel (linux-image-3.2.0-29-generic) that may be a fair
> distance from stock:

One thing of interest would be the exact .config you use to build the
kernel and the output of lsmod (after the kernel crashed). I guess the
issue is with the combination of drivers you have (i2c_detect in the
calltrace calls back into other registered i2c drivers ...).

Yours, Daniel

> 
> [   44.401124] [drm] Initialized drm 1.1.0 20060810
> [   44.471549] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   44.471553] i915 0000:00:02.0: setting latency timer to 64
> [   44.555865] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.611882] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.667876] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.723831] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.779841] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.835854] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.895843] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   44.951836] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus disabled]
> [   45.007798] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.063716] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.119776] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.175716] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.231689] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.287696] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.343704] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.399667] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus ssc]
> [   45.455651] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.511629] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.567581] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.623645] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.679546] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.735614] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.791596] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.847533] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus vga]
> [   45.903517] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   45.959547] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.015492] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.071473] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.127430] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.183447] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.239425] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.295407] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus panel]
> [   46.351401] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.407382] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.463363] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.519347] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.575302] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.631320] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.687360] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.743300] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpc]
> [   46.799250] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   46.855292] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   46.911250] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   46.967250] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   47.023258] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   47.079206] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   47.135232] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   47.191163] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpb]
> [   47.247148] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.303186] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.359091] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.415157] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.471062] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.527121] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.583087] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.639092] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus reserved]
> [   47.695081] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   47.751011] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   47.810995] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   47.867014] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   47.923009] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   47.978921] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   48.034954] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   48.090936] [drm] GMBUS timed out, falling back to bit banging on pin 0 [i915 gmbus dpd]
> [   48.091142] i915 0000:00:02.0: irq 49 for MSI/MSI-X
> [   48.091147] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   48.091148] [drm] Driver supports precise vblank timestamp query.
> [   48.091182] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   48.511902] fbcon: inteldrmfb (fb0) is primary device
> [   48.852752] Console: switching to colour frame buffer device 240x67
> [   48.857087] fb0: inteldrmfb frame buffer device
> [   48.857088] drm: registered panic notifier
> [   48.857205] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
