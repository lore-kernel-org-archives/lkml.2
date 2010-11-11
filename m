Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0KKAQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:16:03 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:36252 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0KKAQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:16:02 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] acpi: ENODEV needs errno.h
Date: Thu, 11 Nov 2010 01:15:51 +0100
Message-Id: <1289434551-32507-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build error when neither CONFIG_ACPI_VIDEO
nor CONFIG_ACPI_VIDEO_MODULE are enabled.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/acpi/video.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/acpi/video.h b/include/acpi/video.h
index 551793c..7a0797b 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -16,6 +16,9 @@ extern void acpi_video_unregister(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
+
+#include <linux/errno.h>
+
 static inline int acpi_video_register(void) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
-- 
1.6.6.1

