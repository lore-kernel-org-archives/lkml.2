Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2AYVwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:52:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59650 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2AYVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:52:46 -0500
Date: Wed, 25 Jan 2012 22:52:45 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection
 for intel_dp_link_required
Message-ID: <20120125215245.GJ3896@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Lubos Kolouch <lubos.kolouch@gmail.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
 <1327508186-26704-2-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
In-Reply-To: <1327508186-26704-2-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 08:16:25AM -0800, Keith Packard wrote:
> It is never correct to use intel_crtc->bpp in intel_dp_link_required,
> so instead pass an explicit bpp in to this function. This patch
> only supports 18bpp and 24bpp modes, which means that 10bpc modes will
> be computed incorrectly. Fixing that will require more extensive
> changes, and so must be addressed separately from this bugfix.
> 
> intel_dp_link_required is called from intel_dp_mode_valid and
> intel_dp_mode_fixup.
> 
> * intel_dp_mode_valid is called to list supported modes; in this case,
>   the current crtc values cannot be relevant as the modes in question
>   may never be selected. Thus, using intel_crtc->bpp is never right.
> 
> * intel_dp_mode_fixup is called during mode setting, but it is run
>   well before ironlake_crtc_mode_set is called to set intel_crtc->bpp,
>   so using intel_crtc-bpp in this path can only ever get a stale
>   value.
> 
> Cc: Lubos Kolouch <lubos.kolouch@gmail.com>
> Cc: Adam Jackson <ajax@redhat.com>
> Signed-off-by: Keith Packard <keithp@keithp.com>

Afaics this is correct and should fix quite a few "dp doesn't light up
issue" (in combination with 6bpc auto-dither code that's already there). I
think all the open issues are only about how to make this less
pessimistic and more generic, i.e. patch 2.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
