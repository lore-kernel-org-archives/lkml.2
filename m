Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0CZRnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:43:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54636 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718Ab0CZRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:42:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH/RFC] platform_bus: Allow runtime PM by default
Date: Fri, 26 Mar 2010 17:42:50 +0000
Message-Id: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the default runtime PM callbacks for platform devices return
-ENOSYS, preventing the use of runtime PM platforms until they have
provided at least a default implementation. This hinders the use of
runtime PM by devices which work with many platforms such as memory
mapped devices, MFDs and on chip IPs shared by multiple architectures.

Change the default implementation to the standard pm_generic_runtime
one, allowing drivers to use runtime PM without per-architecture
changes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I'm not 100% sure why the curret implementation returns -ENOSYS - I've
got a horrible feeling I might be breaking something somewhere.

 drivers/base/platform.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 43479a9..eb0f8d9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -967,17 +967,17 @@ static int platform_pm_restore_noirq(struct device *dev)
 
 int __weak platform_pm_runtime_suspend(struct device *dev)
 {
-	return -ENOSYS;
+	return pm_generic_runtime_suspend(dev);
 };
 
 int __weak platform_pm_runtime_resume(struct device *dev)
 {
-	return -ENOSYS;
+	return pm_generic_runtime_resume(dev);
 };
 
 int __weak platform_pm_runtime_idle(struct device *dev)
 {
-	return -ENOSYS;
+	return pm_generic_runtime_idle(dev);
 };
 
 #else /* !CONFIG_PM_RUNTIME */
-- 
1.7.0.2

