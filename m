Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0JUJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:27:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0JUJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:27:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6142"; a="58763418"
X-IronPort-AV: E=Sophos;i="4.58,215,1286175600"; 
   d="scan'208";a="13372428"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] msm: timer: Decrease shift on timer clocksource
Date: Thu, 21 Oct 2010 02:25:45 -0700
Message-Id: <1287653148-1103-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shift of 24 causes the shift and multiply operation to sometimes
overflow, resulting in incorrect timer values and poor performance.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 7689848..950100f 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -137,7 +137,7 @@ static struct msm_clock msm_clocks[] = {
 			.rating         = 200,
 			.read           = msm_gpt_read,
 			.mask           = CLOCKSOURCE_MASK(32),
-			.shift          = 24,
+			.shift          = 17,
 			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 		},
 		.irq = {
-- 
1.7.3.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
