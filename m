Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2GVNo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 09:44:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57587 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GVNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 09:44:56 -0400
Date: Sun, 22 Jul 2012 15:44:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build change for v3.6
Message-ID: <20120722134451.GA7099@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   HEAD: d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27 x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported

 Thanks,

	Ingo

------------------>
H.J. Lu (1):
      x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported


 arch/x86/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1f25214..b0c5276 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -49,6 +49,9 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
+	# Use -mpreferred-stack-boundary=3 if supported.
+	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
+
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
