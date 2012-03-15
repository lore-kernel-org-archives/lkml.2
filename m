Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016Ab2COKJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:09:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:10740 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab2COKJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:09:23 -0400
Message-Id: <c55c5d$2a7hsj@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77842323"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [V3 PATCH 2/2] drivers-gpu-drm-i915-quirk-backlight-inverted.patch
To: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120315095357.607004685@osadl.org>
References: <20120315095219.520461363@osadl.org> <20120315095357.607004685@osadl.org>
Date: Thu, 15 Mar 2012 10:09:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 10:52:21 +0100, Carsten Emde <C.Emde@osadl.org> wrote:
> Following the documentation of the Legacy Backlight Brightness (LBB)
> Register in the configuration space of some Intel PCI graphics adapters,
> setting the LBB register with the value 0x0 causes the backlight to be
> turned off, and 0xFF causes the backlight to be set to 100% intensity
> (http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
> The Acer Aspire 5734Z, however, turns the backlight off at 0xFF and sets
> it to maximum intensity at 0. In consequence, the screen of this systems
> becomes dark at an early boot stage which makes it unusable. The same
> inversion applies to the BLC_PWM_CTL I915 register. This problem was
> introduced in kernel version 2.6.38 when the PCI device of this system
> was first supported by the i915 KMS module.
> 
> This patch adds a quirk to invert the sense of the brightness variable
> in case an Acer Aspire 5734Z is encountered.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>

That looks a lot better. However, can I ask for another follow-on patch
to enable this quirk by a module parameter as well? I would like to make
it easier for anyone else hitting this issue to identity the problem and
find a temporary solution until their machine is also quirked.

>  static void intel_init_quirks(struct drm_device *dev)
> Index: linux-3.3-rc7/drivers/gpu/drm/i915/intel_panel.c
> ===================================================================
> --- linux-3.3-rc7.orig/drivers/gpu/drm/i915/intel_panel.c
> +++ linux-3.3-rc7/drivers/gpu/drm/i915/intel_panel.c
> @@ -28,6 +28,7 @@
>   *      Chris Wilson <chris@chris-wilson.co.uk>
>   */
>  
> +#include <linux/moduleparam.h>
>  #include "intel_drv.h"

That include is now not required.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
