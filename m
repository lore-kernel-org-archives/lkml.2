Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163145Ab1FAIdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:33:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:45246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163109Ab1FAI2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:19 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:21 2011
Message-Id: <20110601081220.623394410@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:59 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [149/165] drm/radeon/evergreen/btc/fusion: setup hdp to invalidate and
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 flush when asked
Content-Length: 1663
Lines: 51

From: Alex Deucher <alexdeucher@gmail.com>

commit f25a5c63bfa017498c9adecb24d649ae96ba5c68 upstream.

This needs to be explicitly set on btc.  It's set by default
on evergreen/fusion, so it fine to just unconditionally enable it for
all chips.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c  |    6 +++++-
 drivers/gpu/drm/radeon/evergreend.h |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1578,7 +1578,7 @@ static void evergreen_gpu_init(struct ra
 	u32 sq_stack_resource_mgmt_2;
 	u32 sq_stack_resource_mgmt_3;
 	u32 vgt_cache_invalidation;
-	u32 hdp_host_path_cntl;
+	u32 hdp_host_path_cntl, tmp;
 	int i, j, num_shader_engines, ps_thread_count;
 
 	switch (rdev->family) {
@@ -2141,6 +2141,10 @@ static void evergreen_gpu_init(struct ra
 	for (i = SQ_ALU_CONST_BUFFER_SIZE_HS_0; i < 0x29000; i += 4)
 		WREG32(i, 0);
 
+	tmp = RREG32(HDP_MISC_CNTL);
+	tmp |= HDP_FLUSH_INVALIDATE_CACHE;
+	WREG32(HDP_MISC_CNTL, tmp);
+
 	hdp_host_path_cntl = RREG32(HDP_HOST_PATH_CNTL);
 	WREG32(HDP_HOST_PATH_CNTL, hdp_host_path_cntl);
 
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -64,6 +64,8 @@
 #define GB_BACKEND_MAP  				0x98FC
 #define DMIF_ADDR_CONFIG  				0xBD4
 #define HDP_ADDR_CONFIG  				0x2F48
+#define HDP_MISC_CNTL  					0x2F4C
+#define		HDP_FLUSH_INVALIDATE_CACHE      	(1 << 0)
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0x3F88
 #define	GC_USER_RB_BACKEND_DISABLE			0x9B7C


