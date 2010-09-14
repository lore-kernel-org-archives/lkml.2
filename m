Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0INUXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:23:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63626 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0INUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 01/15] drm: use noop_llseek
Date: Tue, 14 Sep 2010 22:22:29 +0200
Message-Id: <1284495763-7506-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:L4mWwFlmZx/Qa5UtqCLL1goAndaFUvzr6/JzJYYAb7L
 mukLdNWyqP+ccLVIHUHFnlNE2nE5IC3AJNIHepGhO+S5QJDokb
 oBlFvWbwpunt2beOTqduNwHm2ciDjbMCb33x3Le2JSAW2jiwuX
 Z5hK9tP5x6eR9qaGXHRC7bHYZz1No+GuKR4eyBqg/2UoeBMneV
 /ji4//l4ZaPr3/+y8eAHw==
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
index b4250b2..fe69914 100644
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
index a5c66aa..5b6298b 100644
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
index 00befce..22ee9be 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -548,6 +548,7 @@ static struct drm_driver driver = {
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = i915_compat_ioctl,
 #endif
+		 .llseek = noop_llseek,
 	},
 
 	.pci_driver = {
diff --git a/drivers/gpu/drm/mga/mga_drv.c b/drivers/gpu/drm/mga/mga_drv.c
index 26d0d8c..ac64f0b 100644
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
index 1de5eb5..eb15345 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -393,6 +393,7 @@ static struct drm_driver driver = {
 #if defined(CONFIG_COMPAT)
 		.compat_ioctl = nouveau_compat_ioctl,
 #endif
+		.llseek = noop_llseek,
 	},
 	.pci_driver = {
 		.name = DRIVER_NAME,
diff --git a/drivers/gpu/drm/r128/r128_drv.c b/drivers/gpu/drm/r128/r128_drv.c
index 1e2971f..d42c76c 100644
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
index 795403b..29c1237 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -219,6 +219,7 @@ static struct drm_driver driver_old = {
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
index 776bf9e..4bb10ef 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -83,6 +83,7 @@ static struct drm_driver driver = {
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
index 72ec2e2..d237190 100644
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

