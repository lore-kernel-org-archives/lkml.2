Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2AQKWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:22:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33090 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2AQKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:22:08 -0500
Date: Tue, 17 Jan 2012 11:22:03 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel@ffwll.ch>,
        Takashi Iwai <tiwai@suse.de>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: set AUD_CONFIG N_value_index for
 DisplayPort
Message-ID: <20120117102203.GC4093@phenom.ffwll.local>
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
 <20120116202618.GG3627@phenom.ffwll.local>
 <86obu31io4.fsf@sumi.keithp.com>
 <20120116230809.GA7837@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116230809.GA7837@localhost>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 07:08:09AM +0800, Wu Fengguang wrote:
> On Mon, Jan 16, 2012 at 12:44:43PM -0800, Keith Packard wrote:
> > On Mon, 16 Jan 2012 21:26:18 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> > 
> > > Keith, does this address your concern and this patch is r-b: Keith or do
> > > we want an
> > > 
> > > } else {
> > > 	I915_WRITE(aud_config, 0);
> > > }
> > > 
> > > for paranoia?
> > 
> > I think we want this added, just to be sure we set the configuration
> > correctly in all cases; it's easy to imagine moving from DP to HDMI and
> > leaving this bit set.
> 
> Ah good point! Here is the updated patch.
> 
> ---
> Subject: drm/i915: set AUD_CONFIG N_value_index for DisplayPort
> Date: Fri Jan 06 14:41:31 CST 2012
> 
> It should be programmed to "0" for HDMI or "1" for DisplayPort.
> 
> This enables DisplayPort audio for
> 
> - HP EliteBook 8460p
>   (whose BIOS does not set the N_value_index bit for us)
> 
> - DisplayPort monitor hot plugged after boot
>   (otherwise most BIOS will fill the N_value_index bit for us)
> 
> Tested-by: Robert Lemaire <rlemaire@suse.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

I've tried to apply this patch but it has a conflict in i915_reg.h (with
the SOL reset stuff). Care to rebase and resend? Also, git patches as
produced by git format-patch highly preferred.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
