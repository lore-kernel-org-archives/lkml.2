Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1COFBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36260 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1COFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772015"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>, San Mehat <san@google.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 05/11] msm: dma: Remove register macros from header file
Date: Mon, 14 Mar 2011 22:01:08 -0700
Message-Id: <1300165274-8544-6-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for anything other than the dma driver to access the
dma registers directly. So, don't provide the register addresses in the
header file.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/dma.c              |   23 +++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/dma.h |   24 ------------------------
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 2dc408d..3ff31f9 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -38,6 +38,29 @@ static struct list_head ready_commands[MSM_DMOV_CHANNEL_COUNT];
 static struct list_head active_commands[MSM_DMOV_CHANNEL_COUNT];
 unsigned int msm_dmov_print_mask = MSM_DMOV_PRINT_ERRORS;
 
+#define DMOV_SD0(off, ch) (MSM_DMOV_BASE + 0x0000 + (off) + ((ch) << 2))
+#define DMOV_SD1(off, ch) (MSM_DMOV_BASE + 0x0400 + (off) + ((ch) << 2))
+#define DMOV_SD2(off, ch) (MSM_DMOV_BASE + 0x0800 + (off) + ((ch) << 2))
+#define DMOV_SD3(off, ch) (MSM_DMOV_BASE + 0x0C00 + (off) + ((ch) << 2))
+
+#if defined(CONFIG_ARCH_MSM7X30)
+#define DMOV_SD_AARM DMOV_SD2
+#else
+#define DMOV_SD_AARM DMOV_SD3
+#endif
+
+#define DMOV_CMD_PTR(ch)      DMOV_SD_AARM(0x000, ch)
+#define DMOV_RSLT(ch)         DMOV_SD_AARM(0x040, ch)
+#define DMOV_FLUSH0(ch)       DMOV_SD_AARM(0x080, ch)
+#define DMOV_FLUSH1(ch)       DMOV_SD_AARM(0x0C0, ch)
+#define DMOV_FLUSH2(ch)       DMOV_SD_AARM(0x100, ch)
+#define DMOV_FLUSH3(ch)       DMOV_SD_AARM(0x140, ch)
+#define DMOV_FLUSH4(ch)       DMOV_SD_AARM(0x180, ch)
+#define DMOV_FLUSH5(ch)       DMOV_SD_AARM(0x1C0, ch)
+#define DMOV_STATUS(ch)       DMOV_SD_AARM(0x200, ch)
+#define DMOV_CONFIG(ch)       DMOV_SD_AARM(0x300, ch)
+#define DMOV_ISR              DMOV_SD_AARM(0x380, 0)
+
 #define MSM_DMOV_DPRINTF(mask, format, args...) \
 	do { \
 		if ((mask) & msm_dmov_print_mask) \
diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
index 41eb4a5..ae031d2 100644
--- a/arch/arm/mach-msm/include/mach/dma.h
+++ b/arch/arm/mach-msm/include/mach/dma.h
@@ -50,49 +50,25 @@ static inline
 void msm_dmov_flush(unsigned int id) { }
 #endif
 
-
-#define DMOV_SD0(off, ch) (MSM_DMOV_BASE + 0x0000 + (off) + ((ch) << 2))
-#define DMOV_SD1(off, ch) (MSM_DMOV_BASE + 0x0400 + (off) + ((ch) << 2))
-#define DMOV_SD2(off, ch) (MSM_DMOV_BASE + 0x0800 + (off) + ((ch) << 2))
-#define DMOV_SD3(off, ch) (MSM_DMOV_BASE + 0x0C00 + (off) + ((ch) << 2))
-
-#if defined(CONFIG_ARCH_MSM7X30)
-#define DMOV_SD_AARM DMOV_SD2
-#else
-#define DMOV_SD_AARM DMOV_SD3
-#endif
-
-#define DMOV_CMD_PTR(ch)      DMOV_SD_AARM(0x000, ch)
 #define DMOV_CMD_LIST         (0 << 29) /* does not work */
 #define DMOV_CMD_PTR_LIST     (1 << 29) /* works */
 #define DMOV_CMD_INPUT_CFG    (2 << 29) /* untested */
 #define DMOV_CMD_OUTPUT_CFG   (3 << 29) /* untested */
 #define DMOV_CMD_ADDR(addr)   ((addr) >> 3)
 
-#define DMOV_RSLT(ch)         DMOV_SD_AARM(0x040, ch)
 #define DMOV_RSLT_VALID       (1 << 31) /* 0 == host has empties result fifo */
 #define DMOV_RSLT_ERROR       (1 << 3)
 #define DMOV_RSLT_FLUSH       (1 << 2)
 #define DMOV_RSLT_DONE        (1 << 1)  /* top pointer done */
 #define DMOV_RSLT_USER        (1 << 0)  /* command with FR force result */
 
-#define DMOV_FLUSH0(ch)       DMOV_SD_AARM(0x080, ch)
-#define DMOV_FLUSH1(ch)       DMOV_SD_AARM(0x0C0, ch)
-#define DMOV_FLUSH2(ch)       DMOV_SD_AARM(0x100, ch)
-#define DMOV_FLUSH3(ch)       DMOV_SD_AARM(0x140, ch)
-#define DMOV_FLUSH4(ch)       DMOV_SD_AARM(0x180, ch)
-#define DMOV_FLUSH5(ch)       DMOV_SD_AARM(0x1C0, ch)
 #define DMOV_FLUSH_GRACEFUL  (1 << 31)
 
-#define DMOV_STATUS(ch)       DMOV_SD_AARM(0x200, ch)
 #define DMOV_STATUS_RSLT_COUNT(n)    (((n) >> 29))
 #define DMOV_STATUS_CMD_COUNT(n)     (((n) >> 27) & 3)
 #define DMOV_STATUS_RSLT_VALID       (1 << 1)
 #define DMOV_STATUS_CMD_PTR_RDY      (1 << 0)
 
-#define DMOV_ISR              DMOV_SD_AARM(0x380, 0)
-  
-#define DMOV_CONFIG(ch)       DMOV_SD_AARM(0x300, ch)
 #define DMOV_CONFIG_FORCE_TOP_PTR_RSLT (1 << 2)
 #define DMOV_CONFIG_FORCE_FLUSH_RSLT   (1 << 1)
 #define DMOV_CONFIG_IRQ_EN             (1 << 0)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

