Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2GUVw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:52:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2GUVvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:51:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 1/5] PM / shmobile: Set SH7372 PM domain on/off latencies directly
Date: Sat, 21 Jul 2012 23:53:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
References: <201207212349.18294.rjw@sisk.pl>
In-Reply-To: <201207212349.18294.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207212353.04092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The results of adaptive latency computations in __pm_genpd_poweron()
and pm_genpd_poweroff() show that the power on/power off latencies
of all power domains in SH7372 are a little below 250 us.  Therefore,
if 250 us is used as the common initial value of the latency fields
in struct generic_pm_domain for all domains, the latency values
will never have to change at run time and there won't be any overhead
related to re-computation of the corresponding PM QoS data.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -71,6 +71,8 @@
 
 #ifdef CONFIG_PM
 
+#define PM_DOMAIN_ON_OFF_LATENCY_NS	250000
+
 static int sh7372_a4r_pd_suspend(void)
 {
 	sh7372_intcs_suspend();
@@ -99,32 +101,46 @@ static int sh7372_a3sp_pd_suspend(void)
 static struct rmobile_pm_domain sh7372_pm_domains[] = {
 	{
 		.genpd.name = "A4LC",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 1,
 	},
 	{
 		.genpd.name = "A4MP",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 2,
 	},
 	{
 		.genpd.name = "D4",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 3,
 	},
 	{
 		.genpd.name = "A4R",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 5,
 		.suspend = sh7372_a4r_pd_suspend,
 		.resume = sh7372_intcs_resume,
 	},
 	{
 		.genpd.name = "A3RV",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 6,
 	},
 	{
 		.genpd.name = "A3RI",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 8,
 	},
 	{
 		.genpd.name = "A4S",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 10,
 		.gov = &pm_domain_always_on_gov,
 		.no_debug = true,
@@ -132,6 +148,8 @@ static struct rmobile_pm_domain sh7372_p
 	},
 	{
 		.genpd.name = "A3SP",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 11,
 		.gov = &pm_domain_always_on_gov,
 		.no_debug = true,
@@ -139,6 +157,8 @@ static struct rmobile_pm_domain sh7372_p
 	},
 	{
 		.genpd.name = "A3SG",
+		.genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
+		.genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
 		.bit_shift = 13,
 	},
 };

