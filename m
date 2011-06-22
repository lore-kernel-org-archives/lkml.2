Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab1FVTE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:04:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58392 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758730Ab1FVTE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:04:56 -0400
Date: Wed, 22 Jun 2011 15:04:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Keith Packard <keithp@keithp.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: Oops in i915 intel_init_clock_gating
In-Reply-To: <yun4o3h68gs.fsf@aiko.keithp.com>
Message-ID: <Pine.LNX.4.44L0.1106221504070.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Keith Packard wrote:

> On Wed, 15 Jun 2011 13:32:56 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> > index 0defd42..a1a28fb 100644
> > --- a/drivers/gpu/drm/i915/i915_drv.c
> > +++ b/drivers/gpu/drm/i915/i915_drv.c
> > @@ -429,6 +429,9 @@ static int i915_drm_thaw(struct drm_device *dev)
> >  	/* KMS EnterVT equivalent */
> >  	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> >  		mutex_lock(&dev->struct_mutex);
> > +
> > +		intel_init_clock_gating(dev);
> > +
> >  		dev_priv->mm.suspended = 0;
> >  
> >  		error = i915_gem_init_ringbuffer(dev);
> > diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
> > index 60a94d2..b478d16 100644
> > --- a/drivers/gpu/drm/i915/i915_suspend.c
> > +++ b/drivers/gpu/drm/i915/i915_suspend.c
> > @@ -863,8 +863,6 @@ int i915_restore_state(struct drm_device *dev)
> >  		I915_WRITE(IMR, dev_priv->saveIMR);
> >  	}
> >  
> > -	intel_init_clock_gating(dev);
> > -
> >  	if (IS_IRONLAKE_M(dev)) {
> >  		ironlake_enable_drps(dev);
> >  		intel_init_emon(dev);
> > 
> 
> I haven't seen any comments as to whether this patch needs to be merged
> into the kernel. Has anyone tested this?

I have tested it, and it worked well on my system:

	http://marc.info/?l=linux-kernel&m=130817292323254&w=2

Alan Stern

