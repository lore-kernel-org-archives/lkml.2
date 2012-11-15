Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993418Ab2KOEPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:15:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:50131 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993051Ab2KOENQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: =?UTF-8?q?=5B=2053/57=5D=20drm/radeon/si=3A=20add=20some=20missing=20regs=20to=20the=20VM=20reg=20checker?=
Date: Wed, 14 Nov 2012 20:12:01 -0800
Message-Id: <20121115040936.392646347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f418b88aad0c42b4caf4d79a0cf8d14a5d0a2284 upstream.

This register is needed for streamout to work properly.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c  |    1 +
 drivers/gpu/drm/radeon/sid.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2593,6 +2593,7 @@ static bool si_vm_reg_valid(u32 reg)
 	/* check config regs */
 	switch (reg) {
 	case GRBM_GFX_INDEX:
+	case CP_STRMOUT_CNTL:
 	case VGT_VTX_VECT_EJECT_REG:
 	case VGT_CACHE_INVALIDATION:
 	case VGT_ESGS_RING_SIZE:
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -413,6 +413,7 @@
 #       define RDERR_INT_ENABLE                         (1 << 0)
 #       define GUI_IDLE_INT_ENABLE                      (1 << 19)
 
+#define	CP_STRMOUT_CNTL					0x84FC
 #define	SCRATCH_REG0					0x8500
 #define	SCRATCH_REG1					0x8504
 #define	SCRATCH_REG2					0x8508


