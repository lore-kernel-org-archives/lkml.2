Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1EUAC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:59481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab1EUACJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807295"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/12] RADEON: Drop inlines from evergreen_cs.c / r600_cs.c
Date: Fri, 20 May 2011 17:01:12 -0700
Message-Id: <1305936082-21304-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fixes

evergreen_cs_parse                          4080   23124  +19044

and others compared to a non force inline kernel.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |    8 ++++----
 drivers/gpu/drm/radeon/r600_cs.c      |   24 ++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 23d3641..5175c65 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -122,7 +122,7 @@ static void evergreen_cs_track_init(struct evergreen_cs_track *track)
 	track->db_s_write_bo = NULL;
 }
 
-static inline int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, int i)
+static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, int i)
 {
 	/* XXX fill in */
 	return 0;
@@ -242,7 +242,7 @@ static int evergreen_cs_packet_next_reloc(struct radeon_cs_parser *p,
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
  **/
-static inline int evergreen_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
+static int evergreen_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
 {
 	struct radeon_cs_packet p3reloc;
 	int r;
@@ -414,7 +414,7 @@ static int evergreen_cs_parse_packet0(struct radeon_cs_parser *p,
  * if register is safe. If register is not flag as safe this function
  * will test it against a list of register needind special handling.
  */
-static inline int evergreen_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
+static int evergreen_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
 {
 	struct evergreen_cs_track *track = (struct evergreen_cs_track *)p->track;
 	struct radeon_cs_reloc *reloc;
@@ -963,7 +963,7 @@ static inline int evergreen_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u3
  * This function will check that the resource has valid field and that
  * the texture and mipmap bo object are big enough to cover this resource.
  */
-static inline int evergreen_check_texture_resource(struct radeon_cs_parser *p,  u32 idx,
+static int evergreen_check_texture_resource(struct radeon_cs_parser *p,  u32 idx,
 						   struct radeon_bo *texture,
 						   struct radeon_bo *mipmap)
 {
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index fd18be9..8782dd6 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -157,7 +157,7 @@ static const struct gpu_formats color_formats_table[] = {
 
 };
 
-static inline bool fmt_is_valid_color(u32 format)
+static bool fmt_is_valid_color(u32 format)
 {
 	if (format >= ARRAY_SIZE(color_formats_table))
 		return false;
@@ -168,7 +168,7 @@ static inline bool fmt_is_valid_color(u32 format)
 	return false;
 }
 
-static inline bool fmt_is_valid_texture(u32 format)
+static bool fmt_is_valid_texture(u32 format)
 {
 	if (format >= ARRAY_SIZE(color_formats_table))
 		return false;
@@ -179,7 +179,7 @@ static inline bool fmt_is_valid_texture(u32 format)
 	return false;
 }
 
-static inline int fmt_get_blocksize(u32 format)
+static int fmt_get_blocksize(u32 format)
 {
 	if (format >= ARRAY_SIZE(color_formats_table))
 		return 0;
@@ -187,7 +187,7 @@ static inline int fmt_get_blocksize(u32 format)
 	return color_formats_table[format].blocksize;
 }
 
-static inline int fmt_get_nblocksx(u32 format, u32 w)
+static int fmt_get_nblocksx(u32 format, u32 w)
 {
 	unsigned bw;
 
@@ -201,7 +201,7 @@ static inline int fmt_get_nblocksx(u32 format, u32 w)
 	return (w + bw - 1) / bw;
 }
 
-static inline int fmt_get_nblocksy(u32 format, u32 h)
+static int fmt_get_nblocksy(u32 format, u32 h)
 {
 	unsigned bh;
 
@@ -215,7 +215,7 @@ static inline int fmt_get_nblocksy(u32 format, u32 h)
 	return (h + bh - 1) / bh;
 }
 
-static inline int r600_bpe_from_format(u32 *bpe, u32 format)
+static int r600_bpe_from_format(u32 *bpe, u32 format)
 {
  	unsigned res;
 
@@ -244,7 +244,7 @@ struct array_mode_checker {
 };
 
 /* returns alignment in pixels for pitch/height/depth and bytes for base */
-static inline int r600_get_array_mode_alignment(struct array_mode_checker *values,
+static int r600_get_array_mode_alignment(struct array_mode_checker *values,
 						u32 *pitch_align,
 						u32 *height_align,
 						u32 *depth_align,
@@ -323,7 +323,7 @@ static void r600_cs_track_init(struct r600_cs_track *track)
 	track->db_depth_control = 0xFFFFFFFF;
 }
 
-static inline int r600_cs_track_validate_cb(struct radeon_cs_parser *p, int i)
+static int r600_cs_track_validate_cb(struct radeon_cs_parser *p, int i)
 {
 	struct r600_cs_track *track = p->track;
 	u32 slice_tile_max, size, tmp;
@@ -729,7 +729,7 @@ static int r600_cs_packet_next_reloc_nomm(struct radeon_cs_parser *p,
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
  **/
-static inline int r600_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
+static int r600_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
 {
 	struct radeon_cs_packet p3reloc;
 	int r;
@@ -903,7 +903,7 @@ static int r600_cs_parse_packet0(struct radeon_cs_parser *p,
  * if register is safe. If register is not flag as safe this function
  * will test it against a list of register needind special handling.
  */
-static inline int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
+static int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
 {
 	struct r600_cs_track *track = (struct r600_cs_track *)p->track;
 	struct radeon_cs_reloc *reloc;
@@ -1199,7 +1199,7 @@ static inline int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx
 	return 0;
 }
 
-static inline unsigned mip_minify(unsigned size, unsigned level)
+static unsigned mip_minify(unsigned size, unsigned level)
 {
 	unsigned val;
 
@@ -1269,7 +1269,7 @@ static void r600_texture_size(unsigned nfaces, unsigned blevel, unsigned llevel,
  * This function will check that the resource has valid field and that
  * the texture and mipmap bo object are big enough to cover this resource.
  */
-static inline int r600_check_texture_resource(struct radeon_cs_parser *p,  u32 idx,
+static int r600_check_texture_resource(struct radeon_cs_parser *p,  u32 idx,
 					      struct radeon_bo *texture,
 					      struct radeon_bo *mipmap,
 					      u64 base_offset,
-- 
1.7.4.4

