Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2JAIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:17:21 -0400
Received: from fep27.mx.upcmail.net ([62.179.121.47]:48928 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2JAIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:17:19 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 04:17:18 EDT
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <50694DBA.6050702@odi.ch>
Date: Mon, 01 Oct 2012 10:00:58 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120824 Thunderbird/10.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/nouveau: fix crash regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work around a crash during boot if noaccel is set.

NB: still broken in 3.5 as well, used to work in 3.4. Why are people 
ignoring this? It's a regression!

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
