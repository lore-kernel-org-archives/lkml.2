Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1EFWua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:50:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1EFWua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:50:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Wakeup: Fix build warning related to the "wakeup" sysfs file
Date: Sat, 7 May 2011 00:50:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105070050.55235.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The "wakeup" device sysfs file is only created if CONFIG_PM_SLEEP
is set, so put it under CONFIG_PM_SLEEP and make a build warning
related to it go away.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -212,8 +212,9 @@ static ssize_t autosuspend_delay_ms_stor
 static DEVICE_ATTR(autosuspend_delay_ms, 0644, autosuspend_delay_ms_show,
 		autosuspend_delay_ms_store);
 
-#endif
+#endif /* CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_SLEEP
 static ssize_t
 wake_show(struct device * dev, struct device_attribute *attr, char * buf)
 {
@@ -248,7 +249,6 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
-#ifdef CONFIG_PM_SLEEP
 static ssize_t wakeup_count_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
