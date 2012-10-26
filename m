Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab2JZPIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:08:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:08:51 -0400
Date: Fri, 26 Oct 2012 08:08:23 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fcc328032e7382bf413517ee4dddf1eca7970fe4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@amd64.org, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@amd64.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1351241752-2919-5-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix LIBELF_MMAP checking
Git-Commit-ID: fcc328032e7382bf413517ee4dddf1eca7970fe4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcc328032e7382bf413517ee4dddf1eca7970fe4
Gitweb:     http://git.kernel.org/tip/fcc328032e7382bf413517ee4dddf1eca7970fe4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 26 Oct 2012 17:55:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:24 -0200

perf tools: Fix LIBELF_MMAP checking

Currently checking mmap support in libelf failed due to wrong flags.

    CHK libelf
    CHK libdw
    CHK libunwind
    CHK -DLIBELF_MMAP
/tmp/ccYJwdR0.o: In function `main':
:(.text+0x18): undefined reference to `elf_begin'
collect2: error: ld returned 1 exit status

This cannot happen since we checked the elf_begin() when checking
libelf and it succeeded.

Fix it by using a same flag with libelf checking.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351241752-2919-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d0c09a..629fc6a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -541,7 +541,8 @@ LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 else # NO_LIBELF
 BASIC_CFLAGS += -DLIBELF_SUPPORT
 
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON),-DLIBELF_MMAP),y)
+FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 	BASIC_CFLAGS += -DLIBELF_MMAP
 endif
 
