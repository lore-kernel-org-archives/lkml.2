Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2LOAVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:21:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34268 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab2LOAVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:21:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / QoS: Rename local variable in dev_pm_qos_add_ancestor_request()
Date: Sat, 15 Dec 2012 01:26:57 +0100
Message-ID: <7726945.tcqyFAMvPL@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
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
 

