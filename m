Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2HXOxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:53:22 -0400
Received: from fep13.mx.upcmail.net ([62.179.121.33]:46149 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2HXOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:53:16 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <50379546.6070802@odi.ch>
Date: Fri, 24 Aug 2012 16:52:54 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: drm/nouveau: Work around a crash during boot if noaccel is set.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NB: still broken in 3.5 as well.

Signed-off-by: Ortwin Glück <odi@odi.ch>
---
diff --git a/drivers/gpu/drm/nouveau/nv50_display.c 
b/drivers/gpu/drm/nouveau/nv50_display.c
index b244d99..c7ffa63 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -650,6 +650,12 @@ nv50_display_vblank_crtc_handler(struct drm_device 
*dev, int crtc)
  	struct nouveau_software_priv *psw = nv_engine(dev, NVOBJ_ENGINE_SW);
  	struct nouveau_software_chan *pch, *tmp;

+        if (!psw) {
+                WARN_ON_ONCE(1);
+                printk(KERN_ERR "NULL software engine\n");
+                return;
+        }
+
  	list_for_each_entry_safe(pch, tmp, &psw->vblank, vblank.list) {
  		if (pch->vblank.head != crtc)
  			continue;
