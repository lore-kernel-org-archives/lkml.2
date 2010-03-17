Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0CQXSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:18:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46972 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0CQXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:18:20 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Dmitry Torokhov <dtor@mail.ru>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: [RFC/PATCH] platform_bus: allow custom extensions to system PM methods
Date: Wed, 17 Mar 2010 16:18:15 -0700
Message-Id: <1268867896-7616-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When runtime PM for platform_bus was added, it allowed for platforms
to customize the runtime PM methods since they are defined as weak
symbols.

This patch allows platforms to also extend the system PM methods with
custom hooks so runtime PM and system PM extensions can be managed
together by custom platform-specific code.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/base/platform.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1ba9d61..93d37d0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -729,7 +729,7 @@ static void platform_pm_complete(struct device *dev)
 
 #ifdef CONFIG_SUSPEND
 
-static int platform_pm_suspend(struct device *dev)
+int __weak platform_pm_suspend(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -747,7 +747,7 @@ static int platform_pm_suspend(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_suspend_noirq(struct device *dev)
+int __weak platform_pm_suspend_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -763,7 +763,7 @@ static int platform_pm_suspend_noirq(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_resume(struct device *dev)
+int __weak platform_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -781,7 +781,7 @@ static int platform_pm_resume(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_resume_noirq(struct device *dev)
+int __weak platform_pm_resume_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
-- 
1.7.0.2

