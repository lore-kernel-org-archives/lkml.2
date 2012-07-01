Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2GASQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756029Ab2GASQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:52 -0400
Message-Id: <20120701172012.356550284@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, Jan Beulich <JBeulich@suse.com>
Subject: [ 40/48] x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 4ad33411308596f2f918603509729922a1ec4411 upstream.

It makes sense to label "Digital Thermal Sensor" as "DTS", but
unfortunately the string "dts" was already used for "Debug Store", and
/proc/cpuinfo is a user space ABI.

Therefore, rename this to "dtherm".

This conflict went into mainline via the hwmon tree without any x86
maintainer ack, and without any kind of hint in the subject.

    a4659053 x86/hwmon: fix initialization of coretemp

Reported-by: Jean Delvare <khali@linux-fr.org>
Link: http://lkml.kernel.org/r/4FE34BCB.5050305@linux.intel.com
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[bwh: Backported to 3.2: drop the coretemp device table change]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/scattered.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -175,7 +175,7 @@
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,7 +31,7 @@
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -660,7 +660,7 @@
 	 * sensors. We check this bit only, all the early CPUs
 	 * without thermal sensors will be filtered out.
 	 */
-	if (!cpu_has(c, X86_FEATURE_DTS))
+	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return;
 
 	if (!pdev) {


