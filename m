Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0IMKaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:30:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59014 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMKaO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 13 Sep 2010 06:30:14 -0400
Message-Id: <4C8E19500200007800015B15@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:30:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <khali@linux-fr.org>
Cc: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: {core,pkg,via-cpu}temp_device_remove() can
	 all be __cpuinit
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... as they're being called only from a __cpuinit function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/hwmon/coretemp.c    |    2 +-
 drivers/hwmon/pkgtemp.c     |    2 +-
 drivers/hwmon/via-cputemp.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
@@ -480,7 +480,7 @@ exit:
 	return err;
 }
 
-static void coretemp_device_remove(unsigned int cpu)
+static void __cpuinit coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	mutex_lock(&pdev_list_mutex);
--- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/pkgtemp.c	2010-09-01 09:00:45.000000000 +0200
@@ -337,7 +337,7 @@ exit:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void pkgtemp_device_remove(unsigned int cpu)
+static void __cpuinit pkgtemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	unsigned int i;
--- linux-2.6.36-rc4/drivers/hwmon/via-cputemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/via-cputemp.c	2010-09-13 00:00:00.000000000 +0200
@@ -238,7 +238,7 @@ exit:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void via_cputemp_device_remove(unsigned int cpu)
+static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	mutex_lock(&pdev_list_mutex);



