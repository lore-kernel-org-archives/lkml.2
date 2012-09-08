Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2IHLoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:44:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2IHLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:44:03 -0400
Date: Sat, 8 Sep 2012 04:43:39 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-b771a8306205f0261496e93574a71bc7106844dc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347065004-15306-6-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-6-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: include basename for non-glibc systems
Git-Commit-ID: b771a8306205f0261496e93574a71bc7106844dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:43:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b771a8306205f0261496e93574a71bc7106844dc
Gitweb:     http://git.kernel.org/tip/b771a8306205f0261496e93574a71bc7106844dc
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 03:43:17 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 22:06:53 -0300

perf tools: include basename for non-glibc systems

perf uses the glibc version of basename(), by defining _GNU_SOURCE,
including string.h and not including libgen.h. The glibc version of
basename is better than the POSIX version since it does not modify its
argument.

Android has only one version of basename which is defined in libgen.h.
This version is the same as the glibc version.

Error on Android:
util/annotate.c: In function 'symbol__annotate_printf':
util/annotate.c:503:3: error: implicit declaration of function 'basename'
[-Werror=implicit-function-declaration]
util/annotate.c:503:3: error: nested extern declaration of 'basename'
[-Werror=nested-externs]
util/annotate.c:503:14: error: assignment makes pointer from integer without
a cast [-Werror]

On Android libgen.h should be included to define basename.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-6-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fc4b1e6..d3b330c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,6 +10,9 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <byteswap.h>
+#if defined(__BIONIC__)
+#include <libgen.h>
+#endif
 
 #ifndef NO_LIBELF_SUPPORT
 #include <libelf.h>
