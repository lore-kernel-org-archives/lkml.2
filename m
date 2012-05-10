Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375Ab2EJSkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:40:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:47811 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab2EJSkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141530208"
Message-Id: <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
In-Reply-To: <cover.1336674796.git.tony.luck@intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 10 May 2012 11:12:14 -0700
Subject: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction recovery cases are very similar to the data recovery one
we already have. Just trade out for a new MCACOD value.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 0c82091..163c4364ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -126,6 +126,16 @@ static struct severity {
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER
 		),
+	MCESEV(
+		KEEP, "HT thread notices Action required: instruction fetch error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
+		MCGMASK(MCG_STATUS_EIPV, 0)
+		),
+	MCESEV(
+		AR, "Action required: instruction fetch error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
+		USER
+		),
 #endif
 	MCESEV(
 		PANIC, "Action required: unknown MCACOD",
-- 
1.7.9.rc2.1.g69204

