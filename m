Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2APU00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:26:26 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42354 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2APU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:26:23 -0500
Date: Mon, 16 Jan 2012 21:26:18 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Keith Packard <keithp@keithp.com>, Takashi Iwai <tiwai@suse.de>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: set AUD_CONFIG N_value_index for
 DisplayPort
Message-ID: <20120116202618.GG3627@phenom.ffwll.local>
Mail-Followup-To: Wu Fengguang <fengguang.wu@intel.com>,
	Keith Packard <keithp@keithp.com>, Takashi Iwai <tiwai@suse.de>,
	"intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
	Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
	Robert Lemaire <rlemaire@suse.com>
References: <20120109131717.GA4713@localhost>
 <86y5tgx02g.fsf@sumi.keithp.com>
 <20120110054519.GA27257@localhost>
 <86ty404yhd.fsf@sumi.keithp.com>
 <20120116080252.GA18538@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116080252.GA18538@localhost>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 04:02:53PM +0800, Wu Fengguang wrote:
> On Thu, Jan 12, 2012 at 09:33:34AM -0800, Keith Packard wrote:
> > On Tue, 10 Jan 2012 13:45:19 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > @@ -5943,6 +5947,7 @@ static void ironlake_write_eld(struct dr
> > >  	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
> > >  		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
> > >  		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
> > > +		I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 = DP */
> > >  	}
> > 
> > Do we need to clear this bit in the HDMI case? Or do we just trust the
> > BIOS to either leave this bit zero or set it correctly?
> 
> I tried booting
> 
> 1) with HDMI monitor plugged
> 2) plug HDMI monitor after BIOS boot
> 
> In both cases, I get the same AUD_CONFIG values for the host/sink matrix
> 
>                 RX-V1800        SONY TV
> ivybridge       0x00000000      0x00000000
> ironlake        0x00000000      0x00000000
> 
> HDMI audio is working fine in all cases. So I guess it's fine to leave
> HDMI as (unconfigured) 0.

Keith, does this address your concern and this patch is r-b: Keith or do
we want an

} else {
	I915_WRITE(aud_config, 0);
}

for paranoia?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
