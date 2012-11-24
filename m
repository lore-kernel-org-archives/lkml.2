Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218Ab2KXJZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:25:31 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780Ab2KXJZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:25:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] PM / QoS: Rename local variable in dev_pm_qos_add_ancestor_request()
Date: Sat, 24 Nov 2012 10:30 +0100
Message-ID: <1379506.4xjF1qmrAD@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Local variable 'error' in dev_pm_qos_add_ancestor_request() need
not contain error codes only, so rename it to 'ret'.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/qos.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -542,19 +542,19 @@ int dev_pm_qos_add_ancestor_request(stru
 				    struct dev_pm_qos_request *req, s32 value)
 {
 	struct device *ancestor = dev->parent;
-	int error = -ENODEV;
+	int ret = -ENODEV;
 
 	while (ancestor && !ancestor->power.ignore_children)
 		ancestor = ancestor->parent;
 
 	if (ancestor)
-		error = dev_pm_qos_add_request(ancestor, req,
-					       DEV_PM_QOS_LATENCY, value);
+		ret = dev_pm_qos_add_request(ancestor, req,
+					     DEV_PM_QOS_LATENCY, value);
 
-	if (error < 0)
+	if (ret < 0)
 		req->dev = NULL;
 
-	return error;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_ancestor_request);
 

