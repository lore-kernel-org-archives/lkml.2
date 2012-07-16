Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab2GPVbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:31:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab2GPV2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:28:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 6/14] RM: shmobile: Add routine for automatic PM domains initialization
Date: Mon, 16 Jul 2012 23:23:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207052217.48086.rjw@sisk.pl> <201207162315.49073.rjw@sisk.pl>
In-Reply-To: <201207162315.49073.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207162323.16114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a new routine, rmobile_init_domains(), allowing the caller
to initialize all generic PM objects stored in a table in one
operation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/pm-rmobile.h |    2 ++
 arch/arm/mach-shmobile/pm-rmobile.c              |    8 ++++++++
 2 files changed, 10 insertions(+)

Index: linux/arch/arm/mach-shmobile/pm-rmobile.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-rmobile.c
+++ linux/arch/arm/mach-shmobile/pm-rmobile.c
@@ -149,6 +149,14 @@ void rmobile_init_pm_domain(struct rmobi
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
+void rmobile_init_domains(struct rmobile_pm_domain domains[], int num)
+{
+	int j;
+
+	for (j = 0; j < num; j++)
+		rmobile_init_pm_domain(&domains[j]);
+}
+
 void rmobile_add_device_to_domain(const char *domain_name,
 				 struct platform_device *pdev)
 {
Index: linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
+++ linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
@@ -31,10 +31,12 @@ struct rmobile_pm_domain *to_rmobile_pd(
 
 #ifdef CONFIG_PM
 extern void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd);
+extern void rmobile_init_domains(struct rmobile_pm_domain domains[], int num);
 extern void rmobile_add_device_to_domain(const char *domain_name,
 					struct platform_device *pdev);
 #else
 #define rmobile_init_pm_domain(pd) do { } while (0)
+#define rmobile_init_domains(domains, num) do { } while (0)
 #define rmobile_add_device_to_domain(name, pdev) do { } while (0)
 #endif /* CONFIG_PM */
 

