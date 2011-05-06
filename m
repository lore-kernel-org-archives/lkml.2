Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1EFAo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:44:28 -0400
Received: from kroah.org ([198.145.64.141]:37162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab1EFAZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:15 2011
Message-Id: <20110506002215.460216717@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [104/143] perf symbols: allow forcing use of cplus_demangle
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@mcmartin.ca>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -450,6 +450,9 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
+else ifdef HAVE_CPLUS_DEMANGLE
+	EXTLIBS += -liberty
+	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
 	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
 


