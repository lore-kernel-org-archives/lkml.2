Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2JZI44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:56:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61903 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab2JZI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:38 -0400
X-AuditID: 9c930179-b7c8bae000003559-59-508a503f15ee
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@amd64.org>
Subject: [PATCH 5/5] perf tools: Fix LIBELF_MMAP checking
Date: Fri, 26 Oct 2012 17:55:52 +0900
Message-Id: <1351241752-2919-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d0c09ab58b8..629fc6a4b0df 100644
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
 
-- 
1.7.11.7

