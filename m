Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab2JZOck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab2JZOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@amd64.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf tools: Fix LIBELF_MMAP checking
Date: Fri, 26 Oct 2012 12:31:49 -0200
Message-Id: <1351261913-28250-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
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
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 
-- 
1.7.9.2.358.g22243

