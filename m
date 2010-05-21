Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab0EURBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:10 -0400
Received: from kroah.org ([198.145.64.141]:39093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934226Ab0EUQyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Magnus Damm <damm@opensource.se>, Rafael Wysocki <rjw@sisk.pl>,
       Dmitry Torokhov <dtor@mail.ru>, Eric Miao <eric.y.miao@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/38] platform_bus: allow custom extensions to system PM methods
Date: Fri, 21 May 2010 09:53:39 -0700
Message-Id: <1274460848-11377-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

When runtime PM for platform_bus was added, it allowed for platforms
to customize the runtime PM methods since they are defined as weak
symbols.

This patch allows platforms to also extend the system PM methods with
custom hooks so runtime PM and system PM extensions can be managed
together by custom platform-specific code.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Rafael Wysocki <rjw@sisk.pl>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ada6397..4d99c8b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -735,7 +735,7 @@ static void platform_pm_complete(struct device *dev)
 
 #ifdef CONFIG_SUSPEND
 
-static int platform_pm_suspend(struct device *dev)
+int __weak platform_pm_suspend(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -753,7 +753,7 @@ static int platform_pm_suspend(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_suspend_noirq(struct device *dev)
+int __weak platform_pm_suspend_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -769,7 +769,7 @@ static int platform_pm_suspend_noirq(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_resume(struct device *dev)
+int __weak platform_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
@@ -787,7 +787,7 @@ static int platform_pm_resume(struct device *dev)
 	return ret;
 }
 
-static int platform_pm_resume_noirq(struct device *dev)
+int __weak platform_pm_resume_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
-- 
1.7.0.3

