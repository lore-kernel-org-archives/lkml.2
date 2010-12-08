Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0LHBoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:44:46 -0500
Received: from kroah.org ([198.145.64.141]:48747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0LHBAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.743011641@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [084/289] drm/radeon/kms: make sure blit addr masks are 64 bit
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 2126d0a4a205e2d6b763434f892524cd60f74228 upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600_blit_kms.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -650,8 +650,8 @@ void r600_kms_blit_copy(struct radeon_de
 			int src_x = src_gpu_addr & 255;
 			int dst_x = dst_gpu_addr & 255;
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;
 
 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
@@ -744,8 +744,8 @@ void r600_kms_blit_copy(struct radeon_de
 			int src_x = (src_gpu_addr & 255);
 			int dst_x = (dst_gpu_addr & 255);
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;
 
 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);


