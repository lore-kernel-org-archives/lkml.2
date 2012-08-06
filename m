Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2HFXL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:11:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab2HFXLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:11:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 12/12] ARM: shmobile: Make rmobile_init_pm_domain() static
Date: Tue, 7 Aug 2012 01:15:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201208070105.23262.rjw@sisk.pl>
In-Reply-To: <201208070105.23262.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208070115.02328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since rmobile_init_pm_domain() is not called anywhere outside of
arch/arm/mach-shmobile/pm-rmobile.c any more, it can be made static
and its header may be removed from pm-rmobile.h.  Modify the code
accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/pm-rmobile.h |    2 --
 arch/arm/mach-shmobile/pm-rmobile.c              |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
+++ linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
@@ -30,12 +30,10 @@ struct rmobile_pm_domain *to_rmobile_pd(
 }
 
 #ifdef CONFIG_PM
-extern void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd);
 extern void rmobile_init_domains(struct rmobile_pm_domain domains[], int num);
 extern void rmobile_add_device_to_domain(const char *domain_name,
 					struct platform_device *pdev);
 #else
-#define rmobile_init_pm_domain(pd) do { } while (0)
 #define rmobile_init_domains(domains, num) do { } while (0)
 #define rmobile_add_device_to_domain(name, pdev) do { } while (0)
 #endif /* CONFIG_PM */
Index: linux/arch/arm/mach-shmobile/pm-rmobile.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-rmobile.c
+++ linux/arch/arm/mach-shmobile/pm-rmobile.c
@@ -134,7 +134,7 @@ static int rmobile_pd_start_dev(struct d
 	return ret;
 }
 
-void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
+static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 {
 	struct generic_pm_domain *genpd = &rmobile_pd->genpd;
 	struct dev_power_governor *gov = rmobile_pd->gov;

