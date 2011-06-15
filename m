Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1FOWHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:07:42 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57218 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752459Ab1FOWHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:07:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VCReXK/w0ndP1Kumqrq8z/lOIBF0gCuchStG5fm/2WLD0Svx3drg7b4CEFYgjwOP7L0xW8S/B1NIzky9fcrAyspktx/2aoWOIS/3zPz5TtHqQdiHehp0eh5nuoHpCzpu;
Date: Wed, 15 Jun 2011 15:07:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
Message-ID: <20110615150737.79cd5de7@jbarnes-desktop>
In-Reply-To: <giei2ulpl1.fsf@mx10.gouders.net>
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net>
	<giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 00:03:38 +0200
Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:

> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> 
> > Oh is this not an LVDS panel?  I'm curious which of the port disables
> > is at fault in your config then.  If you have an eDP panel, it would
> > likely be the PCH_DP_D write.  It could be a side effect of the
> > PANEL_UNLOCK_REGS write as well though, can you try commenting each of
> > those out?
> 
> Yes, you are right.  Commenting out a single line helps:
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 81a9059..ed95cbf 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1356,7 +1356,7 @@ static void intel_disable_pch_ports(struct drm_i915_private *dev_priv,
>         u32 reg, val;
>  
>         val = I915_READ(PCH_PP_CONTROL);
> -       I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
> +       //I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
>  
>         disable_pch_dp(dev_priv, pipe, PCH_DP_B);
>         disable_pch_dp(dev_priv, pipe, PCH_DP_C);

Ok interesting, that means one of the locked regs we're trying to write
later is the real culprit for this issue... those include the LVDS reg
and the panel timing regs.  I'll see if I can figure out which one
might be the problem.

-- 
Jesse Barnes, Intel Open Source Technology Center
