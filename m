Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2H1TAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:00:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2H1TAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:00:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6818"; a="228098316"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: Make sure dtc is built before running it
Date: Tue, 28 Aug 2012 11:59:58 -0700
Message-Id: <1346180398-8079-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make dtbs' in a clean tree will try running the dtc before actually
building it.  Make these rules depend upon the scripts to build it.
---
 arch/arm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 0298b00..926d840 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -279,10 +279,10 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-%.dtb:
+%.dtb: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-dtbs:
+dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

