Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0L2WqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 17:46:19 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60489 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753937Ab0L2WqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 17:46:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OmFA2M+Lu84ZsV8gro704sPKuapz9V1azSk6uYXOAs5tsx/hemt7qv38eGLhpXhBDF97vu9V8xpXFSSG1flXNjQ48m8qaleyP0DsnCUL6Pa3dWc28YXN+VTfteROE3zh;
Date: Wed, 29 Dec 2010 14:46:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229144614.484b64ef@jbarnes-desktop>
In-Reply-To: <20101229141253.5ff91e3e.randy.dunlap@oracle.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<20101229141253.5ff91e3e.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
> > index 2b20786..d27d016 100644
> > --- a/drivers/gpu/drm/i915/intel_bios.c
> > +++ b/drivers/gpu/drm/i915/intel_bios.c
> > @@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
> >                 dev_priv->int_tv_support = general->int_tv_support;
> >                 dev_priv->int_crt_support = general->int_crt_support;
> >                 dev_priv->lvds_use_ssc = general->enable_ssc;
> > +               /* force disable until we can parse this correctly */
> > +               if (IS_GEN5(dev) || IS_GEN6(dev))
> > +                       dev_priv->lvds_use_ssc = 0;
> >  
> >                 if (dev_priv->lvds_use_ssc) {
> >                         if (IS_I85X(dev))
> > 
> > 
> > -- 
> 
> Ugh, looks like I have confused things horribly.  Sorry about this.
> 
> 2.6.37-rc8 with no patches works for me.  My original report was incorrect --
> I was using -rc7 when I thought I was using -rc8.  :(

Can you confirm that the above doesn't break your setup just in case we
need to apply it?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
