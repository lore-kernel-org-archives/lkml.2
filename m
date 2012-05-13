Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2EMQII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:08:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2EMQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:50 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 7/7] drm: do not change selected options based on EXPERT mode
Date: Sun, 13 May 2012 18:07:10 +0200
Message-Id: <1336925230-2853-8-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPERT mode is designed to toggle visibility of config options. It should
not have any other effect on config values. Imagine if a user wants to
tweak a single value that is protected by EXPERT mode. If they enable
EXPERT mode to change that single option, they might get side effects from
other subsystems which they didn't expect. This makes EXPERT mode totally
useless. Hence, simply let the user always select the framebuffer-console
manually.
Furthermore, with kmscon or wayland, users might want to disable CONFIG_VT
which is currently automatically selected by DRM_KMS_HELPER through
FRAMEBUFFER_CONSOLE if !EXPERT.

Cc: David Airlie <airlied@linux.ie>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/gpu/drm/Kconfig         |    1 -
 drivers/gpu/drm/nouveau/Kconfig |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index e354bc0..ded991c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -28,7 +28,6 @@ config DRM_KMS_HELPER
 	tristate
 	depends on DRM
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FRAMEBUFFER_CONSOLE_DETECT_PRIMARY if FRAMEBUFFER_CONSOLE
 	help
 	  FB and CRTC helpers for KMS drivers.
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 97a8126..d7e2536 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -8,7 +8,6 @@ config DRM_NOUVEAU
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	select ACPI_WMI if ACPI
-- 
1.7.10.2

