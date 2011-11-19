Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1KSWkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 17:40:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47773 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab1KSWkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 17:40:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Sleep: Simplify device_suspend_noirq()
Date: Sat, 19 Nov 2011 23:43:03 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111192343.03677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove a few if () and return statements in device_suspend_noirq()
that aren't really necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -763,31 +763,23 @@ static pm_message_t resume_event(pm_mess
  */
 static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
-	int error;
+	int error = 0;
 
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "LATE power domain ");
 		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
-		if (error)
-			return error;
 	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "LATE type ");
 		error = pm_noirq_op(dev, dev->type->pm, state);
-		if (error)
-			return error;
 	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "LATE class ");
 		error = pm_noirq_op(dev, dev->class->pm, state);
-		if (error)
-			return error;
 	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
-		if (error)
-			return error;
 	}
 
-	return 0;
+	return error;
 }
 
 /**
