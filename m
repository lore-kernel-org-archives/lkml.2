Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1G1Xo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:14824 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab1G1Xoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32809049"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: lost.distance@yahoo.com, eric.y.miao@gmail.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [41/50] ARM: pxa: fix PGSR register address calculation
Message-Id: <20110728234446.0B5B72403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Paul Parsons <lost.distance@yahoo.com>

[ upstream commit beb0c9b056b1c23d2029b46a425362e9ccbeba01 ]

The file mfp-pxa2xx.c defines a macro, PGSR(), which translates a gpio
bank number to a PGSR register address. The function pxa2xx_mfp_suspend()
erroneously passed in a gpio number instead of a gpio bank number.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: stable@kernel.org
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/arm/mach-pxa/mfp-pxa2xx.c
===================================================================
--- linux-2.6.35.y.orig/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ linux-2.6.35.y/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -347,9 +347,9 @@ static int pxa2xx_mfp_suspend(struct sys
 		if ((gpio_desc[i].config & MFP_LPM_KEEP_OUTPUT) &&
 		    (GPDR(i) & GPIO_bit(i))) {
 			if (GPLR(i) & GPIO_bit(i))
-				PGSR(i) |= GPIO_bit(i);
+				PGSR(gpio_to_bank(i)) |= GPIO_bit(i);
 			else
-				PGSR(i) &= ~GPIO_bit(i);
+				PGSR(gpio_to_bank(i)) &= ~GPIO_bit(i);
 		}
 	}
 
