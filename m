Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1AWI46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 03:56:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1AWI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 03:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZGOShuPJr1CrvSEcyRGmp64AS2WH70e1PMqGQmschD/Zq5fGm467a3jBOkcW/sgDrJ
         yRh6HEdxSw34p9PYZ7dFgGFlSjR2WHb8eGCidMUJMV/sOYaL6BNz4u+ysYtfYG8+YRsW
         vvq+LCCObFBcsxaMbH8q7uysB0akUoPZNItNM=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Date: Sun, 23 Jan 2011 08:56:42 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <:201101220935.03623.chris2553@googlemail.com> <201101221118.53141.chris2553@googlemail.com> <0d30dc$kr3ing@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$kr3ing@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101230856.42744.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 January 2011, Chris Wilson wrote:
> On Sat, 22 Jan 2011 11:18:53 +0000, Chris Clayton <chris2553@googlemail.com> 
wrote:
> > On Saturday 22 January 2011, Chris Wilson wrote:
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > ---
> > >
> > > Chris, does this help?
> >
> > Sorry Chris, X still doesn't start with this patch applied. The symptoms
> > are slightly different in that the monitor doesn't go into power saving
> > mode, but the screen is still black and I have to recycle the power to
> > get the machine back.
> > The messages in the log file has changed though.We now have:
>
> Despite appearances to the contrary, it is a step forward. We have the
> crash under control, and now need to tackle the underlying problem.
>
> However, I'm worried by the fact that no CRTCs are attached. Is this not
> using KMS?
>

No KMS is not configured in. I found that under an earlier version of the kernel 
it caused my kernel to lock up, so I configured it out. I meant to investigate 
further and report it, but then forgot. I'll turn KMS on and report the 
outcome.

> > > If you can convert the address to a line number that would pinpoint the
> >
> > Not done that before and nothing jumped out of my search on google, so
> > how do I go about getting the line number for you, please?
>
> Something like:
>
> $ gdb drivers/gpu/drm/drm.ko
> (gdb) list *drm_calc_vbltimestamp_from_scanoutpos+0x3e
>
> should do the trick (if compiled as a module, vmlinux otherwise)

Thanks for the tutoring. I get

(gdb) list *drm_calc_vbltimestamp_from_scanoutpos+0x3e
0x6afe is in drm_calc_vbltimestamp_from_scanoutpos 
(drivers/gpu/drm/drm_irq.c:590).
585                     DRM_ERROR("Called from driver w/o 
get_scanout_position()!?\n");
586                     return -EIO;
587             }
588
589             mode = &refcrtc->hwmode;
590             vtotal = mode->crtc_vtotal;
591             vdisplay = mode->crtc_vdisplay;
592
593             /* Durations of frames, lines, pixels in nanoseconds. */
594             framedur_ns = refcrtc->framedur_ns;


Chris
> -Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
