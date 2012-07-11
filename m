Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2GKUoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:44:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192Ab2GKUoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:44:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/2] PM / Domains: Fix build warning for CONFIG_PM_RUNTIME unset
Date: Wed, 11 Jul 2012 22:48:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201207112247.21693.rjw@sisk.pl>
In-Reply-To: <201207112247.21693.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207112248.31128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The functions genpd_save_dev() and genpd_restore_dev() are not used
for CONFIG_PM_RUNTIME unset, so move them under an appropriate
#ifdef.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -75,19 +75,6 @@ static int genpd_start_dev(struct generi
 					start_latency_ns, "start");
 }
 
-static int genpd_save_dev(struct generic_pm_domain *genpd, struct device *dev)
-{
-	return GENPD_DEV_TIMED_CALLBACK(genpd, int, save_state, dev,
-					save_state_latency_ns, "state save");
-}
-
-static int genpd_restore_dev(struct generic_pm_domain *genpd, struct device *dev)
-{
-	return GENPD_DEV_TIMED_CALLBACK(genpd, int, restore_state, dev,
-					restore_state_latency_ns,
-					"state restore");
-}
-
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 {
 	bool ret = false;
@@ -275,6 +262,19 @@ int pm_genpd_poweron(struct generic_pm_d
 
 #ifdef CONFIG_PM_RUNTIME
 
+static int genpd_save_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, save_state, dev,
+					save_state_latency_ns, "state save");
+}
+
+static int genpd_restore_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, restore_state, dev,
+					restore_state_latency_ns,
+					"state restore");
+}
+
 static int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
 				     unsigned long val, void *ptr)
 {

