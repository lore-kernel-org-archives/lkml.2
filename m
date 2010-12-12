Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0LMAYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:24:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44827 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0LLXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [46/223] drm/radeon/kms: make sure blit addr masks are 64 bit
Message-Id: <20101212234543.4E72FB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 2126d0a4a205e2d6b763434f892524cd60f74228 upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/r600_blit_kms.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/gpu/drm/radeon/r600_blit_kms.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ linux/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -623,8 +623,8 @@ void r600_kms_blit_copy(struct radeon_de
 			int src_x = src_gpu_addr & 255;
 			int dst_x = dst_gpu_addr & 255;
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;
 
 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
@@ -717,8 +717,8 @@ void r600_kms_blit_copy(struct radeon_de
 			int src_x = (src_gpu_addr & 255);
 			int dst_x = (dst_gpu_addr & 255);
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;
 
 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
