Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab2HGX2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:28:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180Ab2HGWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ortwin=20Gl=C3=BCck?= <odi@odi.ch>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: =?UTF-8?q?=5B=20084/122=5D=20drm/nouveau=3A=20init=20vblank=20requests=20list?=
Date: Tue,  7 Aug 2012 15:26:12 -0700
Message-Id: <20120807221956.616851050@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 715855457e6bc93e148caf8cb3b5dcabbf605b0d upstream.

Fixes kernel panic when vblank interrupt triggers before first sync to
vblank request.

(Besides init, remove some relevant leftovers from vblank rework)

Reported-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drv.h      |    2 --
 drivers/gpu/drm/nouveau/nouveau_irq.c      |    4 ----
 drivers/gpu/drm/nouveau/nouveau_software.h |    1 +
 3 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -689,8 +689,6 @@ struct drm_nouveau_private {
 	void (*irq_handler[32])(struct drm_device *);
 	bool msi_enabled;
 
-	struct list_head vbl_waiting;
-
 	struct {
 		struct drm_global_reference mem_global_ref;
 		struct ttm_bo_global_ref bo_global_ref;
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -41,12 +41,8 @@
 void
 nouveau_irq_preinstall(struct drm_device *dev)
 {
-	struct drm_nouveau_private *dev_priv = dev->dev_private;
-
 	/* Master disable */
 	nv_wr32(dev, NV03_PMC_INTR_EN_0, 0);
-
-	INIT_LIST_HEAD(&dev_priv->vbl_waiting);
 }
 
 int
--- a/drivers/gpu/drm/nouveau/nouveau_software.h
+++ b/drivers/gpu/drm/nouveau/nouveau_software.h
@@ -38,6 +38,7 @@ static inline void
 nouveau_software_context_new(struct nouveau_software_chan *pch)
 {
 	INIT_LIST_HEAD(&pch->flip);
+	INIT_LIST_HEAD(&pch->vblank.list);
 }
 
 static inline void


