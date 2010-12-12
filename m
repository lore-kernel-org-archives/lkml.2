Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0LLHwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 02:52:13 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51738 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353Ab0LLHwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 02:52:11 -0500
Date: Sun, 12 Dec 2010 08:52:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        mbroemme@plusserver.de
Subject: Re: intelfb refuses to load
Message-ID: <20101212075203.GA1934@elf.ucw.cz>
References: <20101211221325.GA1954@elf.ucw.cz>
 <20101211234356.1e9007fe@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101211234356.1e9007fe@neptune.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Looks like you are using the wrong intel driver.
> 
> For intel modesetting you need
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I830 is not set
> CONFIG_DRM_I915=y
> # CONFIG_DRM_I915_KMS is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> 
> # CONFIG_FB_I810 is not set
> 
> That will give you inteldrmfb.
>                         ^^^
> 

> Not sure what dependency is missing in your config that DRM_I915 does
> not show up... (it might be CONFIG_AGP_INTEL)

It is hidden by "choice" with interesting name.

Unfrotunately, if I do this, I get kernel messages for about a second,
and then blank screen. Thinkpad X60...

I now have:

i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k 

on cmdline and:

CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
...
CONFIG_ACPI_VIDEO=y


> intelfb (CONFIG_FB_I810) is obsolete and only supports a pretty limited
> part of intel GPU features, modesetting only for VGA output (and not
> sure it works at all with recent GPUs).

Perhaps something like this should be done? I had no idea that the
choice is for modern drivers, too...

								Pavel

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 7af4436..3f1e7fd 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -81,7 +81,7 @@ config DRM_I810
 	  for this driver to work.
 
 choice
-	prompt "Intel 830M, 845G, 852GM, 855GM, 865G"
+	prompt "Intel 830M, 845G, 852GM, 855GM, 865G, ..., i915 driver"
 	depends on DRM && AGP && AGP_INTEL
 	optional
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
