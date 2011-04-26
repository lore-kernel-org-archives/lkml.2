Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1DZM00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57156 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1DZM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:23 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 03/21] drm/radeon/kms: make sure blit addr masks are 64 bit" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:21 +0200
Message-Id: <1303820781-3456-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 03/21] drm/radeon/kms: make sure blit addr masks are 64 bit

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 223bb76ca84477bbcf93b8ed3d778de9f1c4f8a4 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 6 Oct 2010 00:13:04 -0400
Subject: [PATCH 03/21] drm/radeon/kms: make sure blit addr masks are 64 bit

commit 2126d0a4a205e2d6b763434f892524cd60f74228 upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r600_blit_kms.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c b/drivers/gpu/drm/radeon/r600_blit_kms.c
index 446b765..d6a30a9 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -629,8 +629,8 @@ void r600_kms_blit_copy(struct radeon_device *rdev,
 			int src_x = src_gpu_addr & 255;
 			int dst_x = dst_gpu_addr & 255;
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;

 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
@@ -723,8 +723,8 @@ void r600_kms_blit_copy(struct radeon_device *rdev,
 			int src_x = (src_gpu_addr & 255);
 			int dst_x = (dst_gpu_addr & 255);
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;

 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
--
1.7.0.4

