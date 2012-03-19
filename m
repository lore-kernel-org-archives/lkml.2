Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032825Ab2CSTz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:55:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032756Ab2CSTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:55:54 -0400
Date: Mon, 19 Mar 2012 12:55:31 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-4a3d2d9bfb3b594b6e1f2b7eabfaf4e820a18c0e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4F588A0802000078000770FF@nat28.tlf.novell.com>
References: <4F588A0802000078000770FF@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Adjust make rules
Git-Commit-ID: 4a3d2d9bfb3b594b6e1f2b7eabfaf4e820a18c0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 12:55:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a3d2d9bfb3b594b6e1f2b7eabfaf4e820a18c0e
Gitweb:     http://git.kernel.org/tip/4a3d2d9bfb3b594b6e1f2b7eabfaf4e820a18c0e
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 8 Mar 2012 09:29:28 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 15 Mar 2012 14:23:28 -0300

perf tools: Adjust make rules

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
 1 files changed, 5 insertions(+), 1 deletions(-)

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
