Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2KVVfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:35:30 -0500
Received: from [93.179.225.50] ([93.179.225.50]:57024 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab2KVVfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:35:25 -0500
Date: Thu, 22 Nov 2012 22:35:22 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915: black screen after blank when LID is closed on Linux >= 3.1
Message-ID: <20121122213522.GA12958@shrek.podlesie.net>
References: <20121122185416.GA13169@shrek.podlesie.net>
 <CAKMK7uGBSwBeW=hCJi1sZgahQQSKdSy8K=i+M53hF3vDuNzDDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGBSwBeW=hCJi1sZgahQQSKdSy8K=i+M53hF3vDuNzDDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 09:17:54PM +0100, Daniel Vetter wrote:
> Hi,
> 
> 
> Since a dpms ioctl call tends to follow a modeset, this likely only
> results in that dpms call enabling the hw again. Can you please add
> drm.debug=0xe to your kernel cmdline and boot into a 3.6 with this
> hack applied, reproduce the issue and the attach the complete dmesg?
> 
> The below WARNs from 3.7 support that, we've simply improved the
> code's ability to detect such problems. Can you please boot into a
> kernel with the latest drm-intel-next-queued branch merged in, but no
> other patches applied. Again please append drm.debug=0xe and then
> attach the complete dmesg after you've reproduced the issue.
> 
> Please also compile your kernels with CONFIG_PRINTK_TIME=y, the
> timestamps in dmesg help a lot in figuring things out.

In lastest drm-intel-next-queued (v3.7-rc4-323-g9352dce) I got
following compile error:

/home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_lvds.c: In function 'intel_lvds_init':
/home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_lvds.c:1098:34: error: 'mode' undeclared (first use in this function)
/home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_lvds.c:1098:34: note: each undeclared identifier is reported only once for each function it appears in

Without thinking I fixed it by:

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index ced06f3..43f0874 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -1095,7 +1095,7 @@ bool intel_lvds_init(struct drm_device *dev)
 		fixed_mode = intel_crtc_mode_get(dev, crtc);
 		if (fixed_mode) {
 			DRM_DEBUG_KMS("using current (BIOS) mode: ");
-			drm_mode_debug_printmodeline(&mode);
+			drm_mode_debug_printmodeline(fixed_mode);
 			fixed_mode->type |= DRM_MODE_TYPE_PREFERRED;
 			goto out;
 		}

Thanks,

Krzysiek
