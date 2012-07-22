Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab2GVIKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 04:10:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52540 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2GVIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 04:10:31 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Cc: Fengguang Wu <wfg@linux.intel.com>,
        Devendra Naga <develkernel412222@gmail.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH] thermal: fix build error at thermal_sys.c
Date: Sun, 22 Jul 2012 13:55:22 +0545
Message-Id: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with the commit 67ff19 (Thermal: Make Thermal trip points writeable)
build error is introduced,

the following was reported from Fengguang Wu,

drivers/thermal/thermal_sys.c: In function 'create_trip_attrs':
drivers/thermal/thermal_sys.c:1216:3: error: 'count' undeclared (first use in this function)
drivers/thermal/thermal_sys.c:1216:3: note: each undeclared identifier is reported only once for each function it appears in

link:
http://www.spinics.net/lists/linux-kernel-janitors/msg12174.html

use the indx instead.

Cc: Durgadoss R <durgadoss.r@intel.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---

This patch is build-tested only.

 drivers/thermal/thermal_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 9f56250..1b4aa9d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1259,7 +1259,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int flag)
 		snprintf(tz->trip_type_attrs[indx].name, THERMAL_NAME_LENGTH,
 			 "trip_point_%d_type", indx);
 
-		sysfs_attr_init(&tz->trip_type_attrs[count].attr.attr);
+		sysfs_attr_init(&tz->trip_type_attrs[indx].attr.attr);
 		tz->trip_type_attrs[indx].attr.attr.name =
 						tz->trip_type_attrs[indx].name;
 		tz->trip_type_attrs[indx].attr.attr.mode = S_IRUGO;
-- 
1.7.9.5

