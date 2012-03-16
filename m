Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997Ab2CPUCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:02:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34777 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab2CPUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Beulich <jbeulich@suse.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/13] perf tools: Adjust make rules
Date: Fri, 16 Mar 2012 17:01:58 -0300
Message-Id: <1331928130-16243-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

Add rules to generate pre-processed files (just like are available for
the normal kernel build), and adjust the rule to create assembly files
from C ones to produce its output in the output directory rather than
in the source tree.

E.g.

  $ make -C tools/perf/ O=/tmp/perf /tmp/perf/builtin-top.i
  make: Entering directory `/home/git/linux/tools/perf'
      CC /tmp/perf/builtin-top.i
  make: Leaving directory `/home/git/linux/tools/perf'
  $ wc -l /tmp/perf/builtin-top.i
  31379 /tmp/perf/builtin-top.i
  $

Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F588A0802000078000770FF@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fa04340..bd32855 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -727,10 +727,14 @@ $(OUTPUT)perf.o perf.spec \
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
 $(OUTPUT)%.o: %.S
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.S
+	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
 
 $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-- 
1.7.9.2.358.g22243

