Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2CZPHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:07:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2CZPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:07:53 -0400
Date: Mon, 26 Mar 2012 17:08:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 02/11 v3] drm/i915/intel_i2c: assign HDMI port D to pin
 pair 6
Message-ID: <20120326150835.GQ4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-3-git-send-email-djkurtz@chromium.org>
 <20120326144711.GO4014@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326144711.GO4014@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 04:47:11PM +0200, Daniel Vetter wrote:
> On Mon, Mar 26, 2012 at 10:26:41PM +0800, Daniel Kurtz wrote:
> > According to i915 documentation [1], "Port D" (DP/HDMI Port D) is
> > actually gmbus pin pair 6 (gmbus0.2:0 == 110b GPIOF), not 7 (111b).
> > Pin pair 7 is a reserved pair.
> > 
> > [1] Documentation for [DevSNB+] and [DevIBX], as found on
> > http://intellinuxgraphics.org
> > 
> > Note: the "reserved" and "disabled" pairs do not actually map to a
> > physical pair of pins, nor GPIO regs and shouldn't be initialized or used.
> > Fixing this is left for a later patch.
> > 
> > This bug has not been noticed for two reasons:
> >  1) "gmbus" mode is currently disabled - all transfers are actually using
> >     "bit-bang" mode which uses the GPIO port 5 (the "HDMI/DPD CTLDATA/CLK"
> >     pair), at register 0x5024 (defined as GPIOF i915_reg.h).
> >     Since this is the correct pair of pins for HDMI1, transfers succeed.
> 
> ... this is no longer true on drm-intel-next.
> 
> >  2) Even if gmbus mode is re-enabled, the first attempted transaction
> >     will fail because it tries to use the wrong ("Reserved") pin pair.
> >     However, the driver immediately falls back again to the bit-bang
> >     method, which correctly uses GPIOF, so again, transfers succeed.
> > 
> > However, if gmbus mode is re-enabled and the GPIO fall-back mode is
> > disabled, then reading an attached monitor's EDID fail.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> Otherwise this looks ok to me - I've checked with gen3 Bspec and we seem
> to indeed have a 1:1 mapping, see "Display Registers", 1.5.3 "GPIO Control
> Registers", the list right below the heading.

well, scrap that, I've confused myself here a bit. Afaict we don't
actually use these gmbus ports on earlier chips.
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> When resending, can you please add the Bspec reference above?

Can you you instead add a clear reference (Volume, Full Section plus
Heading Title) for the Snb/Ibx public Bspec.

Thanks, Daneil
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
