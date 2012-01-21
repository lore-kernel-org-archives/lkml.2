Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2AVACS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:18 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37097 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2AVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:14 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:33 2012
Subject: [PATCH 3/8] ARM: OMAP2+: hwmod data: add HDQ/1-wire hwmod shared data
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Date: Sat, 21 Jan 2012 16:59:33 -0700
Message-ID: <20120121235932.17619.51239.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much of the HDQ1W integration data is common between multiple generations
of OMAP SoCs, so rather than make several copies, we add it once into
files which are compiled for multiple SoCs.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
---
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |    9 ++++++++
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   22 ++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    4 ++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c
index 04637fa..cbb4ef6 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c
@@ -171,3 +171,12 @@ struct omap_hwmod_addr_space omap2_mcbsp1_addrs[] = {
 	},
 	{ }
 };
+
+struct omap_hwmod_addr_space omap2_hdq1w_addr_space[] = {
+	{
+		.pa_start       = 0x480b2000,
+		.pa_end         = 0x480b2fff,
+		.flags          = ADDR_TYPE_RT,
+	},
+	{ }
+};
diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c
index c11273d..e4cdd74 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c
@@ -2,6 +2,7 @@
  * omap_hwmod_2xxx_3xxx_ipblock_data.c - common IP block data for OMAP2/3
  *
  * Copyright (C) 2011 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments, Inc.
  * Paul Walmsley
  *
  * This program is free software; you can redistribute it and/or modify
@@ -12,6 +13,7 @@
 #include <plat/serial.h>
 #include <plat/dma.h>
 #include <plat/common.h>
+#include <plat/hdq1w.h>
 
 #include <mach/irqs.h>
 
@@ -323,3 +325,23 @@ struct omap_hwmod_irq_info omap2_mcspi2_mpu_irqs[] = {
 	{ .irq = -1 }
 };
 
+struct omap_hwmod_class_sysconfig omap2_hdq1w_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x14,
+	.syss_offs	= 0x18,
+	.sysc_flags	= (SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			   SYSS_HAS_RESET_STATUS),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+struct omap_hwmod_class omap2_hdq1w_class = {
+	.name	= "hdq1w",
+	.sysc	= &omap2_hdq1w_sysc,
+	.reset	= &omap_hdq1w_reset,
+};
+
+struct omap_hwmod_irq_info omap2_hdq1w_mpu_irqs[] = {
+	{ .irq = 58, },
+	{ .irq = -1 }
+};
+
diff --git a/arch/arm/mach-omap2/omap_hwmod_common_data.h b/arch/arm/mach-omap2/omap_hwmod_common_data.h
index ad5d8f0..a5fc96a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_common_data.h
+++ b/arch/arm/mach-omap2/omap_hwmod_common_data.h
@@ -50,6 +50,7 @@ extern struct omap_hwmod_addr_space omap2430_mcspi3_addr_space[];
 extern struct omap_hwmod_addr_space omap2_dma_system_addrs[];
 extern struct omap_hwmod_addr_space omap2_mailbox_addrs[];
 extern struct omap_hwmod_addr_space omap2_mcbsp1_addrs[];
+extern struct omap_hwmod_addr_space omap2_hdq1w_addr_space[];
 
 /* Common IP block data across OMAP2xxx */
 extern struct omap_hwmod_irq_info omap2xxx_timer12_mpu_irqs[];
@@ -94,6 +95,7 @@ extern struct omap_hwmod_irq_info omap2_gpio4_irqs[];
 extern struct omap_hwmod_irq_info omap2_dma_system_irqs[];
 extern struct omap_hwmod_irq_info omap2_mcspi1_mpu_irqs[];
 extern struct omap_hwmod_irq_info omap2_mcspi2_mpu_irqs[];
+extern struct omap_hwmod_irq_info omap2_hdq1w_mpu_irqs[];
 
 /* OMAP hwmod classes - forward declarations */
 extern struct omap_hwmod_class l3_hwmod_class;
@@ -105,6 +107,8 @@ extern struct omap_hwmod_class omap2_dss_hwmod_class;
 extern struct omap_hwmod_class omap2_dispc_hwmod_class;
 extern struct omap_hwmod_class omap2_rfbi_hwmod_class;
 extern struct omap_hwmod_class omap2_venc_hwmod_class;
+extern struct omap_hwmod_class_sysconfig omap2_hdq1w_sysc;
+extern struct omap_hwmod_class omap2_hdq1w_class;
 
 extern struct omap_hwmod_class omap2xxx_timer_hwmod_class;
 extern struct omap_hwmod_class omap2xxx_wd_timer_hwmod_class;


