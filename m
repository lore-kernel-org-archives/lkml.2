Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704Ab2FVUiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:38:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FVUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:38:44 -0400
Date: Fri, 22 Jun 2012 13:38:21 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-3bac8715443fc83413e221a5cd9d5cf3d82b79b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        JBeulich@suse.com, khali@linux-fr.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, khali@linux-fr.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4FE34BCB.5050305@linux.intel.com>
References: <4FE34BCB.5050305@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature:
  Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
Git-Commit-ID: 3bac8715443fc83413e221a5cd9d5cf3d82b79b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 22 Jun 2012 13:38:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bac8715443fc83413e221a5cd9d5cf3d82b79b4
Gitweb:     http://git.kernel.org/tip/3bac8715443fc83413e221a5cd9d5cf3d82b79b4
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 22 Jun 2012 10:58:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jun 2012 10:58:06 -0700

x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM

It makes sense to label "Digital Thermal Store" as "DTS", but
unfortunately the string "dts" was already used for "Debug Store", and
/proc/cpuinfo is a user space ABI.

Therefore, rename this to "dtherm".

This conflict went into mainline via the hwmon tree without any x86
maintainer ack, and without any kind of hint in the subject.

    a4659053 x86/hwmon: fix initialization of coretemp

Reported-by: Jean Delvare <khali@linux-fr.org>
Link: http://lkml.kernel.org/r/4FE34BCB.5050305@linux.intel.com
Cc: Jan Beulich <JBeulich@suse.com>
Cc: <stable@vger.kernel.org> v2.6.36..v3.4
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/scattered.c   |    2 +-
 drivers/hwmon/coretemp.c          |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 340ee49..f91e80f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -176,7 +176,7 @@
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
 
 /* Virtualization flags: Linux defined, word 8 */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index addf9e8..ee8e9ab 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,7 +31,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index b9d5123..0f52799 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -664,7 +664,7 @@ static void __cpuinit get_core_online(unsigned int cpu)
 	 * sensors. We check this bit only, all the early CPUs
 	 * without thermal sensors will be filtered out.
 	 */
-	if (!cpu_has(c, X86_FEATURE_DTS))
+	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return;
 
 	if (!pdev) {
@@ -765,7 +765,7 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
 };
 
 static const struct x86_cpu_id coretemp_ids[] = {
-	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
+	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTHERM },
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);
