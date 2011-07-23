Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1GWI6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:58:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1GWI6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:58:04 -0400
Date: Sat, 23 Jul 2011 10:57:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20110723085720.GA16028@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
David Ahern (1):
      perf tools, x86: Fix 32-bit compile on 64-bit system


 tools/perf/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..c168366 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -52,7 +52,10 @@ ifeq ($(ARCH),i386)
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
-	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	IS_X86_64 := 0
+	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
 		ARCH_CFLAGS := -DARCH_X86_64
