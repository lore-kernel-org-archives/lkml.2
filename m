Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0LLXpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44807 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0LLXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [44/223] drm/radeon/kms: MC vram map needs to be >= pci aperture size
Message-Id: <20101212234541.33799B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit b7d8cce5b558e0c0aa6898c9865356481598b46d upstream.

The vram map in the radeon memory controller needs to be
>= the pci aperture size.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=28402

The problematic cards in the above bug have 64 MB of vram,
but the pci aperture is 128 MB and the MC vram map was only
64 MB.  This can lead to hangs.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/r100.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/gpu/drm/radeon/r100.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/r100.c
+++ linux/drivers/gpu/drm/radeon/r100.c
@@ -2321,6 +2321,9 @@ void r100_vram_init_sizes(struct radeon_
 		/* Fix for RN50, M6, M7 with 8/16/32(??) MBs of VRAM - 
 		 * Novell bug 204882 + along with lots of ubuntu ones
 		 */
+		if (rdev->mc.aper_size > config_aper_size)
+			config_aper_size = rdev->mc.aper_size;
+
 		if (config_aper_size > rdev->mc.real_vram_size)
 			rdev->mc.mc_vram_size = config_aper_size;
 		else
