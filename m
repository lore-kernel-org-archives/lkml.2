Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1FPLQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:16:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1FPLQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:16:41 -0400
Date: Thu, 16 Jun 2011 11:16:29 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-901d7691d3238ad68c80a567b88b1e5d614137fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED5EB.6050400@jp.fujitsu.com>
References: <4DEED5EB.6050400@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce, severity: Make formatting a bit more readable
Git-Commit-ID: 901d7691d3238ad68c80a567b88b1e5d614137fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:16:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  901d7691d3238ad68c80a567b88b1e5d614137fb
Gitweb:     http://git.kernel.org/tip/901d7691d3238ad68c80a567b88b1e5d614137fb
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:52:43 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 11:40:21 +0200

x86, mce, severity: Make formatting a bit more readable

The table looks very complicated and hard to read for people other than
skilled developers. So let's clean it up a bit. At first, change format
to ease reading elements in the table.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED5EB.6050400@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
