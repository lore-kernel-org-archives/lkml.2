Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab1LFKSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:18:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052Ab1LFKSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:18:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH -tip] x86: fix build without CONFIG_X86_MRST
Date: Tue,  6 Dec 2011 11:18:22 +0100
Message-Id: <1323166702-12990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error when compiled with CONFIG_X86_INTEL_MID and
without CONFIG_X86_MRST:

arch/x86/built-in.o: In function `add_rtc_cmos':
rtc.c:(.init.text+0x34bd): undefined reference to `__mrst_cpu_chip'

Problem was caused currently by:

commit 35d476996288af6a4aaa8b172bcd31decd233de7
Author: Mathias Nyman <mathias.nyman@linux.intel.com>
Date:   Tue Nov 15 14:46:52 2011 -0800

    x86/rtc, mrst: Don't register a platform RTC device for for Intel MID platforms

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 arch/x86/include/asm/mrst.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 93f7909..3f4589b 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -32,18 +32,14 @@ enum mrst_cpu_type {
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
 
-#ifdef CONFIG_X86_INTEL_MID
-
+#ifdef CONFIG_X86_MRST
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
-
-#else /* !CONFIG_X86_INTEL_MID */
-
+#else
 #define mrst_identify_cpu()    (0)
-
-#endif /* !CONFIG_X86_INTEL_MID */
+#endif
 
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
-- 
1.7.1

