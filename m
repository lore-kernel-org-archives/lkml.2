Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2EACRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 22:17:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8342 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab2EACRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 22:17:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="186398803"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] ARM: msm: fix compilation flags for MSM_SCM (part 2)
Date: Mon, 30 Apr 2012 19:17:20 -0700
Message-Id: <1335838640-11176-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.334.gf9d99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eca55f4 (ARM: msm: fix compilation flags for MSM_SCM, 2011-11-08)
added the correct assembler directive for the first smc instance
but missed the second instance in scm_get_version(). Add it so we
can compile this file with newer binutils.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/scm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
index bafabb5..c536fd6 100644
--- a/arch/arm/mach-msm/scm.c
+++ b/arch/arm/mach-msm/scm.c
@@ -282,6 +282,9 @@ u32 scm_get_version(void)
 			__asmeq("%1", "r1")
 			__asmeq("%2", "r0")
 			__asmeq("%3", "r1")
+#ifdef REQUIRES_SEC
+			".arch_extension sec\n"
+#endif
 			"smc	#0	@ switch to secure world\n"
 			: "=r" (r0), "=r" (r1)
 			: "r" (r0), "r" (r1)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

