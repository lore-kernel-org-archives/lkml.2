Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1AFUz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:55:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39803 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1AFUzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jm1jsi6GMvRe0LDZqDrNGxMal8AD4dMVt6r77sUPRwABuywi6AdaeMYJat+kcpLLWj
         bhs5ypguRJT1uWk6lW3V5nR5U6oGg4sJ4+/ddUs9KxEnZnSbjTE9CUVc6IkEpqv98G9P
         3iv1q/Dot17B0iqrJnr0K5kfyQck/HgL7o060=
MIME-Version: 1.0
In-Reply-To: <1bdc18$j6a1ns@fmsmga002.fm.intel.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
	<20110106104816.GA4026@tiehlicka.suse.cz>
	<AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
	<1bdc18$j6a1ns@fmsmga002.fm.intel.com>
Date: Thu, 6 Jan 2011 21:55:23 +0100
Message-ID: <AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
Subject: Re: Linux 2.6.37
From: Alex Riesen <raa.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 18:49, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> My fear is that some machines have a dependency between the backlight
> and panel power status. The patch in question changed the timing between
> turning on the panel and adjusting the backlight which would be restore
> with:
>
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index aa23070..0b40b4f 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -106,6 +106,12 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
>        I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
>        POSTING_READ(lvds_reg);
>
> +       {
> +               u32 reg = HAS_PCH_SPLIT(dev) ? PCH_PP_STATUS : PPS_STATUS;
> +               if (wait_for(I915_READ(reg) & PP_ON, 1000))
> +                       DRM_ERROR("timed out waiting for panel to power up\n");
> +       }
> +
>        intel_panel_set_backlight(dev, dev_priv->backlight_level);
>  }

FWIW it does not compile:
  CC      drivers/gpu/drm/i915/intel_lvds.o
drivers/gpu/drm/i915/intel_lvds.c: In function ‘intel_lvds_enable’:
drivers/gpu/drm/i915/intel_lvds.c:110: error: ‘PPS_STATUS’ undeclared
(first use in this function)
drivers/gpu/drm/i915/intel_lvds.c:110: error: (Each undeclared
identifier is reported only once
drivers/gpu/drm/i915/intel_lvds.c:110: error: for each function it appears in.)
make[4]: *** [drivers/gpu/drm/i915/intel_lvds.o] Error 1
