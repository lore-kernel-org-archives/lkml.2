Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920Ab2DLSp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:45:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965890Ab2DLSpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="178847790"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: msm: Fix section mismatches in proc_comm.c
Date: Thu, 12 Apr 2012 11:45:34 -0700
Message-Id: <1334256334-8234-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
References: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change
    commit 4416e9eb0b4859b3d28016c5fd0a609bdcbc8a2a
    Author: Gregory Bean <gbean@codeaurora.org>
    Date:   Wed Jul 28 10:22:12 2010 -0700

        arm: msm: Fix section mismatch in smd.c.

fixes a section mismatch between the board file and the smd driver's
probe function, however, it misses the additional mismatches between
the probe function and some routines it calls.  Fix these up as well.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/proc_comm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/proc_comm.c b/arch/arm/mach-msm/proc_comm.c
index 67e701c..9980dc7 100644
--- a/arch/arm/mach-msm/proc_comm.c
+++ b/arch/arm/mach-msm/proc_comm.c
@@ -121,7 +121,7 @@ int msm_proc_comm(unsigned cmd, unsigned *data1, unsigned *data2)
  * and unknown state. This function should be called early to
  * wait on the ARM9.
  */
-void __init proc_comm_boot_wait(void)
+void __devinit proc_comm_boot_wait(void)
 {
 	void __iomem *base = MSM_SHARED_RAM_BASE;
  
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

