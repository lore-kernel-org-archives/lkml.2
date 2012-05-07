Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2EGIrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:47:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2EGIrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:47:03 -0400
Date: Mon, 7 May 2012 01:46:41 -0700
From: tip-bot for Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <tip-09c0211c0bb0e40231e6ee9a35041d467ed72f16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        gregkh@linuxfoundation.org, tglx@linutronix.de
Reply-To: gregkh@linuxfoundation.org, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, tglx@linutronix.de
In-Reply-To: <20120504183254.GA11154@kroah.com>
References: <20120504183254.GA11154@kroah.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Turn off compiler warnings for flex and bison generated files
Git-Commit-ID: 09c0211c0bb0e40231e6ee9a35041d467ed72f16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 01:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09c0211c0bb0e40231e6ee9a35041d467ed72f16
Gitweb:     http://git.kernel.org/tip/09c0211c0bb0e40231e6ee9a35041d467ed72f16
Author:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
AuthorDate: Fri, 4 May 2012 11:32:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 10:03:01 +0200

perf: Turn off compiler warnings for flex and bison generated files

We don't know what types of warnings different versions of flex
and bison combined with different versions of gcc is going to
generate, so just punt and don't warn about anything.

This fixes the build of perf for me on an openSUSE 12.1 system.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20120504183254.GA11154@kroah.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9bf3fc7..92271d3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -774,10 +774,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
