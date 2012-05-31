Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2EaNWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:22:30 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:34552 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2EaNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <1338451231_375838@CP5-2952>
References: <20120530213128.GA10407@redhat.com>
	<CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
	<20120530215848.GB19223@redhat.com>
	<20120530222651.GA22449@redhat.com>
	<1338451231_375838@CP5-2952>
Date: Thu, 31 May 2012 10:22:28 -0300
Message-ID: <CA+gsUGTP5S9Az5oHMxYgyJbDPv9R7gRoC614RW0OLk7_TBeDZQ@mail.gmail.com>
Subject: Re: Lots of i915/drm spew on 3.4
From: Paulo Zanoni <przanoni@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Jones <davej@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Rob Clark <rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/31 Chris Wilson <chris@chris-wilson.co.uk>:
> Before that commit we had no idea that we had run out of property slots.
> I think the WARN is genuine, but maybe we should just bump the count set
> it to WARN_ONCE and hope the conversion to lists arrives sooner rather
> than latter.
> -Chris
>

Chris is right: this is not a regression. Before that patch, no one
checked if property creation really worked. I chose not to use
WARN_ONCE because we need to increase the variable once for each time
you see the message. Assuming this message appears on your log less
than 8 times, does this patch fix your problem?

diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 73e4560..bac55c2 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -54,7 +54,7 @@ struct drm_mode_object {
        struct drm_object_properties *properties;
 };

-#define DRM_OBJECT_MAX_PROPERTY 16
+#define DRM_OBJECT_MAX_PROPERTY 24
 struct drm_object_properties {
        int count;
        uint32_t ids[DRM_OBJECT_MAX_PROPERTY];




-- 
Paulo Zanoni
