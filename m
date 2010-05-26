Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0EZUWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:22:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab0EZUWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:22:04 -0400
Date: Wed, 26 May 2010 20:21:44 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       borislav.petkov@amd.com
In-Reply-To: <20100525152858.GA24836@aftab>
References: <20100525152858.GA24836@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, k8: Fix section mismatch for powernowk8_exit()
Message-ID: <tip-fe501f1e89cd460793152f500bf25d81d463515b@git.kernel.org>
Git-Commit-ID: fe501f1e89cd460793152f500bf25d81d463515b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 May 2010 20:21:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe501f1e89cd460793152f500bf25d81d463515b
Gitweb:     http://git.kernel.org/tip/fe501f1e89cd460793152f500bf25d81d463515b
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 25 May 2010 15:28:58 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 May 2010 15:42:21 -0700

x86, k8: Fix section mismatch for powernowk8_exit()

Fix the following warning:

"WARNING: arch/x86/kernel/built-in.o(.exit.text+0x72):
Section mismatch in reference from the function powernowk8_exit() to the variable .cpuinit.data:cpb_nb

The function __exit powernowk8_exit() references a variable
__cpuinitdata cpb_nb. This is often seen when error handling in the exit
function uses functionality in the init path. The fix is often to remove
the __cpuinitdata annotation of cpb_nb so it may be used outside an init
section."

Cc: <stable@kernel.org>
Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100525152858.GA24836@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6f3dc8f..7ec2123 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1497,8 +1497,8 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
  * simply keep the boost-disable flag in sync with the current global
  * state.
  */
-static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
-				void *hcpu)
+static int cpb_notify(struct notifier_block *nb, unsigned long action,
+		      void *hcpu)
 {
 	unsigned cpu = (long)hcpu;
 	u32 lo, hi;
@@ -1528,7 +1528,7 @@ static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpb_nb = {
+static struct notifier_block cpb_nb = {
 	.notifier_call		= cpb_notify,
 };
 
