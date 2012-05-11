Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2EKEiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:38:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2EKEiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:38:02 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: airlied@linux.ie, alan@linux.intel.com, kirill.shutemov@linux.intel.com
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] gma500: fix build when ACPI isn't set
Date: Fri, 11 May 2012 06:39:02 +0200
Message-Id: <1336711142-26788-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/gpu/drm/gma500/opregion.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/gma500/opregion.c b/drivers/gpu/drm/gma500/opregion.c
index 05661bf..e2fbf4d 100644
--- a/drivers/gpu/drm/gma500/opregion.c
+++ b/drivers/gpu/drm/gma500/opregion.c
@@ -258,6 +258,7 @@ void psb_intel_opregion_init(struct drm_device *dev)
 	if (!opregion->header)
 		return;
 
+#ifdef CONFIG_ACPI
 	if (opregion->acpi) {
 		/* Notify BIOS we are ready to handle ACPI video ext notifs.
 		 * Right now, all the events are handled by the ACPI video
@@ -268,6 +269,7 @@ void psb_intel_opregion_init(struct drm_device *dev)
 		system_opregion = opregion;
 		register_acpi_notifier(&psb_intel_opregion_notifier);
 	}
+#endif
 
 	if (opregion->asle)
 		psb_intel_opregion_enable_asle(dev);
@@ -281,12 +283,14 @@ void psb_intel_opregion_fini(struct drm_device *dev)
 	if (!opregion->header)
 		return;
 
+#ifdef CONFIG_ACPI
 	if (opregion->acpi) {
 		opregion->acpi->drdy = 0;
 
 		system_opregion = NULL;
 		unregister_acpi_notifier(&psb_intel_opregion_notifier);
 	}
+#endif
 
 	/* just clear all opregion memory pointers now */
 	iounmap(opregion->header);
-- 
1.7.8.5

