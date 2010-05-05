Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0EEWgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:36:32 -0400
Received: from tex.lwn.net ([70.33.254.29]:50634 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0EEWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:35:07 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: [PATCH 3/5] viafb: Eliminate some global.h references
Date: Wed,  5 May 2010 16:34:42 -0600
Message-Id: <1273098884-21848-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273098884-21848-1-git-send-email-corbet@lwn.net>
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various subdev drivers (other than the framebuffer itself) no longer
need this file.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-gpio.c |    1 -
 drivers/video/via/via_i2c.c  |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index 63cb7ac..67d699c 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -10,7 +10,6 @@
 #include <linux/platform_device.h>
 #include "via-core.h"
 #include "via-gpio.h"
-#include "global.h"
 
 /*
  * The ports we know about.  Note that the port-25 gpios are not
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 84ec2d6..2291765 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -20,9 +20,11 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
 #include "via-core.h"
 #include "via_i2c.h"
-#include "global.h"
 
 /*
  * There can only be one set of these, so there's no point in having
-- 
1.7.0.1

