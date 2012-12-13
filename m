Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2LMOEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2LMOEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 063/241] drm/radeon/cayman: add some missing regs to the VM reg checker
Date: Thu, 13 Dec 2012 11:57:08 -0200
Message-Id: <1355407206-17100-64-git-send-email-herton.krzesinski@canonical.com>
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

commit 860fe2f05fa2eacac84368e23547ec8cf3cc6652 upstream.

These regs were being wronly rejected leading to rendering
issues.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=56876

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |    3 +++
 drivers/gpu/drm/radeon/evergreend.h   |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 49231aa..33aeaa5 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2673,6 +2673,9 @@ static bool evergreen_vm_reg_valid(u32 reg)
 	/* check config regs */
 	switch (reg) {
 	case GRBM_GFX_INDEX:
+	case CP_STRMOUT_CNTL:
+	case CP_COHER_CNTL:
+	case CP_COHER_SIZE:
 	case VGT_VTX_VECT_EJECT_REG:
 	case VGT_CACHE_INVALIDATION:
 	case VGT_GS_VERTEX_REUSE:
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index 4a43b46..1a8b960 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -87,6 +87,10 @@
 
 #define	CONFIG_MEMSIZE					0x5428
 
+#define	CP_STRMOUT_CNTL					0x84FC
+
+#define	CP_COHER_CNTL					0x85F0
+#define	CP_COHER_SIZE					0x85F4
 #define	CP_COHER_BASE					0x85F8
 #define CP_ME_CNTL					0x86D8
 #define		CP_ME_HALT					(1 << 28)
-- 
1.7.9.5

