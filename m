Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2GIWqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:46:19 -0400
Received: from home.keithp.com ([63.227.221.253]:49170 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2GIWqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:46:18 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2012 18:46:17 EDT
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm: use drm_compat_ioctl for 32-bit apps
Date: Mon,  9 Jul 2012 15:40:07 -0700
Message-Id: <1341873607-26847-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the DRM drivers appear to be missing the .compat_ioctl file
operation entry necessary for 32-bit application compatibility.

This patch  uses drm_compat_ioctl for all drivers which don't have
their own, and which are using drm_ioctl for .unlocked_ioctl.

This leaves drivers/gpu/drm/psb/psb_drv.c unchanged; it has a custom
.unlocked_ioctl and will presumably need a custom .compat_ioctl as
well.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/ast/ast_drv.c           |    3 +++
 drivers/gpu/drm/cirrus/cirrus_drv.c     |    3 +++
 drivers/gpu/drm/exynos/exynos_drm_drv.c |    3 +++
 drivers/gpu/drm/i810/i810_dma.c         |    3 +++
 drivers/gpu/drm/i810/i810_drv.c         |    3 +++
 drivers/gpu/drm/mgag200/mgag200_drv.c   |    3 +++
 drivers/gpu/drm/savage/savage_drv.c     |    3 +++
 drivers/gpu/drm/sis/sis_drv.c           |    3 +++
 drivers/gpu/drm/tdfx/tdfx_drv.c         |    3 +++
 drivers/gpu/drm/udl/udl_drv.c           |    3 +++
 drivers/gpu/drm/via/via_drv.c           |    3 +++
 11 files changed, 33 insertions(+)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index d0c4574..3616480 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -193,6 +193,9 @@ static const struct file_operations ast_fops = {
 	.mmap = ast_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.read = drm_read,
 };
 
diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 7053140..b83a2d7 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -74,6 +74,9 @@ static const struct file_operations cirrus_driver_fops = {
 	.unlocked_ioctl = drm_ioctl,
 	.mmap = cirrus_mmap,
 	.poll = drm_poll,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.fasync = drm_fasync,
 };
 static struct drm_driver driver = {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index d6de2e0..6b07cfe 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -240,6 +240,9 @@ static const struct file_operations exynos_drm_driver_fops = {
 	.poll		= drm_poll,
 	.read		= drm_read,
 	.unlocked_ioctl	= drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.release	= drm_release,
 };
 
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index fa94391..6e8f935 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -115,6 +115,9 @@ static const struct file_operations i810_buffer_fops = {
 	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
index ec12f7d..8e50757 100644
--- a/drivers/gpu/drm/i810/i810_drv.c
+++ b/drivers/gpu/drm/i810/i810_drv.c
@@ -51,6 +51,9 @@ static const struct file_operations i810_driver_fops = {
 	.mmap = drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index 93e832d..895a67e 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -81,6 +81,9 @@ static const struct file_operations mgag200_driver_fops = {
 	.mmap = mgag200_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.read = drm_read,
 };
 
diff --git a/drivers/gpu/drm/savage/savage_drv.c b/drivers/gpu/drm/savage/savage_drv.c
index 89afe0b..c77823a 100644
--- a/drivers/gpu/drm/savage/savage_drv.c
+++ b/drivers/gpu/drm/savage/savage_drv.c
@@ -43,6 +43,9 @@ static const struct file_operations savage_driver_fops = {
 	.mmap = drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index dd14cd1..02cd328 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -74,6 +74,9 @@ static const struct file_operations sis_driver_fops = {
 	.mmap = drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/tdfx/tdfx_drv.c b/drivers/gpu/drm/tdfx/tdfx_drv.c
index 1613c78..3af8832 100644
--- a/drivers/gpu/drm/tdfx/tdfx_drv.c
+++ b/drivers/gpu/drm/tdfx/tdfx_drv.c
@@ -49,6 +49,9 @@ static const struct file_operations tdfx_driver_fops = {
 	.mmap = drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 6e52069..9f84128 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -66,6 +66,9 @@ static const struct file_operations udl_driver_fops = {
 	.unlocked_ioctl	= drm_ioctl,
 	.release = drm_release,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/gpu/drm/via/via_drv.c b/drivers/gpu/drm/via/via_drv.c
index 02661f3..6061776 100644
--- a/drivers/gpu/drm/via/via_drv.c
+++ b/drivers/gpu/drm/via/via_drv.c
@@ -65,6 +65,9 @@ static const struct file_operations via_driver_fops = {
 	.mmap = drm_mmap,
 	.poll = drm_poll,
 	.fasync = drm_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
-- 
1.7.10.4

