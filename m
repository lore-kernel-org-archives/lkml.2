Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab0FIFEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:04:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47357 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0FIFEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:04:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Jun 2010 14:00:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: lm-sensors@lm-sensors.org, khali@linux-fr.org, mingo@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] fix hwmon/i5k_amb.c sysfs attribute for lockdep
Message-Id: <20100609140000.60975b2f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not familiar with this area but I need this patch for lockdep in mmotm.
please check.
-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

i5k_amb.ko uses dynamically allocated memory (by kmalloc) for
attributes passed to sysfs. So, sysfs_attr_init() should be called
for working happy with lockdep.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/hwmon/i5k_amb.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: mmotm-2.6.34-Jun6/drivers/hwmon/i5k_amb.c
===================================================================
--- mmotm-2.6.34-Jun6.orig/drivers/hwmon/i5k_amb.c
+++ mmotm-2.6.34-Jun6/drivers/hwmon/i5k_amb.c
@@ -289,6 +289,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_label;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -303,6 +304,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_amb_temp;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -318,6 +320,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_min;
 			iattr->s_attr.dev_attr.store = store_amb_min;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -333,6 +336,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_mid;
 			iattr->s_attr.dev_attr.store = store_amb_mid;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -348,6 +352,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_max;
 			iattr->s_attr.dev_attr.store = store_amb_max;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -362,6 +367,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_amb_alarm;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)

