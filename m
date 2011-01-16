Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1APLQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 06:16:23 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58130 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab1APLQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 06:16:22 -0500
Date: Sun, 16 Jan 2011 13:16:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: fixup headers_check
Message-ID: <20110116111616.GC2456@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1295174783-4099-1-git-send-email-balbi@ti.com>
 <0d30dc$kp159h@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$kp159h@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 11:07:32AM +0000, Chris Wilson wrote:
> On Sun, 16 Jan 2011 12:46:22 +0200, Felipe Balbi <balbi@ti.com> wrote:
> > Drop the following headers_check errors:
> > /linux-2.6/usr/include/drm/drm_mode.h:85: found
> > __[us]{8,16,32,64} type without #include <linux/types.h>
> > /linux-2.6/usr/include/drm/i915_drm.h:120: found
> > __[us]{8,16,32,64} type without #include <linux/types.h>
> > /linux-2.6/usr/include/drm/mga_drm.h:260: found
> > __[us]{8,16,32,64} type without #include <linux/types.h>
> > /linux-2.6/usr/include/drm/radeon_drm.h:758: found
> > __[us]{8,16,32,64} type without #include <linux/types.h>
> > /linux-2.6/usr/include/drm/via_drm.h:117: found
> > __[us]{8,16,32,64} type without #include <linux/types.h>
> > 
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  include/drm/drm_mode.h   |    2 ++
> >  include/drm/i915_drm.h   |    1 +
> >  include/drm/mga_drm.h    |    1 +
> >  include/drm/radeon_drm.h |    1 +
> >  include/drm/via_drm.h    |    1 +
> >  5 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> > index 0fc7397..1678d7b 100644
> > --- a/include/drm/drm_mode.h
> > +++ b/include/drm/drm_mode.h
> > @@ -27,6 +27,8 @@
> >  #ifndef _DRM_MODE_H
> >  #define _DRM_MODE_H
> >  
> > +#include <linux/types.h>
> > +
> 
> Would
> 
> #if 0
> #include <linux/types.h> /* silence make header_check */
> #endif
> 
> be an acceptable compromise?

Why would you want to do that ? I truly have those types in use.
headers_check seems to be reporting correctly.

-- 
balbi
