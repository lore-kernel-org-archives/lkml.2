Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab1E0EDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:03:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43209 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1E0EDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:03:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF2275.309@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:03:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/12] mce-severity: fixes for mce severity table
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
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
1.7.1


