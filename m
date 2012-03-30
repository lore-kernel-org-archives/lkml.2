Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab2C3KY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:24:28 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675Ab2C3KSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 21/76] thermal: Fix for setting the thermal zone mode to
 enable/disable
Date: Fri, 30 Mar 2012 06:13:24 -0400
Message-id: <f1f0e2ac596f531c15b7b09ebeb8cfd011fffbd2.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Basically without this patch changing the mode of thermal zone
is not possible as wrong string size is passed to strncmp.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/thermal_sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index fab970d..022bacb 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -150,9 +150,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	if (!tz->ops->set_mode)
 		return -EPERM;
 
-	if (!strncmp(buf, "enabled", sizeof("enabled")))
+	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
-	else if (!strncmp(buf, "disabled", sizeof("disabled")))
+	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
 	else
 		result = -EINVAL;
-- 
1.7.10.rc2.19.gfae9d

