Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2GKUoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:44:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189Ab2GKUoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:44:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/2] PM / Sleep: Fix build warning in sysfs.c for CONFIG_PM_SLEEP unset
Date: Wed, 11 Jul 2012 22:49:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201207112247.21693.rjw@sisk.pl>
In-Reply-To: <201207112247.21693.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207112249.24593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The power/async device sysfs attribute is only used if both
CONFIG_PM_ADVANCED_DEBUG and CONFIG_PM_SLEEP are set, but the code
implementing it doesn't depend on CONFIG_PM_SLEEP.  As a result, a
build warning appears if CONFIG_PM_ADVANCED_DEBUG is set and
CONFIG_PM_SLEEP is not set.

Fix it by adding a #ifdef CONFIG_PM_SLEEP around the code in
question.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -474,6 +474,8 @@ static DEVICE_ATTR(runtime_enabled, 0444
 
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+
 static ssize_t async_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
@@ -500,6 +502,8 @@ static ssize_t async_store(struct device
 }
 
 static DEVICE_ATTR(async, 0644, async_show, async_store);
+
+#endif
 #endif /* CONFIG_PM_ADVANCED_DEBUG */
 
 static struct attribute *power_attrs[] = {

