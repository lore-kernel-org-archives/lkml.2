Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2BXUOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:14:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52122 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab2BXUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:14:33 -0500
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <shahed@ti.com>, <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH 1/3] wl128x: Fix build errors when GPIOLIB is not enabled.
Date: Fri, 24 Feb 2012 14:14:29 -0600
Message-ID: <1330114471-26435-2-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
References: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix wl128x Kconfig to depend on GPIOLIB since TI_ST also
depends on GPIOLIB.

(.text+0xe6d60): undefined reference to `st_register'
(.text+0xe7016): undefined reference to `st_unregister'
(.text+0xe70ce): undefined reference to `st_unregister'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/media/radio/wl128x/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index 86b2857..ea1e654 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,8 +4,8 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL
-	select TI_ST if NET && GPIOLIB
+	depends on VIDEO_V4L2 && RFKILL && GPIOLIB
+	select TI_ST if NET
 	help
 	Choose Y here if you have this FM radio chip.
 
-- 
1.7.4.1

