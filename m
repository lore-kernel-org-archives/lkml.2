Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1FPLQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:16:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1FPLQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:16:20 -0400
Date: Thu, 16 Jun 2011 11:16:04 GMT
From: tip-bot for Tony Luck <tony.luck@intel.com>
Message-ID: <tip-880a317abccf60b989951bf1515964cd73245970@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED5BC.8030703@jp.fujitsu.com>
References: <4DEED5BC.8030703@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce, severity: Fix two severities table signatures
Git-Commit-ID: 880a317abccf60b989951bf1515964cd73245970
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  880a317abccf60b989951bf1515964cd73245970
Gitweb:     http://git.kernel.org/tip/880a317abccf60b989951bf1515964cd73245970
Author:     Tony Luck <tony.luck@intel.com>
AuthorDate: Tue, 7 Jun 2011 21:51:56 -0400
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 11:37:57 +0200

x86, mce, severity: Fix two severities table signatures

The "Spurious not enabled" entry is redundant: the "Not enabled" entry
earlier in the table will cover this case.

The "Action required; unknown MCACOD" entry shouldn't specify MCACOD in
the .mask field. Current code will only match for mcacod==0 rather than
all AR=1 entries.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/4DEED5BC.8030703@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
