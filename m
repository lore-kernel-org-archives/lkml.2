Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1FPLRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:17:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:45153 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1FPLR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:17:29 -0400
Date: Thu, 16 Jun 2011 11:17:20 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-7639bfc753f70321dbea83852e1cc47a45b681d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED679.9090503@jp.fujitsu.com>
References: <4DEED679.9090503@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce, severity: Clean up trivial coding style problems
Git-Commit-ID: 7639bfc753f70321dbea83852e1cc47a45b681d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:17:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7639bfc753f70321dbea83852e1cc47a45b681d7
Gitweb:     http://git.kernel.org/tip/7639bfc753f70321dbea83852e1cc47a45b681d7
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:55:05 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:07 +0200

x86, mce, severity: Clean up trivial coding style problems

More specifically:

- sort bits in the macros
- use BITCLR/BITSET
- coordinate message pattern
- use m for struct mce
- cleanup for severities_debugfs_init()

No functional change.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED679.9090503@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   39 ++++++++++++++---------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 27e778e..7395d5f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -99,41 +99,40 @@ static struct severity {
 		),
 	MCESEV(
 		KEEP, "Non signalled machine check",
-		SER, MASK(MCI_STATUS_S, 0)
+		SER, BITCLR(MCI_STATUS_S)
 		),
 
 	/* AR add known MCACODs here */
 	MCESEV(
 		PANIC, "Action required with lost events",
-		SER,
-		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR)
+		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
 		),
 	MCESEV(
-		PANIC, "Action required; unknown MCACOD",
+		PANIC, "Action required: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
 		),
 
 	/* known AO MCACODs: */
 	MCESEV(
 		AO, "Action optional: memory scrubbing error",
-		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
 		),
 	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
 		),
 	MCESEV(
-		SOME, "Action optional unknown MCACOD",
+		SOME, "Action optional: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S)
 		),
 	MCESEV(
 		SOME, "Action optional with lost events",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_S)
 		),
 
 	MCESEV(
 		PANIC, "Overflowed uncorrected",
-		BITSET(MCI_STATUS_UC|MCI_STATUS_OVER)
+		BITSET(MCI_STATUS_OVER|MCI_STATUS_UC)
 		),
 	MCESEV(
 		UC, "Uncorrected",
@@ -157,15 +156,15 @@ static int error_context(struct mce *m)
 	return IN_KERNEL;
 }
 
-int mce_severity(struct mce *a, int tolerant, char **msg)
+int mce_severity(struct mce *m, int tolerant, char **msg)
 {
-	enum context ctx = error_context(a);
+	enum context ctx = error_context(m);
 	struct severity *s;
 
 	for (s = severities;; s++) {
-		if ((a->status & s->mask) != s->result)
+		if ((m->status & s->mask) != s->result)
 			continue;
-		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
+		if ((m->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
 		if (s->ser == SER_REQUIRED && !mce_ser)
 			continue;
@@ -242,15 +241,15 @@ static const struct file_operations severities_coverage_fops = {
 
 static int __init severities_debugfs_init(void)
 {
-	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
+	struct dentry *dmce, *fsev;
 
 	dmce = mce_get_debugfs_dir();
-	if (dmce == NULL)
+	if (!dmce)
 		goto err_out;
-	fseverities_coverage = debugfs_create_file("severities-coverage",
-						   0444, dmce, NULL,
-						   &severities_coverage_fops);
-	if (fseverities_coverage == NULL)
+
+	fsev = debugfs_create_file("severities-coverage", 0444, dmce, NULL,
+				   &severities_coverage_fops);
+	if (!fsev)
 		goto err_out;
 
 	return 0;
@@ -259,4 +258,4 @@ err_out:
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
-#endif
+#endif /* CONFIG_DEBUG_FS */
