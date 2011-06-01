Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163140Ab1FAI2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:45240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162224Ab1FAI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:14 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:20 2011
Message-Id: <20110601081220.005434751@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:58 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [148/165] drm/radeon/cayman: setup hdp to invalidate and flush when
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 asked
Content-Length: 1243
Lines: 41

From: Dave Airlie <airlied@redhat.com>

commit 0b65f83f9d2fab47b9b6040fe75fc2cfc73032d4 upstream.

On cayman we need to set the bit to cause HDP flushes to invalidate the
HDP cache also.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/ni.c  |    4 ++++
 drivers/gpu/drm/radeon/nid.h |    2 ++
 2 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -931,6 +931,10 @@ static void cayman_gpu_init(struct radeo
 	WREG32(CB_PERF_CTR3_SEL_0, 0);
 	WREG32(CB_PERF_CTR3_SEL_1, 0);
 
+	tmp = RREG32(HDP_MISC_CNTL);
+	tmp |= HDP_FLUSH_INVALIDATE_CACHE;
+	WREG32(HDP_MISC_CNTL, tmp);
+
 	hdp_host_path_cntl = RREG32(HDP_HOST_PATH_CNTL);
 	WREG32(HDP_HOST_PATH_CNTL, hdp_host_path_cntl);
 
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -136,6 +136,8 @@
 #define	HDP_NONSURFACE_INFO				0x2C08
 #define	HDP_NONSURFACE_SIZE				0x2C0C
 #define HDP_ADDR_CONFIG  				0x2F48
+#define HDP_MISC_CNTL					0x2F4C
+#define 	HDP_FLUSH_INVALIDATE_CACHE			(1 << 0)
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0x3F88
 #define	GC_USER_SYS_RB_BACKEND_DISABLE			0x3F8C


