Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1K2TEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:04:20 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58838 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754389Ab1K2TET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:04:19 -0500
From: Joe Perches <joe@perches.com>
To: Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] acerhdf: Message logging neatening
Date: Tue, 29 Nov 2011 11:04:06 -0800
Message-Id: <96a258354ce375bf80259f783506bbd7191b520d.1322593277.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <9be2717594eec36bdcc072a90d81b044500270e4.1322593277.git.joe@perches.com>
References: <9be2717594eec36bdcc072a90d81b044500270e4.1322593277.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_warn not pr_warning.
Coalesce formats.
Argument aligning.
Remove superfluous parentheses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/acerhdf.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 833c0ec..639db4d 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -262,12 +262,11 @@ static void acerhdf_change_fanstate(int state)
 	unsigned char cmd;
 
 	if (verbose)
-		pr_notice("fan %s\n", (state == ACERHDF_FAN_OFF) ?
-				"OFF" : "ON");
+		pr_notice("fan %s\n", state == ACERHDF_FAN_OFF ? "OFF" : "ON");
 
 	if ((state != ACERHDF_FAN_OFF) && (state != ACERHDF_FAN_AUTO)) {
 		pr_err("invalid fan state %d requested, setting to auto!\n",
-			state);
+		       state);
 		state = ACERHDF_FAN_AUTO;
 	}
 
@@ -282,19 +281,18 @@ static void acerhdf_check_param(struct thermal_zone_device *thermal)
 {
 	if (fanon > ACERHDF_MAX_FANON) {
 		pr_err("fanon temperature too high, set to %d\n",
-				ACERHDF_MAX_FANON);
+		       ACERHDF_MAX_FANON);
 		fanon = ACERHDF_MAX_FANON;
 	}
 
 	if (kernelmode && prev_interval != interval) {
 		if (interval > ACERHDF_MAX_INTERVAL) {
 			pr_err("interval too high, set to %d\n",
-				ACERHDF_MAX_INTERVAL);
+			       ACERHDF_MAX_INTERVAL);
 			interval = ACERHDF_MAX_INTERVAL;
 		}
 		if (verbose)
-			pr_notice("interval changed to: %d\n",
-					interval);
+			pr_notice("interval changed to: %d\n", interval);
 		thermal->polling_delay = interval*1000;
 		prev_interval = interval;
 	}
@@ -605,8 +603,8 @@ static int acerhdf_check_hardware(void)
 	}
 
 	if (!bios_cfg) {
-		pr_err("unknown (unsupported) BIOS version %s/%s/%s, "
-			"please report, aborting!\n", vendor, product, version);
+		pr_err("unknown (unsupported) BIOS version %s/%s/%s, please report, aborting!\n",
+		       vendor, product, version);
 		return -EINVAL;
 	}
 
@@ -616,8 +614,7 @@ static int acerhdf_check_hardware(void)
 	 */
 	if (!kernelmode) {
 		pr_notice("Fan control off, to enable do:\n");
-		pr_notice("echo -n \"enabled\" > "
-			"/sys/class/thermal/thermal_zone0/mode\n");
+		pr_notice("echo -n \"enabled\" > /sys/class/thermal/thermal_zone0/mode\n");
 	}
 
 	return 0;
-- 
1.7.6.405.gc1be0

