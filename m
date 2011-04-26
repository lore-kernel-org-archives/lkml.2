Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1DZM03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57223 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1DZM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:27 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Keith Packard <keithp@keithp.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 05/21] drm/i915: Free hardware status page on unload when physically mapped" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:24 +0200
Message-Id: <1303820784-3520-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 05/21] drm/i915: Free hardware status page on unload when physically mapped

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 266b030ef0bbf2986895ab789cdba90561af1ac8 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Thu, 7 Oct 2010 09:20:12 +0100
Subject: [PATCH 05/21] drm/i915: Free hardware status page on unload when physically mapped

commit c2873e9633fe908dccd36dbb1d370e9c59a1ca62 upstream.

A physically mapped hardware status page is allocated at driver load
time but was never freed. Call the existing code to free this page at
driver unload time on hardware which uses this kind.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ickle: call before tearing down registers on KMS-only path, as pointed
out by Dave Airlie]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 7f13d50..2b2adb5 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1583,6 +1583,9 @@ int i915_driver_unload(struct drm_device *dev)
 		i915_gem_lastclose(dev);

 		intel_cleanup_overlay(dev);
+
+		if (!I915_NEED_GFX_HWS(dev))
+			i915_free_hws(dev);
 	}

 	pci_dev_put(dev_priv->bridge_dev);
--
1.7.0.4

