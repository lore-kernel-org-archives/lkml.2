Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2FNMiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:38:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57689 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2FNMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:38:24 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] smia: Fix compile failures
To: sakari.ailus@maxwell.research.nokia.com, linux-kernel@vger.kernel.org
Date: Thu, 14 Jun 2012 13:54:07 +0100
Message-ID: <20120614125347.18351.78744.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix compile of smia code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=43337
---

 drivers/media/video/smiapp/Kconfig       |    2 +-
 drivers/media/video/smiapp/smiapp-core.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/media/video/smiapp/Kconfig b/drivers/media/video/smiapp/Kconfig
index f7b35ff..fb99ff1 100644
--- a/drivers/media/video/smiapp/Kconfig
+++ b/drivers/media/video/smiapp/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_SMIAPP
 	tristate "SMIA++/SMIA sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAVE_CLK
 	select VIDEO_SMIAPP_PLL
 	---help---
 	  This is a generic driver for SMIA++/SMIA camera modules.
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index f518026..e8c93c8 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -32,6 +32,7 @@
 #include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
+#include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
 #include <media/v4l2-device.h>
 

