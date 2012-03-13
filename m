Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995Ab2CMAYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:48613 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab2CMAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 144/196] perf symbols: allow forcing use of cplus_demangle
Date: Mon, 12 Mar 2012 20:20:57 -0400
Message-Id: <1331598109-31424-99-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d11c7addfe0fa501cb54c824c0fac3481d527433 upstream.

For Fedora, I want to force perf to link against libiberty.a for
cplus_demangle, rather than libbfd.a for bfd_demangle due to licensing insanity
on binutils. (libiberty is LGPL2, libbfd is GPL3.)

If we just rely on autodetection, we'll end up with libbfd linked against us,
since they're both in binutils-static in the buildroot.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100510204335.GA7565@bombadil.infradead.org>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 tools/perf/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bc0f670..429bace 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -541,6 +541,9 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
+else ifdef HAVE_CPLUS_DEMANGLE
+	EXTLIBS += -liberty
+	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
 	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
 
-- 
1.7.9.3

