Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1FCNLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:11:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56308 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1FCNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=JScyaPxB1UgiVNuQfn4Hd3DzZjjasXnZjbsqE2qr8QXhEpWoNZH6R5AhbddqYxkHHF
         tVfSjQ9kVmx+8FOv4DZbzwTjLHXEcToT1qIxxZpIOCQM+UjwxhRmIQf65gkqT5Sw9Iti
         LjTrjIPg4+2y68MzGjvkOzGdeFscWWrOZ8Zjo=
Date: Fri, 3 Jun 2011 21:09:39 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH]remove warning for drivers/gpu/drm/i915/intel_ringbuffer.c
Message-ID: <20110603130502.GA5740@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, keithp@keithp.com,
	airlied@linux.ie, dri-devel@lists.freedesktop.org, greg@kroah.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>
When i compile kernel, it shows me two warnings
like below, so this patch can fix them. 

[...]
CC [M]  drivers/gpu/drm/i915/intel_dvo.o
CC [M]  drivers/gpu/drm/i915/intel_ringbuffer.o
drivers/gpu/drm/i915/intel_ringbuffer.c:603: warning: ���ring_get_irq��� defined but not used
drivers/gpu/drm/i915/intel_ringbuffer.c:620: warning: ���ring_put_irq��� defined but not used
CC [M]  drivers/gpu/drm/i915/intel_overlay.o
CC [M]  drivers/gpu/drm/i915/intel_opregion.o
[...]


Signed-off-by: Harry Wei <harryxiyou@gmail.com>

Index: prj/drivers/gpu/drm/i915/intel_ringbuffer.c
===================================================================
--- prj.orig/drivers/gpu/drm/i915/intel_ringbuffer.c	2011-06-03 20:37:35.523539547 +0800
+++ prj/drivers/gpu/drm/i915/intel_ringbuffer.c	2011-06-03 20:38:07.279539574 +0800
@@ -599,23 +599,6 @@
 	return 0;
 }
 
-static bool
-ring_get_irq(struct intel_ring_buffer *ring, u32 flag)
-{
-	struct drm_device *dev = ring->dev;
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	if (!dev->irq_enabled)
-	       return false;
-
-	spin_lock(&ring->irq_lock);
-	if (ring->irq_refcount++ == 0)
-		ironlake_enable_irq(dev_priv, flag);
-	spin_unlock(&ring->irq_lock);
-
-	return true;
-}
-
 static void
 ring_put_irq(struct intel_ring_buffer *ring, u32 flag)
 {
