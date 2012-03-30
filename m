Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab2C3KTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:19:17 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab2C3KSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:41 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 22/76] ARM: davinci: Fix for cpuidle consolidation changes
Date: Fri, 30 Mar 2012 06:13:25 -0400
Message-id: <6a6ea0acc9375571a13aa8c4e105a0807e1c16a4.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Lee <rob.lee@linaro.org>

The recent cpuidle consolidation changes erroneously omitted one
critical line of code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 93ae096..9107691 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -55,10 +55,11 @@ static int davinci_enter_idle(struct cpuidle_device *dev,
 #define DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN	BIT(0)
 
 static struct cpuidle_driver davinci_idle_driver = {
-	.name		= "cpuidle-davinci",
-	.owner		= THIS_MODULE,
-	.states[0]	= ARM_CPUIDLE_WFI_STATE,
-	.states[1]	= {
+	.name			= "cpuidle-davinci",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
 		.enter			= davinci_enter_idle,
 		.exit_latency		= 10,
 		.target_residency	= 100000,
-- 
1.7.10.rc2.19.gfae9d

