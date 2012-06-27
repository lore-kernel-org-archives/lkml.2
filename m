Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2F0LgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:36:15 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64351 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2F0LgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:36:14 -0400
Date: Wed, 27 Jun 2012 13:36:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915/sprite: Fix mem leak in intel_plane_init()
Message-ID: <20120627113608.GC5326@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
References: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
 <20120626171246.4c385996@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626171246.4c385996@jbarnes-desktop>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 05:12:46PM -0700, Jesse Barnes wrote:
> On Wed, 27 Jun 2012 00:55:37 +0200 (CEST)
> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > If we ever hit the default case in the switch statement we'll return
> > from the function without freeing the memory we just allocated to
> > 'intel_plane' (but that has not been used).
> > 
> > This patch gets rid of the leak by freeing the memory just before we
> > return.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/gpu/drm/i915/intel_sprite.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
> > index 2a20fb0..c8851ba 100644
> > --- a/drivers/gpu/drm/i915/intel_sprite.c
> > +++ b/drivers/gpu/drm/i915/intel_sprite.c
> > @@ -685,6 +685,7 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
> >  		break;
> >  
> >  	default:
> > +		kfree(intel_plane);
> >  		return -ENODEV;
> >  	}
> >  
> > @@ -699,4 +700,3 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
> >  
> >  	return ret;
> >  }
> 
> Yeah, looks fine.  I just fixed the same thing in a local tree (though
> by using a goto since I added another path that could fail).
> 
> Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
