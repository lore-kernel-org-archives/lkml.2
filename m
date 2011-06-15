Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1FOVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:41:40 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46204 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753136Ab1FOVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:41:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OPf4fOSWhFyyOe1puGypsg2HWSNRhTvZK2c7eXhtCYfHpC5ZA0A8r1S42N5g/cok3aTMnRvxSgkH0sT9Dn2SvPIB2whIp5lnqfe8IbedKHnMjsG7VTBp54BSVp9V0Z+6;
Date: Wed, 15 Jun 2011 14:41:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
Message-ID: <20110615144132.074167f3@jbarnes-desktop>
In-Reply-To: <giips6lr5a.fsf@mx10.gouders.net>
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net>
	<giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 23:29:53 +0200
Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> > diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
> > index 81a9059..ef41487 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -1366,7 +1366,7 @@ static void intel_disable_pch_ports(struct drm_i915_privat
> >         val = I915_READ(reg);
> >         if (ADPA_PIPE_ENABLED(val, pipe))
> >                 I915_WRITE(reg, val & ~ADPA_DAC_ENABLE);
> > -
> > +#if 0
> >         reg = PCH_LVDS;
> >         val = I915_READ(reg);
> >         if (LVDS_PIPE_ENABLED(val, pipe)) {
> > @@ -1374,7 +1374,7 @@ static void intel_disable_pch_ports(struct drm_i915_privat
> >                 POSTING_READ(reg);
> >                 udelay(100);
> >         }
> > -
> > +#endif
> >         disable_pch_hdmi(dev_priv, pipe, HDMIB);
> >         disable_pch_hdmi(dev_priv, pipe, HDMIC);
> >         disable_pch_hdmi(dev_priv, pipe, HDMID);
> 
> No, that patch does not help.

Oh is this not an LVDS panel?  I'm curious which of the port disables
is at fault in your config then.  If you have an eDP panel, it would
likely be the PCH_DP_D write.  It could be a side effect of the
PANEL_UNLOCK_REGS write as well though, can you try commenting each of
those out?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
