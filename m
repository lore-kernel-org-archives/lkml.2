Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1I3Q1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:27:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33106 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1I3Q1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:27:39 -0400
Date: Fri, 30 Sep 2011 18:20:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 02/21] drm/i915: Shut down PCH interrupts during
 irq_uninstall
Message-ID: <20110930162048.GB2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-3-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-3-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:34PM -0700, Keith Packard wrote:
> This masks out all interrupts and ack's any pending ones at IRQ
> uninstall time to make sure we don't receive any unexpected interrupts
> later on.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_irq.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index c22823b..adeab2a 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -2044,6 +2044,10 @@ static void ironlake_irq_uninstall(struct drm_device *dev)
>  	I915_WRITE(GTIMR, 0xffffffff);
>  	I915_WRITE(GTIER, 0x0);
>  	I915_WRITE(GTIIR, I915_READ(GTIIR));
> +
> +	I915_WRITE(SDEIMR, 0xffffffff);
> +	I915_WRITE(SDEIER, 0x0);
> +	I915_WRITE(SDEIIR, I915_READ(SDEIIR));
>  }

Shouldn't we mask/ack south DE irqs before before we mask DE irqs to avoid
races, i.e.  move this new code up?
-Daniel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
