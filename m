Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1D3J4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 05:56:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1D3Jz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 05:55:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] ARM / shmobile: Support for power domain A4MP on SH7372
Date: Sat, 30 Apr 2011 11:56:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201104290154.12966.rjw@sisk.pl> <201104290155.41434.rjw@sisk.pl> <201104300259.08477.rjw@sisk.pl>
In-Reply-To: <201104300259.08477.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104301156.26565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the power domains support code added by the previous
patches to implement support for power domain A4MP on SH7372.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This patch is on top of https://lkml.org/lkml/2011/4/29/490 .

Thanks,
Rafael

---
 arch/arm/mach-shmobile/board-mackerel.c      |    2 ++
 arch/arm/mach-shmobile/include/mach/sh7372.h |    3 +++
 arch/arm/mach-shmobile/pm-sh7372.c           |    7 +++++++
 3 files changed, 12 insertions(+)

Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -90,9 +90,16 @@ static struct sh7372_domain_data sh7372_
 
 struct generic_power_domain sh7372_a4lc_domain;
 
+static struct sh7372_domain_data sh7372_a4mp_domain_data = {
+	.bit_shift = 2,
+};
+
+struct generic_power_domain sh7372_a4mp_domain;
+
 static int __init sh7372_power_domains_init(void)
 {
 	sh7372_init_domain(&sh7372_a4lc_domain, &sh7372_a4lc_domain_data);
+	sh7372_init_domain(&sh7372_a4mp_domain, &sh7372_a4mp_domain_data);
 	return 0;
 }
 core_initcall(sh7372_power_domains_init);
Index: linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -475,11 +475,14 @@ struct platform_device;
 #ifdef CONFIG_PM
 extern struct generic_power_domain sh7372_a4lc_domain;
 #define SH7372_A4LC	(&sh7372_a4lc_domain)
+extern struct generic_power_domain sh7372_a4mp_domain;
+#define SH7372_A4MP	(&sh7372_a4mp_domain)
 
 extern void sh7372_add_device_to_domain(struct generic_power_domain *domain,
 					struct platform_device *pdev);
 #else
 #define SH7372_A4LC	NULL
+#define SH7372_A4PM	NULL
 
 static inline void sh7372_add_device_to_domain(struct generic_power_domain *dom,
 					       struct platform_device *pd) {}
Index: linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
@@ -1218,6 +1218,8 @@ static void __init mackerel_init(void)
 	sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
 	sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
 
+	sh7372_add_device_to_domain(SH7372_A4MP, &fsi_device);
+
 	hdmi_init_pm_clock();
 }
 

