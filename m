Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab0LHB1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:27:40 -0500
Received: from kroah.org ([198.145.64.141]:33445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab0LHBCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005738.971457477@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [175/289] drm/radeon/kms: fix typos in disabled vbios code
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 0ec80d645661dda50acd417bdfcb33df2e5dd31e upstream.

6xx/7xx was hitting the wrong BUS_CNTL reg and bits.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600_reg.h    |    1 +
 drivers/gpu/drm/radeon/radeon_bios.c |   13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_reg.h
+++ b/drivers/gpu/drm/radeon/r600_reg.h
@@ -86,6 +86,7 @@
 #define R600_HDP_NONSURFACE_BASE                                0x2c04
 
 #define R600_BUS_CNTL                                           0x5420
+#       define R600_BIOS_ROM_DIS                                (1 << 1)
 #define R600_CONFIG_CNTL                                        0x5424
 #define R600_CONFIG_MEMSIZE                                     0x5428
 #define R600_CONFIG_F0_BASE                                     0x542C
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -130,6 +130,7 @@ static bool radeon_atrm_get_bios(struct
 	}
 	return true;
 }
+
 static bool r700_read_disabled_bios(struct radeon_device *rdev)
 {
 	uint32_t viph_control;
@@ -143,7 +144,7 @@ static bool r700_read_disabled_bios(stru
 	bool r;
 
 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -152,7 +153,7 @@ static bool r700_read_disabled_bios(stru
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -191,7 +192,7 @@ static bool r700_read_disabled_bios(stru
 			cg_spll_status = RREG32(R600_CG_SPLL_STATUS);
 	}
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);
@@ -216,7 +217,7 @@ static bool r600_read_disabled_bios(stru
 	bool r;
 
 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -231,7 +232,7 @@ static bool r600_read_disabled_bios(stru
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -262,7 +263,7 @@ static bool r600_read_disabled_bios(stru
 
 	/* restore regs */
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);


