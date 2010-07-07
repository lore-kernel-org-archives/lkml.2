Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0GGVkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab0GGVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 01/18] drm: use noop_llseek
Date: Wed,  7 Jul 2010 23:40:03 +0200
Message-Id: <1278538820-1392-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HBYfIXBHOSMUonnmSPF1X1TqxA6076A7byQgjp8Ic2i
 MuBjeAWUrMVLvFp9xB/aulhhy9SwMp4QJjRSFSvt1VCgyviowO
 KEVLCXLt4UTTSKc0CmnyD0GANbKmfCfI+nXZ2utFpGSSz+0DcN
 BVYJsv95Dp3jZcEiY6sz54SrYPNkKtaIR99Ab/44Fdh92IDSaL
 54cF6B/ocjvvDjZrZdAog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drm device drivers currently allow seeking on the
character device but never care about the actual
file position.

When we change the default llseek operation to be
no_llseek, calling llseek on a drm device would
return an error condition, which is an API change.

Explicitly setting noop_llseek lets us keep the
current API.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 Documentation/DocBook/drm.tmpl        |    1 +
 drivers/gpu/drm/i810/i810_drv.c       |    1 +
 drivers/gpu/drm/i830/i830_drv.c       |    1 +
 drivers/gpu/drm/i915/i915_drv.c       |    1 +
 drivers/gpu/drm/mga/mga_drv.c         |    1 +
 drivers/gpu/drm/nouveau/nouveau_drv.c |    1 +
 drivers/gpu/drm/r128/r128_drv.c       |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c   |    1 +
 drivers/gpu/drm/savage/savage_drv.c   |    1 +
 drivers/gpu/drm/sis/sis_drv.c         |    1 +
 drivers/gpu/drm/tdfx/tdfx_drv.c       |    1 +
 drivers/gpu/drm/via/via_drv.c         |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    1 +
 13 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index 910c923..2861055 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@ -136,6 +136,7 @@
 #ifdef CONFIG_COMPAT
 		.compat_ioctl = i915_compat_ioctl,
 #endif
+		.llseek = noop_llseek,
 		},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
index c1e0275..199fdfa 100644
--- a/drivers/gpu/drm/i810/i810_drv.c
+++ b/drivers/gpu/drm/i810/i810_drv.c
@@ -63,6 +63,7 @@ static struct drm_driver driver = {
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/i830/i830_drv.c b/drivers/gpu/drm/i830/i830_drv.c
index 44f990b..3be1d7d 100644
--- a/drivers/gpu/drm/i830/i830_drv.c
+++ b/drivers/gpu/drm/i830/i830_drv.c
@@ -74,6 +74,7 @@ static struct drm_driver driver = {
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 423dc90..bd8c139 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -547,6 +547,7 @@ static struct drm_driver driver = {
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = i915_compat_ioctl,
 #endif
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/mga/mga_drv.c b/drivers/gpu/drm/mga/mga_drv.c
index ddfe161..524185f 100644
--- a/drivers/gpu/drm/mga/mga_drv.c
+++ b/drivers/gpu/drm/mga/mga_drv.c
@@ -75,6 +75,7 @@ static struct drm_driver driver = {
 #ifdef CONFIG_COMPAT
 		.compat_ioctl = mga_compat_ioctl,
 #endif
+		.llseek = noop_llseek,
 	},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 2737704..9505fa6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -400,6 +400,7 @@ static struct drm_driver driver = {
 #if defined(CONFIG_COMPAT)
 		.compat_ioctl = nouveau_compat_ioctl,
 #endif
+		.llseek = noop_llseek,
 	},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/r128/r128_drv.c b/drivers/gpu/drm/r128/r128_drv.c
index b806fdc..dc22c6e 100644
--- a/drivers/gpu/drm/r128/r128_drv.c
+++ b/drivers/gpu/drm/r128/r128_drv.c
@@ -71,6 +71,7 @@ static struct drm_driver driver = {
 #ifdef CONFIG_COMPAT
 		.compat_ioctl = r128_compat_ioctl,
 #endif
+		.llseek = noop_llseek,
 	},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index e166fe4..e79dcf5 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -218,6 +218,7 @@ static struct drm_driver driver_old = {
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = radeon_compat_ioctl,
 #endif
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/savage/savage_drv.c b/drivers/gpu/drm/savage/savage_drv.c
index 021de44..2a2830f 100644
--- a/drivers/gpu/drm/savage/savage_drv.c
+++ b/drivers/gpu/drm/savage/savage_drv.c
@@ -54,6 +54,7 @@ static struct drm_driver driver = {
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 4fd1f06..4f7f80f 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -84,6 +84,7 @@ static struct drm_driver driver = {
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
+		 .llseek = noop_llseek,
 	},
 	.pci_driver = {
 		 .name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/tdfx/tdfx_drv.c b/drivers/gpu/drm/tdfx/tdfx_drv.c
index ec5a43e..640567e 100644
--- a/drivers/gpu/drm/tdfx/tdfx_drv.c
+++ b/drivers/gpu/drm/tdfx/tdfx_drv.c
@@ -52,6 +52,7 @@ static struct drm_driver driver = {
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
+		 .llseek = noop_llseek,
 	},
 	.pci_driver = {
 		 .name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/via/via_drv.c b/drivers/gpu/drm/via/via_drv.c
index 7a1b210..b8984a5 100644
--- a/drivers/gpu/drm/via/via_drv.c
+++ b/drivers/gpu/drm/via/via_drv.c
@@ -62,6 +62,7 @@ static struct drm_driver driver = {
 		.mmap = drm_mmap,
 		.poll = drm_poll,
 		.fasync = drm_fasync,
+		.llseek = noop_llseek,
 		},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index b793c8c..83d2844 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -745,6 +745,7 @@ static struct drm_driver driver = {
 #if defined(CONFIG_COMPAT)
 		 .compat_ioctl = drm_compat_ioctl,
 #endif
+		 .llseek = noop_llseek,
 		 },
 	.pci_driver = {
 		       .name = VMWGFX_DRIVER_NAME,
-- 
1.7.1

