Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1BXSo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:44:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1BXSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:44:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76263926"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] msm: scm: Fix improper register assignment
Date: Thu, 24 Feb 2011 10:44:43 -0800
Message-Id: <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
In-Reply-To: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign the registers used in the inline assembly immediately
before the inline assembly block. This ensures the compiler
doesn't optimize away dead register assignments when it
shouldn't.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/scm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
index ba57b5a..5eddf54 100644
--- a/arch/arm/mach-msm/scm.c
+++ b/arch/arm/mach-msm/scm.c
@@ -264,13 +264,16 @@ u32 scm_get_version(void)
 {
 	int context_id;
 	static u32 version = -1;
-	register u32 r0 asm("r0") = 0x1 << 8;
-	register u32 r1 asm("r1") = (u32)&context_id;
+	register u32 r0 asm("r0");
+	register u32 r1 asm("r1");
 
 	if (version != -1)
 		return version;
 
 	mutex_lock(&scm_lock);
+
+	r0 = 0x1 << 8;
+	r1 = (u32)&context_id;
 	asm volatile(
 		__asmeq("%0", "r1")
 		__asmeq("%1", "r0")
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

