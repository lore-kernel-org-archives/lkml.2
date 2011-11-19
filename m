Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1KSVv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 16:51:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1KSVv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 16:51:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Sleep: Remove unnecessary label and jumps to it form PM core code
Date: Sat, 19 Nov 2011 22:54:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111192254.39049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The "End" label in device_prepare() in drivers/base/power/main.c is
not necessary and the jumps to it have no real effect, so remove them
all.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -1033,22 +1033,16 @@ static int device_prepare(struct device
 		if (dev->pm_domain->ops.prepare)
 			error = dev->pm_domain->ops.prepare(dev);
 		suspend_report_result(dev->pm_domain->ops.prepare, error);
-		if (error)
-			goto End;
 	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "preparing type ");
 		if (dev->type->pm->prepare)
 			error = dev->type->pm->prepare(dev);
 		suspend_report_result(dev->type->pm->prepare, error);
-		if (error)
-			goto End;
 	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "preparing class ");
 		if (dev->class->pm->prepare)
 			error = dev->class->pm->prepare(dev);
 		suspend_report_result(dev->class->pm->prepare, error);
-		if (error)
-			goto End;
 	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "preparing ");
 		if (dev->bus->pm->prepare)
@@ -1056,7 +1050,6 @@ static int device_prepare(struct device
 		suspend_report_result(dev->bus->pm->prepare, error);
 	}
 
- End:
 	device_unlock(dev);
 
 	return error;
