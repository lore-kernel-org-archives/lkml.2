Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2LaINX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 03:13:23 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62976 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2LaINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 03:13:18 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 31 Dec 2012 02:13:14 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors <lm-sensors@lm-sensors.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/2] hwmon: (vexpress) Fix build error seen if CONFIG_OF_DEVICE is not set
Date: Mon, 31 Dec 2012 00:13:08 -0800
Message-Id: <1356941588-25249-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1356941588-25249-1-git-send-email-linux@roeck-us.net>
References: <1356941588-25249-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
vexpress.c: In function ‘vexpress_hwmon_name_show’:
vexpress.c:34:2: error: implicit declaration of function
‘of_get_property’ [-Werror=implicit-function-declaration]
vexpress.c:34:27: warning: initialization makes pointer from integer
without a cast [enabled by default]
vexpress.c: In function ‘vexpress_hwmon_label_show’:
vexpress.c:43:22: warning: initialization makes pointer from integer
without a cast [enabled by default]

Seen if CONFIG_OF_DEVICE is not defined. of_get_property is declared in
of.h which is only included by of_device.h if CONFIG_OF_DEVICE is defined.
of.h needs to be included directly.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/vexpress.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress.c
index 86d7f6d..d867e6b 100644
--- a/drivers/hwmon/vexpress.c
+++ b/drivers/hwmon/vexpress.c
@@ -19,6 +19,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/vexpress.h>
-- 
1.7.9.7

