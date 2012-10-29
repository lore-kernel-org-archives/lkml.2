Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab2J2UCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:02:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59321 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab2J2UCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:02:01 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 5/7] PM / devfreq: governors: add GPL module license and allow module build
Date: Mon, 29 Oct 2012 15:01:46 -0500
Message-ID: <1351540908-12195-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPL module license and remove the static build
restrictions for building governors. This allows governors now
to be loaded on a need basis and reloaded independently of kernel
build

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/Kconfig                   |    8 ++++----
 drivers/devfreq/governor_performance.c    |    2 ++
 drivers/devfreq/governor_powersave.c      |    2 ++
 drivers/devfreq/governor_simpleondemand.c |    2 ++
 drivers/devfreq/governor_userspace.c      |    2 ++
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index f6b0a6e2..0f079be 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -30,7 +30,7 @@ if PM_DEVFREQ
 comment "DEVFREQ Governors"
 
 config DEVFREQ_GOV_SIMPLE_ONDEMAND
-	bool "Simple Ondemand"
+	tristate "Simple Ondemand"
 	help
 	  Chooses frequency based on the recent load on the device. Works
 	  similar as ONDEMAND governor of CPUFREQ does. A device with
@@ -39,7 +39,7 @@ config DEVFREQ_GOV_SIMPLE_ONDEMAND
 	  values to the governor with data field at devfreq_add_device().
 
 config DEVFREQ_GOV_PERFORMANCE
-	bool "Performance"
+	tristate "Performance"
 	help
 	  Sets the frequency at the maximum available frequency.
 	  This governor always returns UINT_MAX as frequency so that
@@ -47,7 +47,7 @@ config DEVFREQ_GOV_PERFORMANCE
 	  at any time.
 
 config DEVFREQ_GOV_POWERSAVE
-	bool "Powersave"
+	tristate "Powersave"
 	help
 	  Sets the frequency at the minimum available frequency.
 	  This governor always returns 0 as frequency so that
@@ -55,7 +55,7 @@ config DEVFREQ_GOV_POWERSAVE
 	  at any time.
 
 config DEVFREQ_GOV_USERSPACE
-	bool "Userspace"
+	tristate "Userspace"
 	help
 	  Sets the frequency at the user specified one.
 	  This governor returns the user configured frequency if there
diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
index 865a369..c72f942 100644
--- a/drivers/devfreq/governor_performance.c
+++ b/drivers/devfreq/governor_performance.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/devfreq.h>
+#include <linux/module.h>
 #include "governor.h"
 
 static int devfreq_performance_func(struct devfreq *df,
@@ -63,3 +64,4 @@ static void __exit devfreq_performance_exit(void)
 	return;
 }
 module_exit(devfreq_performance_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
index 8612c0f..0c6bed5 100644
--- a/drivers/devfreq/governor_powersave.c
+++ b/drivers/devfreq/governor_powersave.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/devfreq.h>
+#include <linux/module.h>
 #include "governor.h"
 
 static int devfreq_powersave_func(struct devfreq *df,
@@ -60,3 +61,4 @@ static void __exit devfreq_powersave_exit(void)
 	return;
 }
 module_exit(devfreq_powersave_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
index a870a24..0720ba8 100644
--- a/drivers/devfreq/governor_simpleondemand.c
+++ b/drivers/devfreq/governor_simpleondemand.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <linux/devfreq.h>
 #include <linux/math64.h>
 #include "governor.h"
@@ -143,3 +144,4 @@ static void __exit devfreq_simple_ondemand_exit(void)
 	return;
 }
 module_exit(devfreq_simple_ondemand_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index 34fb80f..35de6e8 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -14,6 +14,7 @@
 #include <linux/devfreq.h>
 #include <linux/pm.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include "governor.h"
 
 struct userspace_data {
@@ -158,3 +159,4 @@ static void __exit devfreq_userspace_exit(void)
 	return;
 }
 module_exit(devfreq_userspace_exit);
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

