Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1G1Xoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab1G1Xoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552511"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: grinberg@compulab.co.il, eric.y.miao@gmail.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [27/50] ARM: pxa/cm-x300: fix V3020 RTC functionality
Message-Id: <20110728234431.C3FA02403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Igor Grinberg <grinberg@compulab.co.il>

[ upstream commit 6c7b3ea52e345ab614edb91d3f0e9f3bb3713871 ]

While in sleep mode the CS# and other V3020 RTC GPIOs must be driven
high, otherwise V3020 RTC fails to keep the right time in sleep mode.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Cc: stable@kernel.org
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/arm/mach-pxa/cm-x300.c
===================================================================
--- linux-2.6.35.y.orig/arch/arm/mach-pxa/cm-x300.c
+++ linux-2.6.35.y/arch/arm/mach-pxa/cm-x300.c
@@ -157,10 +157,10 @@ static mfp_cfg_t cm_x3xx_mfp_cfg[] __ini
 	GPIO99_GPIO,			/* Ethernet IRQ */
 
 	/* RTC GPIOs */
-	GPIO95_GPIO,			/* RTC CS */
-	GPIO96_GPIO,			/* RTC WR */
-	GPIO97_GPIO,			/* RTC RD */
-	GPIO98_GPIO,			/* RTC IO */
+	GPIO95_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC CS */
+	GPIO96_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC WR */
+	GPIO97_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC RD */
+	GPIO98_GPIO,				/* RTC IO */
 
 	/* Standard I2C */
 	GPIO21_I2C_SCL,
