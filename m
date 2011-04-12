Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab1DLK1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:27:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:38629 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab1DLK1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:27:51 -0400
Subject: [PATCH] i915: select VIDEO_OUTPUT_CONTROL for ACPI_VIDEO
To: David Airlie <airlied@linux.ie>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Date: Tue, 12 Apr 2011 14:27:47 +0400
Message-ID: <20110412102747.3599.33792.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix Kconfig warning:

(DRM_I915 && STUB_POULSBO) selects ACPI_VIDEO which has unmet direct dependencies
(ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/gpu/drm/Kconfig  |    1 +
 drivers/gpu/stub/Kconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index a6feb78c..c58f691 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -96,6 +96,7 @@ config DRM_I915
 	# i915 depends on ACPI_VIDEO when ACPI is enabled
 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
 	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
 	select ACPI_BUTTON if ACPI
diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
index 70e60a4..4199179 100644
--- a/drivers/gpu/stub/Kconfig
+++ b/drivers/gpu/stub/Kconfig
@@ -5,6 +5,7 @@ config STUB_POULSBO
 	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
 	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
 	select THERMAL if ACPI

