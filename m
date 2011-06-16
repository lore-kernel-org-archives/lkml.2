Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1FPJNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:13:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:50852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1FPJNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:13:43 -0400
Date: Thu, 16 Jun 2011 09:13:20 GMT
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-203db2952bc87f5d610c9ad53a7d02b85897721f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        minipli@googlemail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        minipli@googlemail.com, acme@ghostprotocols.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1308171818-20370-1-git-send-email-minipli@googlemail.com>
References: <1308171818-20370-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools/perf: Fix static build of perf tool
Git-Commit-ID: 203db2952bc87f5d610c9ad53a7d02b85897721f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 09:13:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  203db2952bc87f5d610c9ad53a7d02b85897721f
Gitweb:     http://git.kernel.org/tip/203db2952bc87f5d610c9ad53a7d02b85897721f
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Wed, 15 Jun 2011 23:03:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Jun 2011 10:17:39 +0200

tools/perf: Fix static build of perf tool

To build a statically linked version of the perf tool all needed
libraries must be added in the correct order to get the symbols
resolved. Currently this is broken when, e.g. python or newt
support is enabled -- libpython needs libpthread which is an
unconditional link dependency of the perf tool; libslang needs
libm, another unconditional dependency. To solve the problem in
the long run without the need to keep track of transitive
library dependencies, simply make the linker look at the EXTLIBS
multiple times until it has all symbols resolved.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1308171818-20370-1-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..940257b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -633,7 +633,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
 ALL_CFLAGS += $(ARCH_CFLAGS)
