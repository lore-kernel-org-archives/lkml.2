Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0IMKTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:19:00 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47539 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0IMKTA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 13 Sep 2010 06:19:00 -0400
Message-Id: <4C8E16AE0200007800015ACF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:18:54 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <khali@linux-fr.org>
Cc: <fenghua.yu@intel.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: fix initialization of pkgtemp
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature availability should also be checked in the hotplug code path.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>

---
 drivers/hwmon/pkgtemp.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-pkgtemp-feature-check/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
@@ -281,9 +281,10 @@ static int __cpuinit pkgtemp_device_add(
 	int err;
 	struct platform_device *pdev;
 	struct pdev_entry *pdev_entry;
-#ifdef CONFIG_SMP
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-#endif
+
+	if (!cpu_has(c, X86_FEATURE_PTS))
+		return 0;
 
 	mutex_lock(&pdev_list_mutex);
 
@@ -399,11 +400,6 @@ static int __init pkgtemp_init(void)
 		goto exit;
 
 	for_each_online_cpu(i) {
-		struct cpuinfo_x86 *c = &cpu_data(i);
-
-		if (!cpu_has(c, X86_FEATURE_PTS))
-			continue;
-
 		err = pkgtemp_device_add(i);
 		if (err)
 			goto exit_devices_unreg;



