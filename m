Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2FCPPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 11:15:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2FCPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 11:15:49 -0400
Date: Sun, 3 Jun 2012 17:17:15 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Jones <davej@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Rob Clark <rob.clark@linaro.org>
Subject: Re: Lots of i915/drm spew on 3.4
Message-ID: <20120603151715.GB4696@phenom.ffwll.local>
Mail-Followup-To: Paulo Zanoni <przanoni@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Rob Clark <rob.clark@linaro.org>
References: <20120530213128.GA10407@redhat.com>
 <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
 <20120530215848.GB19223@redhat.com>
 <20120530222651.GA22449@redhat.com>
 <1338451231_375838@CP5-2952>
 <CA+gsUGTP5S9Az5oHMxYgyJbDPv9R7gRoC614RW0OLk7_TBeDZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+gsUGTP5S9Az5oHMxYgyJbDPv9R7gRoC614RW0OLk7_TBeDZQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 10:22:28AM -0300, Paulo Zanoni wrote:
> 2012/5/31 Chris Wilson <chris@chris-wilson.co.uk>:
> > Before that commit we had no idea that we had run out of property slots.
> > I think the WARN is genuine, but maybe we should just bump the count set
> > it to WARN_ONCE and hope the conversion to lists arrives sooner rather
> > than latter.
> > -Chris
> >
> 
> Chris is right: this is not a regression. Before that patch, no one
> checked if property creation really worked. I chose not to use
> WARN_ONCE because we need to increase the variable once for each time
> you see the message. Assuming this message appears on your log less
> than 8 times, does this patch fix your problem?
> 
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index 73e4560..bac55c2 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -54,7 +54,7 @@ struct drm_mode_object {
>         struct drm_object_properties *properties;
>  };
> 
> -#define DRM_OBJECT_MAX_PROPERTY 16
> +#define DRM_OBJECT_MAX_PROPERTY 24
>  struct drm_object_properties {
>         int count;
>         uint32_t ids[DRM_OBJECT_MAX_PROPERTY];

I've hit the same warn on my g33 with a tv-out sdvo. Seems to be enough to
shut it up.

Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
