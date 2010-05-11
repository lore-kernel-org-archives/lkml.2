Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0EKQaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:30:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:37539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0EKQaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:30:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf symbols: allow forcing use of cplus_demangle
Date: Tue, 11 May 2010 13:29:50 -0300
Message-Id: <1273595390-6486-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273595390-6486-1-git-send-email-acme@infradead.org>
References: <1273595390-6486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>

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
 
-- 
1.6.2.5

