Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1EWWCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:02:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:35908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab1EWWCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="6410464"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 1/9] mce: fixes for mce severity table
Date: Mon, 23 May 2011 15:02:07 -0700
Message-Id: <4ddad95f17144b3e77@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

The "Spurious not enabled" entry is redundant. The "Not enabled"
entry earlier in the table will cover this case.

The "Action required; unknown MCACOD" entry  shouldn't specify
MCACOD in the .mask field. Current code will only match for
mcacod==0 rather than all AR=1 entries.

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

