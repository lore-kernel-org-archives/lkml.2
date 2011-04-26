Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1DZPCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:02:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47874 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab1DZPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:02:15 -0400
Date: Tue, 26 Apr 2011 17:02:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 1/3] thermal: Hide CONFIG_THERMAL_HWMON
Message-ID: <20110426170208.504b04e9@endymion.delvare>
In-Reply-To: <20110426165600.1d9ac91b@endymion.delvare>
References: <20110426165600.1d9ac91b@endymion.delvare>
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
of dopping it, we keep it but hide it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/feature-removal-schedule.txt |    9 ---------
 drivers/thermal/Kconfig                    |    8 ++------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- linux-2.6.39-rc4.orig/Documentation/feature-removal-schedule.txt	2011-04-25 16:16:10.000000000 +0200
+++ linux-2.6.39-rc4/Documentation/feature-removal-schedule.txt	2011-04-26 09:29:09.000000000 +0200
@@ -295,15 +295,6 @@ Who:	Ravikiran Thirumalai <kiran@scalex8
 
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
--- linux-2.6.39-rc4.orig/drivers/thermal/Kconfig	2011-04-25 16:16:10.000000000 +0200
+++ linux-2.6.39-rc4/drivers/thermal/Kconfig	2011-04-26 09:32:30.000000000 +0200
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
