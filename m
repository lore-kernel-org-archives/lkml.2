Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab1EaJGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:06:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:11094 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1EaJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:06:01 -0400
Date: Tue, 31 May 2011 11:04:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 1/3] thermal: Hide CONFIG_THERMAL_HWMON
Message-ID: <20110531110433.511bdc7f@endymion.delvare>
In-Reply-To: <20110531110016.7b232c85@endymion.delvare>
References: <20110531110016.7b232c85@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
Anybody running a kernel >= 2.6.40 would also be running a recent
enough version of lm-sensors.

Actually having CONFIG_THERMAL_HWMON is pretty convenient so instead
of dropping it, we keep it but hide it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/feature-removal-schedule.txt |    9 ---------
 drivers/thermal/Kconfig                    |    8 ++------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- linux-3.0-rc1.orig/Documentation/feature-removal-schedule.txt	2011-05-31 10:51:56.000000000 +0200
+++ linux-3.0-rc1/Documentation/feature-removal-schedule.txt	2011-05-31 10:51:59.000000000 +0200
@@ -310,15 +310,6 @@ Who:	Ravikiran Thirumalai <kiran@scalex8
 
 ---------------------------
 
-What:	CONFIG_THERMAL_HWMON
-When:	January 2009
-Why:	This option was introduced just to allow older lm-sensors userspace
-	to keep working over the upgrade to 2.6.26. At the scheduled time of
-	removal fixed lm-sensors (2.x or 3.x) should be readily available.
-Who:	Rene Herman <rene.herman@gmail.com>
-
----------------------------
-
 What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
 	(in net/core/net-sysfs.c)
 When:	After the only user (hal) has seen a release with the patches
--- linux-3.0-rc1.orig/drivers/thermal/Kconfig	2011-05-31 10:51:56.000000000 +0200
+++ linux-3.0-rc1/drivers/thermal/Kconfig	2011-05-31 10:51:59.000000000 +0200
@@ -14,11 +14,7 @@ menuconfig THERMAL
 	  If you want this support, you should say Y or M here.
 
 config THERMAL_HWMON
-	bool "Hardware monitoring support"
+	bool
 	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
-	help
-	  The generic thermal sysfs driver's hardware monitoring support
-	  requires a 2.10.7/3.0.2 or later lm-sensors userspace.
-
-	  Say Y if your user-space is new enough.
+	default y

-- 
Jean Delvare
