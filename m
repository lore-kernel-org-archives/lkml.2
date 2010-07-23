Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab0GWS6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:58:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39068 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0GWS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:58:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48450457"
X-IronPort-AV: E=Sophos;i="4.55,247,1278313200"; 
   d="scan'208";a="69829417"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3/3] arm: macros for wfe, sev instructions
Date: Fri, 23 Jul 2010 11:58:03 -0700
Message-Id: <1279911483-7039-4-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

The wait for event and send event instructions may be called from C code
such as boot or power management routines.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/include/asm/processor.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 7bed3da..4262664 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -97,6 +97,11 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()			barrier()
 #endif
 
+#if defined(CONFIG_CPU_32v6K) || __LINUX_ARM_ARCH__ >= 7
+#define sev() __asm__("sev")
+#define wfe() __asm__("wfe")
+#endif
+
 /*
  * Create a new kernel thread
  */
-- 
1.7.1.1

