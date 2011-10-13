Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab1JMXJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:09:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:14192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab1JMXJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:09:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,343,1315206000"; 
   d="scan'208";a="73443406"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH 04/12] RADEON: Remove now unused functions in radeon driver
Date: Thu, 13 Oct 2011 16:08:44 -0700
Message-Id: <1318547332-23155-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With the dropped inlines gccs starts warning about genuinely unused
functions. Remove r600_bpe_from_format, evergreen_cs_track_validate_cb,
evergreen-cs_packet_next_is_pkt3_nop which are all unused.

Cc: David Airlie <airlied@linux.ie>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |   28 ----------------------------
 drivers/gpu/drm/radeon/r600_cs.c      |   19 -------------------
 2 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 35dce99..7fdfa8e 100644
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
index 7339c0b..0a2e023 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -223,25 +223,6 @@ static int fmt_get_nblocksy(u32 format, u32 h)
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

