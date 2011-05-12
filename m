Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1ELVl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:41:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:21574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab1ELVl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:41:56 -0400
Message-Id: <72a37e$j47ear@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,360,1301900400"; 
   d="scan'208";a="641972571"
Date: Thu, 12 May 2011 22:41:52 +0100
To: Melchior FRANZ <melchior.franz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.39 regression] i915/kms: garbled screen because of 49183b281  (was: Re: Linux 2.6.39-rc7)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com> <201105121849.09225@rk-nord.at>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201105121849.09225@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 18:49:08 +0200, Melchior FRANZ <melchior.franz@gmail.com> wrote:
> * Linus Torvalds -- Tuesday 10 May 2011:
> > But please do test, just to make sure that 39-final is good.
> 
> > Chris Wilson (4):
> >       drm/i915: Only enable the plane after setting the fb base (pre-ILK)
> 
> This patch introduces a bug on my infamous "Acer Travelmate
> 5735Z-452G32Mnss": when KMS takes over, the frame buffer contents
> get completely garbled up on screen, with colored stripes and
> unreadable text (photo on request). Only when X11 is started, the
> screen gets restored again. Closing and re-opening the lid partly
> cures the mess, too: it makes the font readable, though horizontally
> stretched.

So we think that enabling the plane at this point is masking a bug in our
modeset, or that some side-effect of writing those registers or waiting
for that vblank has a vital latching or delay that we have not accounted
for.

Can you please grab intel_reg_dumper from 

  http://cgit.freedesktop.org/xorg/app/intel-gpu-tools

and attach its output after passing nomodeset on your kernel boot
parameters (without starting X). That should capture the registers as they
were left by the BIOS. Alternatively, if you load i915.ko as a module, you
can run intel_reg_dumper before loading the module. Then can you attach
the output from intel_reg_dumper from the VT before starting X (whilst the
display is skewiff) and then after (when the display has recovered). That
may help, unless we are right in that it is in the timing of the register
writes.

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
