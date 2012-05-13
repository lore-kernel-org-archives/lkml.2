Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2EMQHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:07:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47592 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2EMQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:45 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/7] Media: Do not change default values in EXPERT mode
Date: Sun, 13 May 2012 18:07:05 +0200
Message-Id: <1336925230-2853-3-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expert mode was designed to toggle visibility of options and not to
change their behavior. If a user wants to tweak a single value and
enables EXPERT mode to do this, he will have several unexpected
side effects when other subsystems toggle their default values based
on EXPERT mode. This makes EXPERT pretty useless.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/media/common/tuners/Kconfig |    1 -
 drivers/media/dvb/frontends/Kconfig |    1 -
 drivers/media/video/Kconfig         |    2 +-
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 4a6d5ce..0bb2956 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -35,7 +35,6 @@ config MEDIA_TUNER
 config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default y if EXPERT
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 2124670..1b0c854 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,6 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default y if EXPERT
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..843d317 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -100,7 +100,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EXPERT
+	default y
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
-- 
1.7.10.2

