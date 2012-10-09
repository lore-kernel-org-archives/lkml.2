Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2JIUOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab2JIUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v2 7/8] video: mark nuc900fb_map_video_memory as __devinit
Date: Tue,  9 Oct 2012 22:13:57 +0200
Message-Id: <1349813638-4617-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qBSgkGYFMYa4dOCRVCzrF6MsyECZcuEcVvfF7NJVVLk
 5x1HyT4Hk3+Sfg8rC16qF9zPDULqK267ZDRGgJ/xtdT5JTWdnw
 w5NsArf/pu6NABsXK558qI8js3LRNrHaGgKkV6yhCC5yEXSU1e
 bZk08admbd4o6jq80/T6pVv1rlQoG6Mc4gH223eeFh65iGSt0H
 xh0bi2Pq4tQw5Xmkh4v+Uo5vweh94hjig5zKTIjGpLEUO6We1N
 t4JcMu1lx4QhH8lQOaD+ypethPt1fNEjOKp5jljKNskSjDUJTM
 VBRYiyxINrjauSMlWMk/UUI+16Q/IuXRMjjI3AoYwQ8FD8K6Qb
 laezmARzsH+IvE3zc2zazPuJClfJjTpI0xngAEOu8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nuc900fb_map_video_memory is called by an devinit function
that may be called at run-time, but the function itself is
marked __init and will be discarded after boot.

To avoid calling into a function that may have been overwritten,
mark nuc900fb_map_video_memory itself as __devinit.

Without this patch, building nuc950_defconfig results in:

WARNING: drivers/video/built-in.o(.devinit.text+0x26c): Section mismatch in reference from the function nuc900fb_probe() to the function .init.text:nuc900fb_map_video_memory()
The function __devinit nuc900fb_probe() references
a function __init nuc900fb_map_video_memory().
If nuc900fb_map_video_memory is only used by nuc900fb_probe then
annotate nuc900fb_map_video_memory with a matching annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/nuc900fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index e10f551..b31b12b 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -387,7 +387,7 @@ static int nuc900fb_init_registers(struct fb_info *info)
  *    The buffer should be a non-cached, non-buffered, memory region
  *    to allow palette and pixel writes without flushing the cache.
  */
-static int __init nuc900fb_map_video_memory(struct fb_info *info)
+static int __devinit nuc900fb_map_video_memory(struct fb_info *info)
 {
 	struct nuc900fb_info *fbi = info->par;
 	dma_addr_t map_dma;
-- 
1.7.10

