Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1DZM0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57139 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1DZM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:23 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 02/21] drm/radeon/kms: MC vram map needs to be >= pci aperture size" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:19 +0200
Message-Id: <1303820779-3424-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 02/21] drm/radeon/kms: MC vram map needs to be >= pci aperture size

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 4da7981edaa0dbc29b78a3cc5b9d6feb4c5b4ae3 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 25 Oct 2010 19:44:00 -0400
Subject: [PATCH 02/21] drm/radeon/kms: MC vram map needs to be >= pci aperture size

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
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 947570c..b969b7d 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1918,6 +1918,9 @@ void r100_vram_init_sizes(struct radeon_device *rdev)
 		rdev->mc.vram_location = 0xFFFFFFFFUL;
 		 /* Fix for RN50, M6, M7 with 8/16/32(??) MBs of VRAM -
 		  * Novell bug 204882 + along with lots of ubuntu ones */
+		if (rdev->mc.aper_size > config_aper_size)
+			config_aper_size = rdev->mc.aper_size;
+
 		if (config_aper_size > rdev->mc.real_vram_size)
 			rdev->mc.mc_vram_size = config_aper_size;
 		else
--
1.7.0.4

