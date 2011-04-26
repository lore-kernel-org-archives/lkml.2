Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1DZM3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:29:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57278 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1DZM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:32 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, maximilian attems <max@stro.at>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 08/21] drm/radeon/kms: fix typos in disabled vbios code" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:29 +0200
Message-Id: <1303820789-3617-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 08/21] drm/radeon/kms: fix typos in disabled vbios code

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 4dbc1d273a6caa658fb60a58be5cc6bddc84bf4f Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 30 Nov 2010 19:11:45 -0500
Subject: [PATCH 08/21] drm/radeon/kms: fix typos in disabled vbios code

commit 0ec80d645661dda50acd417bdfcb33df2e5dd31e upstream.

6xx/7xx was hitting the wrong BUS_CNTL reg and bits.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r600_reg.h    |    1 +
 drivers/gpu/drm/radeon/radeon_bios.c |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_reg.h b/drivers/gpu/drm/radeon/r600_reg.h
index d0e28ff..fb3dfef 100644
--- a/drivers/gpu/drm/radeon/r600_reg.h
+++ b/drivers/gpu/drm/radeon/r600_reg.h
@@ -86,6 +86,7 @@
 #define R600_HDP_NONSURFACE_BASE                                0x2c04

 #define R600_BUS_CNTL                                           0x5420
+#       define R600_BIOS_ROM_DIS                                (1 << 1)
 #define R600_CONFIG_CNTL                                        0x5424
 #define R600_CONFIG_MEMSIZE                                     0x5428
 #define R600_CONFIG_F0_BASE                                     0x542C
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 9069217..cd734bd 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -106,7 +106,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 	bool r;

 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -115,7 +115,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -154,7 +154,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 			cg_spll_status = RREG32(R600_CG_SPLL_STATUS);
 	}
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);
@@ -179,7 +179,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)
 	bool r;

 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -194,7 +194,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -225,7 +225,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)

 	/* restore regs */
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);
--
1.7.0.4

