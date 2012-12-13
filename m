Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2LMOEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2LMOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 064/241] drm/radeon/si: add some missing regs to the VM reg checker
Date: Thu, 13 Dec 2012 11:57:09 -0200
Message-Id: <1355407206-17100-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f418b88aad0c42b4caf4d79a0cf8d14a5d0a2284 upstream.

This register is needed for streamout to work properly.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/si.c  |    1 +
 drivers/gpu/drm/radeon/sid.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index bb9ea23..ec8abab 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2439,6 +2439,7 @@ static bool si_vm_reg_valid(u32 reg)
 	/* check config regs */
 	switch (reg) {
 	case GRBM_GFX_INDEX:
+	case CP_STRMOUT_CNTL:
 	case VGT_VTX_VECT_EJECT_REG:
 	case VGT_CACHE_INVALIDATION:
 	case VGT_ESGS_RING_SIZE:
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index db40679..810a83e 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -424,6 +424,7 @@
 #       define RDERR_INT_ENABLE                         (1 << 0)
 #       define GUI_IDLE_INT_ENABLE                      (1 << 19)
 
+#define	CP_STRMOUT_CNTL					0x84FC
 #define	SCRATCH_REG0					0x8500
 #define	SCRATCH_REG1					0x8504
 #define	SCRATCH_REG2					0x8508
-- 
1.7.9.5

