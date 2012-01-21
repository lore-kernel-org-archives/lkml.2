Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab2AVADq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:03:46 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37090 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2AVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:14 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:31 2012
Subject: [PATCH 1/8] ARM: OMAP3: clock data: add clockdomain for HDQ
 functional clock
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Date: Sat, 21 Jan 2012 16:59:31 -0700
Message-ID: <20120121235928.17619.38147.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the correct clockdomain for the HDQ functional clock.  This is needed
for the clock and hwmod PM code to work correctly.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
---
 arch/arm/mach-omap2/clock3xxx_data.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index d75e5f6..98cb408 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -1,7 +1,7 @@
 /*
  * OMAP3 clock data
  *
- * Copyright (C) 2007-2010 Texas Instruments, Inc.
+ * Copyright (C) 2007-2010, 2012 Texas Instruments, Inc.
  * Copyright (C) 2007-2011 Nokia Corporation
  *
  * Written by Paul Walmsley
@@ -1634,6 +1634,7 @@ static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.ops		= &clkops_omap2_dflt_wait,
 	.parent		= &core_12m_fck,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,


