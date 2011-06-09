Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1FIV3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:29:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:59595 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1FIV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:29:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="10297427"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 01/10] MCE: fixes for mce severity table
Date: Thu, 09 Jun 2011 14:29:41 -0700
Message-Id: <4df13b45272441cfb0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

The "Spurious not enabled" entry is redundant. The "Not enabled"
entry earlier in the table will cover this case.

The "Action required; unknown MCACOD" entry  shouldn't specify
MCACOD in the .mask field. Current code will only match for
mcacod==0 rather than all AR=1 entries.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 1e8d66c..352d16a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -69,8 +69,6 @@ static struct severity {
 	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
 		KERNEL),
 	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", NOSER),
-	MASK(MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN, MCI_STATUS_UC, SOME,
-	     "Spurious not enabled", SER),
 
 	/* ignore OVER for UCNA */
 	MASK(MCI_UC_SAR, MCI_STATUS_UC, KEEP,
@@ -82,7 +80,7 @@ static struct severity {
 	/* AR add known MCACODs here */
 	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
 	     "Action required with lost events", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_SAR, PANIC,
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR, PANIC,
 	     "Action required; unknown MCACOD", SER),
 
 	/* known AO MCACODs: */
-- 
1.7.3.1

