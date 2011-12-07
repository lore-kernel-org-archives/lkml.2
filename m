Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab1LGVgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:36:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36645 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab1LGVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:36:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6553"; a="144657800"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH] fault_inject: Don't select frame pointer with ARM unwind
Date: Wed,  7 Dec 2011 13:36:06 -0800
Message-Id: <1323293766-31394-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FAULT_INJECTION_STACKTRACE_FILTER selects FRAME_POINTER.
If ARM_UNWIND is used for backtracing, the FRAME_POINTER
should not be selected.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6a9e368..75b5d6b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1079,7 +1079,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !PPC && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-- 
1.7.6

