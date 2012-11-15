Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab2KOE2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:28:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49497 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993097Ab2KOEMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: =?UTF-8?q?=5B=2062/66=5D=20drm/radeon/cayman=3A=20add=20some=20missing=20regs=20to=20the=20VM=20reg=20checker?=
Date: Wed, 14 Nov 2012 20:11:07 -0800
Message-Id: <20121115040943.614731224@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 860fe2f05fa2eacac84368e23547ec8cf3cc6652 upstream.

These regs were being wronly rejected leading to rendering
issues.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=56876

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_cs.c |    3 +++
 drivers/gpu/drm/radeon/evergreend.h   |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2725,6 +2725,9 @@ static bool evergreen_vm_reg_valid(u32 r
 	/* check config regs */
 	switch (reg) {
 	case GRBM_GFX_INDEX:
+	case CP_STRMOUT_CNTL:
+	case CP_COHER_CNTL:
+	case CP_COHER_SIZE:
 	case VGT_VTX_VECT_EJECT_REG:
 	case VGT_CACHE_INVALIDATION:
 	case VGT_GS_VERTEX_REUSE:
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -87,6 +87,10 @@
 
 #define	CONFIG_MEMSIZE					0x5428
 
+#define	CP_STRMOUT_CNTL					0x84FC
+
+#define	CP_COHER_CNTL					0x85F0
+#define	CP_COHER_SIZE					0x85F4
 #define	CP_COHER_BASE					0x85F8
 #define	CP_STALLED_STAT1			0x8674
 #define	CP_STALLED_STAT2			0x8678


