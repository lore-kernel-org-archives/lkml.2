Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935877Ab0HFXCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:02:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:55005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab0HFXCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:41 -0400
Date: Fri, 6 Aug 2010 23:02:25 GMT
Message-Id: <201008062302.o76N2PR1016685@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vmware for 2.6.36
Cc: Alok N Kataria <akataria@vmware.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vmware-for-linus

Alok Kataria (1):
      x86, vmware: Preset lpj values when on VMware.

 arch/x86/kernel/cpu/vmware.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index b9d1ff5..227b044 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -51,7 +51,7 @@ static inline int __vmware_platform(void)
 
 static unsigned long vmware_get_tsc_khz(void)
 {
-	uint64_t tsc_hz;
+	uint64_t tsc_hz, lpj;
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
@@ -62,6 +62,13 @@ static unsigned long vmware_get_tsc_khz(void)
 	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
 			 (unsigned long) tsc_hz / 1000,
 			 (unsigned long) tsc_hz % 1000);
+
+	if (!preset_lpj) {
+		lpj = ((u64)tsc_hz * 1000);
+		do_div(lpj, HZ);
+		preset_lpj = lpj;
+	}
+
 	return tsc_hz;
 }
 
