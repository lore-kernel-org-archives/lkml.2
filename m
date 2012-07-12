Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162928Ab2GLXGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:06:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63438 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162849Ab2GLXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 59/68] x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
Date: Thu, 12 Jul 2012 16:02:33 -0700
Message-Id: <20120712175040.647309569@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/scattered.c   |    2 +-
 drivers/hwmon/coretemp.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -173,7 +173,7 @@
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,7 +31,7 @@ void __cpuinit init_scattered_cpuid_feat
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -709,7 +709,7 @@ static void __cpuinit get_core_online(un
 	 * sensors. We check this bit only, all the early CPUs
 	 * without thermal sensors will be filtered out.
 	 */
-	if (!cpu_has(c, X86_FEATURE_DTS))
+	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return;
 
 	if (!pdev) {


