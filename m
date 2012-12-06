Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424648Ab2LFRYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:24:21 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49786 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424456Ab2LFRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:24:20 -0500
From: Cong Ding <dinggnu@gmail.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] gpu: drm/nouveau/core/engine/disp/dacnv50.c: fix var uninit issue
Date: Thu,  6 Dec 2012 17:23:49 +0000
Message-Id: <1354814636-21925-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable "ret" might be uninitialized in the "default" branch of "switch"

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
index d0817d9..ae19dec 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
@@ -64,7 +64,7 @@ nv50_dac_mthd(struct nouveau_object *object, u32 mthd, void *args, u32 size)
 	struct nv50_disp_priv *priv = (void *)object->engine;
 	const u8 or = (mthd & NV50_DISP_DAC_MTHD_OR);
 	u32 *data = args;
-	int ret;
+	int ret = 0;
 
 	if (size < sizeof(u32))
 		return -EINVAL;
-- 
1.7.4.5

