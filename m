Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2JEO7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:59:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2JEOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:55:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 12/16] video: mark nuc900fb_map_video_memory as __devinit
Date: Fri,  5 Oct 2012 16:55:26 +0200
Message-Id: <1349448930-23976-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:cc/kpoClP7aUEJhGBNliu/t6XaDfDcP4w0yU2Joapd8
 ZaV78CVCDCUhGaLk7tEaY90ebsVpm210oqbJiOkPvwpPe/gAxO
 hUcoyTma/rFmssnj5Q92aPhUFCJCfF7ohElnyUGSXkPtoOEwUL
 tLZquttmZEzlDamSnKNbCX2jESpmqSN+mezmeRuCM+l26vTG+H
 iwTECJUSal75UbucKeqlKPmkPJkkfukoABZX7lcyv2ZklJ59Mw
 2TbL/wf0gjEqkP18YRplWNsGzVlz8APEEOrOApvm0XIAvYSkG9
 QQ9DANESR/Yy9rJRhW3LjXZllav4DblsXlyg80MNzU3+xz49GJ
 SPVgoY2BIZMhz6ENeYNATQ7+EwT9D+2USJukRrMcxLnAPHAKCm
 H5BdGCfxfwpk6GLTSoIsmV/Mr6mxNuCl1g=
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

