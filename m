Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab1E0EFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:05:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1E0EE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:04:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF22D1.10101@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:04:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 02/12] mce-severity: cleanup severity table, prep
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks very complicated and hard to read for people other than
skilled developers.  So let make it a bit clean.
At first, change format to ease reading elements in the table.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  116 +++++++++++++++++++++-------
 1 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 352d16a..eaf5a43 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -58,44 +58,102 @@ static struct severity {
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define MCACOD 0xffff
 
-	BITCLR(MCI_STATUS_VAL, NO, "Invalid"),
-	BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
-	BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
+	BITCLR(
+		MCI_STATUS_VAL,
+		NO, "Invalid"
+		),
+	BITCLR(
+		MCI_STATUS_EN,
+		NO, "Not enabled"
+		),
+	BITSET(
+		MCI_STATUS_PCC,
+		PANIC, "Processor context corrupt"
+		),
 	/* When MCIP is not set something is very confused */
-	MCGMASK(MCG_STATUS_MCIP, 0, PANIC, "MCIP not set in MCA handler"),
+	MCGMASK(
+		MCG_STATUS_MCIP, 0,
+		PANIC, "MCIP not set in MCA handler"
+		),
 	/* Neither return not error IP -- no chance to recover -> PANIC */
-	MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0, PANIC,
-		"Neither restart nor error IP"),
-	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
-		KERNEL),
-	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", NOSER),
+	MCGMASK(
+		MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0,
+		PANIC, "Neither restart nor error IP"
+		),
+	MCGMASK(
+		MCG_STATUS_RIPV, 0,
+		PANIC, "In kernel and no restart IP",
+		KERNEL
+		),
+	BITCLR(
+		MCI_STATUS_UC,
+		KEEP, "Corrected error",
+		NOSER
+		),
 
 	/* ignore OVER for UCNA */
-	MASK(MCI_UC_SAR, MCI_STATUS_UC, KEEP,
-	     "Uncorrected no action required", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR, PANIC,
-	     "Illegal combination (UCNA with AR=1)", SER),
-	MASK(MCI_STATUS_S, 0, KEEP, "Non signalled machine check", SER),
+	MASK(
+		MCI_UC_SAR, MCI_STATUS_UC,
+		KEEP, "Uncorrected no action required",
+		SER
+		),
+	MASK(
+		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR,
+		PANIC, "Illegal combination (UCNA with AR=1)",
+		SER
+		),
+	MASK(
+		MCI_STATUS_S, 0,
+		KEEP, "Non signalled machine check",
+		SER
+		),
 
 	/* AR add known MCACODs here */
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
-	     "Action required with lost events", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR, PANIC,
-	     "Action required; unknown MCACOD", SER),
+	MASK(
+		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR,
+		PANIC, "Action required with lost events",
+		SER
+		),
+	MASK(
+		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR,
+		PANIC, "Action required; unknown MCACOD",
+		SER
+		),
 
 	/* known AO MCACODs: */
-	MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0, AO,
-	     "Action optional: memory scrubbing error", SER),
-	MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a, AO,
-	     "Action optional: last level cache writeback error", SER),
-
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S, SOME,
-	     "Action optional unknown MCACOD", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER, SOME,
-	     "Action optional with lost events", SER),
-	BITSET(MCI_STATUS_UC|MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
-	BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
-	BITSET(0, SOME, "No match")	/* always matches. keep at end */
+	MASK(
+		MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0,
+		AO, "Action optional: memory scrubbing error",
+		SER
+		),
+	MASK(
+		MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a,
+		AO, "Action optional: last level cache writeback error",
+		SER
+		),
+
+	MASK(
+		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S,
+		SOME, "Action optional unknown MCACOD",
+		SER
+		),
+	MASK(
+		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER,
+		SOME, "Action optional with lost events",
+		SER
+		),
+	BITSET(
+		MCI_STATUS_UC|MCI_STATUS_OVER,
+		PANIC, "Overflowed uncorrected"
+		),
+	BITSET(
+		MCI_STATUS_UC,
+		UC, "Uncorrected"
+		),
+	BITSET(
+		0,
+		SOME, "No match"
+		)	/* always matches. keep at end */
 };
 
 /*
-- 
1.7.1


