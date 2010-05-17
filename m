Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0EQNXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:23:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49736 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0EQNXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=s5gG408znfft++8hYuRtTtPgqESBhGp2h6jwkARcR9eBsJp5KFo7h79JjYCeDKiahN
         1VS/w/LLTUfsg83mY9+1W7mwpntwPLcIUjShXih1n/jLo2vU/pemud49WhLaIne1oquN
         PpSADvBoa8d/GcRpFYEnTW9RgvZWg1zLC9wls=
MIME-Version: 1.0
Date: Mon, 17 May 2010 14:23:52 +0100
Message-ID: <AANLkTimb489PFFsC96b00jeuqv0OOEk8NbwpTHu9K3Cl@mail.gmail.com>
Subject: [2.6.34, patch] i915: fix lock imbalance on error path...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org
Cc: Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investigating Intel i5 Arrandale GPU lockups with -rc4, I
noticed a lock imbalance.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index cc03537..f5fee1b 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -341,6 +341,7 @@ int i965_reset(struct drm_device *dev, u8 flags)
 		}
 	} else {
 		DRM_ERROR("Error occurred. Don't know how to reset this chip.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -ENODEV;
 	}

-- 
Daniel J Blueman
