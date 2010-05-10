Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0EJUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:43:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0EJUnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:43:37 -0400
Date: Mon, 10 May 2010 16:43:35 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: allow forcing use of cplus_demangle
Message-ID: <20100510204335.GA7565@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Fedora, I want to force perf to link against libiberty.a for
cplus_demangle, rather than libbfd.a for bfd_demangle due to licensing
insanity on binutils. (libiberty is LGPL2, libbfd is GPL3.)

If we just rely on autodetection, we'll end up with libbfd linked
against us, since they're both in binutils-static in the buildroot.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
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
 
