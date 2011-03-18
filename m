Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1CRVif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:38:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50384 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab1CRVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:38:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80644801"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: uncompress.h: Fix putc unused warning
Date: Fri, 18 Mar 2011 14:38:26 -0700
Message-Id: <1300484306-4480-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.292.ge2a57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/include/mach/uncompress.h:22:
warning: 'putc' defined but not used

When DEBUG_ICEDCC=y putc is redefined to icedcc_putc(). This
leaves the putc implemtation in uncompress.h as unused,
triggering this warning. Fix it by not compiling putc() when
DEBUG_ICEDCC=y.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/uncompress.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
index d94292c..47a5579 100644
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ b/arch/arm/mach-msm/include/mach/uncompress.h
@@ -19,6 +19,7 @@
 #include "linux/io.h"
 #include "mach/msm_iomap.h"
 
+#ifndef CONFIG_DEBUG_ICEDCC
 static void putc(int c)
 {
 #if defined(MSM_DEBUG_UART_PHYS)
@@ -27,6 +28,7 @@ static void putc(int c)
 	writel(c, base + 0x0c);
 #endif
 }
+#endif
 
 static inline void flush(void)
 {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

