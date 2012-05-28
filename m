Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab2E1JEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:04:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63151 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2E1JEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:04:12 -0400
From: Eric Miao <eric.miao@canonical.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Eric Miao <eric.miao@canonical.com>
Subject: [PATCH] fbdev: make FIRMWARE_EDID depends on X86
Date: Mon, 28 May 2012 17:04:15 +0800
Message-Id: <1338195855-14462-1-git-send-email-eric.miao@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only place where CONFIG_FIRMWARE_EDID is used is in fbmon.c,
and only when CONFIG_X86 is defined, this implied dependency will
be better specified in Kconfig.  Otherwise, CONFIG_FIRMWARE_EDID
can be turned on pointlessly for other architectures, and causing
a bit confusion when doing configs across different architectures.

Signed-off-by: Eric Miao <eric.miao@canonical.com>
---
 drivers/video/Kconfig |    2 +-
 drivers/video/fbmon.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a290be5..61af035 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -69,7 +69,7 @@ menuconfig FB
 
 config FIRMWARE_EDID
        bool "Enable firmware EDID"
-       depends on FB
+       depends on FB && X86
        default n
        ---help---
          This enables access to the EDID transferred from the firmware.
diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index cef6557..e8ada4d 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1458,7 +1458,7 @@ int fb_validate_mode(const struct fb_var_screeninfo *var, struct fb_info *info)
 		-EINVAL : 0;
 }
 
-#if defined(CONFIG_FIRMWARE_EDID) && defined(CONFIG_X86)
+#ifdef CONFIG_FIRMWARE_EDID
 
 /*
  * We need to ensure that the EDID block is only returned for
-- 
1.7.9.5

