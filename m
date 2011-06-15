Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1FOWDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:03:49 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:40232
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1FOWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:03:48 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5FM3fgR024817
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <20110615144132.074167f3@jbarnes-desktop> (Jesse Barnes's message
	of "Wed, 15 Jun 2011 14:41:32 -0700")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net> <giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 16 Jun 2011 00:03:38 +0200
Message-ID: <giei2ulpl1.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 16 Jun 2011 00:03:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> Oh is this not an LVDS panel?  I'm curious which of the port disables
> is at fault in your config then.  If you have an eDP panel, it would
> likely be the PCH_DP_D write.  It could be a side effect of the
> PANEL_UNLOCK_REGS write as well though, can you try commenting each of
> those out?

Yes, you are right.  Commenting out a single line helps:

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 81a9059..ed95cbf 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1356,7 +1356,7 @@ static void intel_disable_pch_ports(struct drm_i915_private *dev_priv,
        u32 reg, val;
 
        val = I915_READ(PCH_PP_CONTROL);
-       I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
+       //I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
 
        disable_pch_dp(dev_priv, pipe, PCH_DP_B);
        disable_pch_dp(dev_priv, pipe, PCH_DP_C);

Dirk
