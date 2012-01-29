Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2A2POW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 10:14:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64796 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2A2POV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 10:14:21 -0500
Date: Sun, 29 Jan 2012 16:14:21 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        Takashi Iwai <tiwai@suse.de>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [PATCH][rebased] drm/i915: set AUD_CONFIG N_value_index for
 DisplayPort
Message-ID: <20120129151421.GC4312@phenom.ffwll.local>
Mail-Followup-To: Wu Fengguang <fengguang.wu@intel.com>,
	Keith Packard <keithp@keithp.com>, Takashi Iwai <tiwai@suse.de>,
	"intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
	Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
	Robert Lemaire <rlemaire@suse.com>
References: <20120110054519.GA27257@localhost>
 <86ty404yhd.fsf@sumi.keithp.com>
 <20120116080252.GA18538@localhost>
 <20120116202618.GG3627@phenom.ffwll.local>
 <86obu31io4.fsf@sumi.keithp.com>
 <20120116230809.GA7837@localhost>
 <20120117102203.GC4093@phenom.ffwll.local>
 <20120129044423.GA26244@localhost>
 <CAKMK7uFSv=SO-a+4o8Nga75U6uOAp=TqUP6dU=-38n3ntxtdpQ@mail.gmail.com>
 <20120129132326.GA4123@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120129132326.GA4123@localhost>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 09:23:26PM +0800, Wu Fengguang wrote:
> > > Daniel, this is now based on linux-next. I use quilt, hope it also
> > > works for you :)
> > 
> > On a quick check this patch is missing the hunk to actually write the
> > aud configuration into the register. I presume that's not intentional,
> > so can you please resend?
> 
> This is weird, my outbox has the below chunk. Anyway here is the
> attached patch.
> 
> @@ -6107,7 +6111,9 @@ static void ironlake_write_eld(struct dr
>         if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
>                 DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
>                 eld[5] |= (1 << 2);     /* Conn_Type, 0x1 = DisplayPort */
> -       }
> +               I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 = DP */
> +       } else
> +               I915_WRITE(aud_config, 0);
>         
> Thanks,
> Fengguang

Yeah, the hunk is here, too ... Looks like I've failed with wrestling the
quilt patch a bit, sorry for the noise. But I think I've got the handle on
that now. So queued for -next, thanks for the patch.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
