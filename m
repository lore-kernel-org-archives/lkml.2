Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1EUACY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:33151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab1EUACI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807297"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/12] RADEON: Remove now unused functions in radeon driver
Date: Fri, 20 May 2011 17:01:16 -0700
Message-Id: <1305936082-21304-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With the dropped inlines gccs starts warning about genuinely unused
functions. Remove r600_bpe_from_format, evergreen_cs_track_validate_cb,
evergreen-cs_packet_next_is_pkt3_nop which are all unused.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |   28 ----------------------------
 drivers/gpu/drm/radeon/r600_cs.c      |   19 -------------------
 2 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 5175c65..1d46c95 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -122,12 +122,6 @@ static void evergreen_cs_track_init(struct evergreen_cs_track *track)
 	track->db_s_write_bo = NULL;
 }
 
-static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, int i)
-{
-	/* XXX fill in */
-	return 0;
-}
-
 static int evergreen_cs_track_check(struct radeon_cs_parser *p)
 {
 	struct evergreen_cs_track *track = p->track;
@@ -236,28 +230,6 @@ static int evergreen_cs_packet_next_reloc(struct radeon_cs_parser *p,
 }
 
 /**
- * evergreen_cs_packet_next_is_pkt3_nop() - test if next packet is packet3 nop for reloc
- * @parser:		parser structure holding parsing context.
- *
- * Check next packet is relocation packet3, do bo validation and compute
- * GPU offset using the provided start.
- **/
-static int evergreen_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
-{
-	struct radeon_cs_packet p3reloc;
-	int r;
-
-	r = evergreen_cs_packet_parse(p, &p3reloc, p->idx);
-	if (r) {
-		return 0;
-	}
-	if (p3reloc.type != PACKET_TYPE3 || p3reloc.opcode != PACKET3_NOP) {
-		return 0;
-	}
-	return 1;
-}
-
-/**
  * evergreen_cs_packet_next_vline() - parse userspace VLINE packet
  * @parser:		parser structure holding parsing context.
  *
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 8782dd6..6f71b32 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -215,25 +215,6 @@ static int fmt_get_nblocksy(u32 format, u32 h)
 	return (h + bh - 1) / bh;
 }
 
-static int r600_bpe_from_format(u32 *bpe, u32 format)
-{
- 	unsigned res;
-
-	if (format >= ARRAY_SIZE(color_formats_table))
-		goto fail;
-
-	res = color_formats_table[format].blocksize;
-	if (res == 0)
-		goto fail;
-
-	*bpe = res;
-	return 0;
-
-fail:
-	*bpe = 16;
-	return -EINVAL;
-}
-
 struct array_mode_checker {
 	int array_mode;
 	u32 group_size;
-- 
1.7.4.4

