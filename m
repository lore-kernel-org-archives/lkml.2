Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0ELIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:41:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:54401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab0ELIlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:41:18 -0400
Date: Wed, 12 May 2010 08:40:23 GMT
From: tip-bot for Kyle McMartin <kyle@mcmartin.ca>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, kyle@mcmartin.ca, kyle@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, kyle@mcmartin.ca, kyle@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100510204335.GA7565@bombadil.infradead.org>
References: <20100510204335.GA7565@bombadil.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: allow forcing use of cplus_demangle
Message-ID: <tip-d11c7addfe0fa501cb54c824c0fac3481d527433@git.kernel.org>
Git-Commit-ID: d11c7addfe0fa501cb54c824c0fac3481d527433
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 08:40:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11c7addfe0fa501cb54c824c0fac3481d527433
Gitweb:     http://git.kernel.org/tip/d11c7addfe0fa501cb54c824c0fac3481d527433
Author:     Kyle McMartin <kyle@mcmartin.ca>
AuthorDate: Mon, 10 May 2010 16:43:35 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 May 2010 12:43:11 -0300

perf symbols: allow forcing use of cplus_demangle

For Fedora, I want to force perf to link against libiberty.a for
cplus_demangle, rather than libbfd.a for bfd_demangle due to licensing insanity
on binutils. (libiberty is LGPL2, libbfd is GPL3.)

If we just rely on autodetection, we'll end up with libbfd linked against us,
since they're both in binutils-static in the buildroot.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100510204335.GA7565@bombadil.infradead.org>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b28bb73..0797786 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -592,6 +592,9 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
+else ifdef HAVE_CPLUS_DEMANGLE
+	EXTLIBS += -liberty
+	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
 	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
 
