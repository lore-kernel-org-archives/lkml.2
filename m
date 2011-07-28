Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1G1Xoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:7365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab1G1XoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559404"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: jon.povey@racelogic.co.uk, manjunath.hadli@ti.com, nsekhar@ti.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [13/50] davinci: DM365 EVM: fix video input mux bits
Message-Id: <20110728234417.870932403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jon Povey <jon.povey@racelogic.co.uk>

[ upstream commit 9daedd833a38edd90cf7baa1b1fcf61c3a0721e3 ]

Video input mux settings for tvp7002 and imager inputs were swapped.
Comment was correct.

Tested on EVM with tvp7002 input.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Acked-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: stable@kernel.org
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/arm/mach-davinci/board-dm365-evm.c
===================================================================
--- linux-2.6.35.y.orig/arch/arm/mach-davinci/board-dm365-evm.c
+++ linux-2.6.35.y/arch/arm/mach-davinci/board-dm365-evm.c
@@ -520,7 +520,7 @@ fail:
 	 */
 	if (have_imager()) {
 		label = "HD imager";
-		mux |= 1;
+		mux |= 2;
 
 		/* externally mux MMC1/ENET/AIC33 to imager */
 		mux |= BIT(6) | BIT(5) | BIT(3);
@@ -541,7 +541,7 @@ fail:
 		resets &= ~BIT(1);
 
 		if (have_tvp7002()) {
-			mux |= 2;
+			mux |= 1;
 			resets &= ~BIT(2);
 			label = "tvp7002 HD";
 		} else {
