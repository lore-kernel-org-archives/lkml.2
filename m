Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0L2Xme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:42:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23094 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0L2Xmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:42:33 -0500
Date: Wed, 29 Dec 2010 15:40:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-Id: <20101229154053.a3036c53.randy.dunlap@oracle.com>
In-Reply-To: <20101229144614.484b64ef@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<20101229141253.5ff91e3e.randy.dunlap@oracle.com>
	<20101229144614.484b64ef@jbarnes-desktop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 14:46:14 -0800 Jesse Barnes wrote:

> > > diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
> > > index 2b20786..d27d016 100644
> > > --- a/drivers/gpu/drm/i915/intel_bios.c
> > > +++ b/drivers/gpu/drm/i915/intel_bios.c
> > > @@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
> > >                 dev_priv->int_tv_support = general->int_tv_support;
> > >                 dev_priv->int_crt_support = general->int_crt_support;
> > >                 dev_priv->lvds_use_ssc = general->enable_ssc;
> > > +               /* force disable until we can parse this correctly */
> > > +               if (IS_GEN5(dev) || IS_GEN6(dev))
> > > +                       dev_priv->lvds_use_ssc = 0;
> > >  
> > >                 if (dev_priv->lvds_use_ssc) {
> > >                         if (IS_I85X(dev))
> > > 
> > > 
> > > -- 
> > 
> > Ugh, looks like I have confused things horribly.  Sorry about this.
> > 
> > 2.6.37-rc8 with no patches works for me.  My original report was incorrect --
> > I was using -rc7 when I thought I was using -rc8.  :(
> 
> Can you confirm that the above doesn't break your setup just in case we
> need to apply it?


Yes, confirmed, my test platform still works with this patch applied.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
