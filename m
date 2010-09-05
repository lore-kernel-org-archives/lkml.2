Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab0IENeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:34:44 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:54068
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750728Ab0IENen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:34:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH] acpi: Provide decls for standalone compilation of video.h without ACPI
Date: Sun,  5 Sep 2010 14:35:57 +0100
Message-Id: <1283693757-8199-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
---
 include/acpi/video.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/acpi/video.h b/include/acpi/video.h
index 551793c..bcb4f00 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -16,6 +16,10 @@ extern void acpi_video_unregister(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
+
+#include <linux/errno.h> /* for ENODEV */
+struct acpi_device;
+
 static inline int acpi_video_register(void) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
@@ -26,4 +30,3 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 #endif
 
 #endif
-
-- 
1.7.1

