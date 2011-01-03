Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1ACOzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:55:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:33763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab1ACOzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:55:53 -0500
Message-Id: <b7da2f$q1ffv6@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="873971699"
Date: Mon, 03 Jan 2011 14:54:53 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>, airlied@linux.ie
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
Cc: eric@anholt.net, jesse.barnes@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
In-Reply-To: <4D21DC41.8070408@t-online.de>
References: <4D21DC41.8070408@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jan 2011 15:25:05 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> The AOpen i915GMm-HFS is a desktop motherboard for the Intel Pentium M.
> A mobile chipset is used
> (Intel 915GM / ICH6-M). Kernel 2.6.31.14 works fine for that mobo, but
> from 2.6.32 on graphics support
> is broken because the i915 driver "detects" an lvds device with a
> resolution of 1024x768 pixels that in reality
> is not present. Unfortunately the driver assumes that the "detected"
> lvds is the primary screen and uses the
> wrong resolution also for the real VGA and DVI connectors.

Can you try:

diff --git a/drivers/gpu/drm/i915/intel_i2c.c
b/drivers/gpu/drm/i915/intel_i2c.c
index 58040f6..111128d 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -384,7 +384,7 @@ int intel_setup_gmbus(struct drm_device *dev)
                bus->reg0 = i | GMBUS_RATE_100KHZ;
 
                /* XXX force bit banging until GMBUS is fully debugged */
-               bus->force_bit = intel_gpio_create(dev_priv, i);
+               //bus->force_bit = intel_gpio_create(dev_priv, i);
        }
 
        intel_i2c_reset(dev_priv->dev);
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
