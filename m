Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683Ab2JaOtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2JaOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf tools: Warn about missing libelf
Date: Wed, 31 Oct 2012 12:48:58 -0200
Message-Id: <1351694943-7188-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351694943-7188-1-git-send-email-acme@infradead.org>
References: <1351694943-7188-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf detects no libelf during the build, it'll use internal mini
elf parser instead of libelf.  But as it only supports minimal
functionalities, it also disables support to 'probe' builtin command.

Currently it didn't warned to user.  Fix it.

$ sudo apt-get remove libelf-dev
$ make
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK bionic
    CHK libelf
    CHK glibc
Makefile:491: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
    CHK libunwind
    CHK libaudit

$ make NO_LIBELF=1
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK bionic
    CHK libaudit

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8ww8zc4hhpxabfskxs3u5ede@git.kernel.org
[ committer note: The package needed is elfutils-libelf-devel, not elfutils-devel ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e25f59..b1801e0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -490,6 +490,8 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
 		LIBC_SUPPORT := 1
 	endif
 	ifeq ($(LIBC_SUPPORT),1)
+		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+
 		NO_LIBELF := 1
 		NO_DWARF := 1
 		NO_DEMANGLE := 1
-- 
1.7.9.2.358.g22243

