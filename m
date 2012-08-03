Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2HCWmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:42:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42841 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2HCWmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:42:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6792"; a="216701346"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: Don't enable GENERIC_LOCKBREAK with ticket spinlocks
Date: Fri,  3 Aug 2012 15:42:42 -0700
Message-Id: <1344033762-3296-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.rc1.16.g05a20c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ARM has implemented its spinlocks with tickets we don't
need to use the generic lockbreak algorithm. Remove the Kconfig
from ARM so that we use the arch_spin_is_contended() definition
from the asm header. This also saves a word in each lock because
we don't need the break_lock member anymore.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

It seems we define the arch_spin_is_contended() macro but we don't
use it on SMP && PREEMPT kernels?

 arch/arm/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e91c7cd..e4191cc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -126,11 +126,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config GENERIC_LOCKBREAK
-	bool
-	default y
-	depends on SMP && PREEMPT
-
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

