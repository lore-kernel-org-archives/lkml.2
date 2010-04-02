Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0DBBDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:03:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0DBBDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:03:07 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>
Date: Fri,  2 Apr 2010 03:02:14 +0200
Message-Id: <1270170140-325-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 1/2] Fix 'key f70f4b50 not in .data' in thermal_sys
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Initialize sysfs attributes before device_create_file call. Fixes
Bug #15548.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/thermal/thermal_sys.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5066de5..ecb181d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -505,6 +505,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	tz->temp_input.attr.attr.name = tz->temp_input.name;
 	tz->temp_input.attr.attr.mode = 0444;
 	tz->temp_input.attr.show = temp_input_show;
+	sysfs_attr_init(&tz->temp_input.attr.attr);
 	result = device_create_file(hwmon->device, &tz->temp_input.attr);
 	if (result)
 		goto unregister_hwmon_device;
@@ -517,6 +518,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
 			tz->temp_crit.attr.attr.mode = 0444;
 			tz->temp_crit.attr.show = temp_crit_show;
+			sysfs_attr_init(&tz->temp_crit.attr.attr);
 			result = device_create_file(hwmon->device,
 						    &tz->temp_crit.attr);
 			if (result)
@@ -725,6 +727,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		goto release_idr;
 
 	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	sysfs_attr_init(&dev->attr.attr);
 	dev->attr.attr.name = dev->attr_name;
 	dev->attr.attr.mode = 0444;
 	dev->attr.show = thermal_cooling_device_trip_point_show;
-- 
1.7.0

