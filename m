Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2IKNCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:02:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49956 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2IKNAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Prisk <linux@prisktech.co.nz>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 10/16] ARM: vt8500: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:44 +0200
Message-Id: <1347368390-31252-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lDHPzoOJXpp5aaa/F4fhKBakzBNjsYb0I5wS5G63EgF
 pU5vWDqSdyRiyuYK5Q0vdW0V0oJPOFVxE7faBMyyvNgQNCT8pp
 bAvZqEGVb32Jd5aagsO8O9B8kALF6jtL00W9caZWgOj9usuXt7
 eYEhK/vEAZoB/I3a3v4d00sGnELqqcc04UlUuubM3klNuX51hp
 vE4F9yCK1xWAdRO+5zNqdZX5QOmkxXLgJ0ms+ByabohEBxX5cg
 pohNulVWdGRdI6TDQUGqWMYzDLibe2Pzby5n/aVhoo9pDKlqmp
 PpB5+btIeM9FWeSe7lcd93nGE1/rtXTcy92QQH9JpyziOsc5Q9
 MlYMW8EjVaQfnrc2o/ZMckDTYpvojtqLz46hJ46xkc9ji0zwO/
 M2PRyhxvXDPf7UWbbnmsfsE4nni2YPkTZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the vt8500 include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 arch/arm/mach-vt8500/devices.c                                       |    2 +-
 drivers/video/vt8500lcdfb.c                                          |    2 +-
 drivers/video/wm8505fb.c                                             |    2 +-
 .../vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h    |    0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/arm/mach-vt8500/include/mach/vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h (100%)

diff --git a/arch/arm/mach-vt8500/devices.c b/arch/arm/mach-vt8500/devices.c
index 1fcdc36..82b4bce 100644
--- a/arch/arm/mach-vt8500/devices.c
+++ b/arch/arm/mach-vt8500/devices.c
@@ -23,7 +23,7 @@
 
 #include <asm/mach/arch.h>
 
-#include <mach/vt8500fb.h>
+#include <linux/platform_data/video-vt8500lcdfb.h>
 #include <mach/i8042.h>
 #include "devices.h"
 
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 2a5fe6e..66a74f9 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -30,7 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <mach/vt8500fb.h>
+#include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "vt8500lcdfb.h"
 #include "wmt_ge_rops.h"
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index c8703bd..ffeff48 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -29,7 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <mach/vt8500fb.h>
+#include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "wm8505fb_regs.h"
 #include "wmt_ge_rops.h"
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500fb.h b/include/linux/platform_data/video-vt8500lcdfb.h
similarity index 100%
rename from arch/arm/mach-vt8500/include/mach/vt8500fb.h
rename to include/linux/platform_data/video-vt8500lcdfb.h
-- 
1.7.10

