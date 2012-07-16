Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2GPV2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:28:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab2GPV16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:27:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 3/14] ARM: shmobile: Drop r8a7779_add_device_to_domain()
Date: Mon, 16 Jul 2012 23:19:14 +0200
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
Message-Id: <201207162319.14687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the r8a7779's PM domains are given names, this SoC and its boards
will be able to use rmobile_add_device_to_domain() for adding devices
to those domains and r8a7779_add_device_to_domain(), which is not
used anywhere at the moment anyway, may be dopped.

Accordingly, give names to the r8a7779's PM domains and drop
r8a7779_add_device_to_domain().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/r8a7779.h |    3 ---
 arch/arm/mach-shmobile/pm-r8a7779.c           |   14 ++++----------
 2 files changed, 4 insertions(+), 13 deletions(-)

Index: linux/arch/arm/mach-shmobile/include/mach/r8a7779.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/r8a7779.h
+++ linux/arch/arm/mach-shmobile/include/mach/r8a7779.h
@@ -353,11 +353,8 @@ extern struct r8a7779_pm_domain r8a7779_
 extern struct r8a7779_pm_domain r8a7779_impx3;
 
 extern void r8a7779_init_pm_domain(struct r8a7779_pm_domain *r8a7779_pd);
-extern void r8a7779_add_device_to_domain(struct r8a7779_pm_domain *r8a7779_pd,
-					struct platform_device *pdev);
 #else
 #define r8a7779_init_pm_domain(pd) do { } while (0)
-#define r8a7779_add_device_to_domain(pd, pdev) do { } while (0)
 #endif /* CONFIG_PM */
 
 #endif /* __ASM_R8A7779_H__ */
Index: linux/arch/arm/mach-shmobile/pm-r8a7779.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-r8a7779.c
+++ linux/arch/arm/mach-shmobile/pm-r8a7779.c
@@ -199,17 +199,8 @@ void r8a7779_init_pm_domain(struct r8a77
 		pd_power_up(&r8a7779_pd->genpd);
 }
 
-void r8a7779_add_device_to_domain(struct r8a7779_pm_domain *r8a7779_pd,
-				 struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-
-	pm_genpd_add_device(&r8a7779_pd->genpd, dev);
-	if (pm_clk_no_clocks(dev))
-		pm_clk_add(dev, NULL);
-}
-
 struct r8a7779_pm_domain r8a7779_sh4a = {
+	.genpd_name = "SH4A",
 	.ch = {
 		.chan_offs = 0x80, /* PWRSR1 .. PWRER1 */
 		.isr_bit = 16, /* SH4A */
@@ -217,6 +208,7 @@ struct r8a7779_pm_domain r8a7779_sh4a =
 };
 
 struct r8a7779_pm_domain r8a7779_sgx = {
+	.genpd_name = "SGX",
 	.ch = {
 		.chan_offs = 0xc0, /* PWRSR2 .. PWRER2 */
 		.isr_bit = 20, /* SGX */
@@ -224,6 +216,7 @@ struct r8a7779_pm_domain r8a7779_sgx = {
 };
 
 struct r8a7779_pm_domain r8a7779_vdp1 = {
+	.genpd_name = "VDP1",
 	.ch = {
 		.chan_offs = 0x100, /* PWRSR3 .. PWRER3 */
 		.isr_bit = 21, /* VDP */
@@ -231,6 +224,7 @@ struct r8a7779_pm_domain r8a7779_vdp1 =
 };
 
 struct r8a7779_pm_domain r8a7779_impx3 = {
+	.genpd_name = "IMPX3",
 	.ch = {
 		.chan_offs = 0x140, /* PWRSR4 .. PWRER4 */
 		.isr_bit = 24, /* IMP */

