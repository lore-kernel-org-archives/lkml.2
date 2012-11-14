Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2KNGaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:30:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2KNGai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:30:38 -0500
Date: Tue, 13 Nov 2012 22:30:09 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-8ww8zc4hhpxabfskxs3u5ede@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Warn about missing libelf
Git-Commit-ID: d30ff29562ecbf79e82df72724d0c6180f2e2c06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:30:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d30ff29562ecbf79e82df72724d0c6180f2e2c06
Gitweb:     http://git.kernel.org/tip/d30ff29562ecbf79e82df72724d0c6180f2e2c06
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 30 Oct 2012 00:06:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:17:48 -0200

perf tools: Warn about missing libelf

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
 1 files changed, 2 insertions(+), 0 deletions(-)

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
