Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0C3XSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:18:17 -0400
Received: from kroah.org ([198.145.64.141]:52022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0C3XSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:07 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:31 2010
Message-Id: <20100330225630.552487526@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Kacur <jkacur@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Kyle McMartin <kyle@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [050/116] perf: Make the install relative to DESTDIR if specified
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Kacur <jkacur@redhat.com>

commit 7ae5f21361fea11f58c398701da635f778635d13 upstream.

Without this change, the install path is relative to
prefix/DESTDIR where prefix is automatically set to $HOME.

This can produce unexpected results. For example:

  make -C tools/perf DESTDIR=/home/jkacur/tmp install-man

creates the directory:		/home/jkacur/home/jkacur/tmp/share/...
instead of the expected:	/home/jkacur/tmp/share/...

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Kyle McMartin <kyle@redhat.com>
LKML-Reference: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/Documentation/Makefile |    4 +++-
 tools/perf/Makefile               |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -24,7 +24,10 @@ DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT
 DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
 DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
 
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
 prefix?=$(HOME)
+endif
 bindir?=$(prefix)/bin
 htmldir?=$(prefix)/share/doc/perf-doc
 pdfdir?=$(prefix)/share/doc/perf-doc
@@ -32,7 +35,6 @@ mandir?=$(prefix)/share/man
 man1dir=$(mandir)/man1
 man5dir=$(mandir)/man5
 man7dir=$(mandir)/man7
-# DESTDIR=
 
 ASCIIDOC=asciidoc
 ASCIIDOC_EXTRA = --unsafe
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -218,7 +218,10 @@ STRIP ?= strip
 # runtime figures out where they are based on the path to the executable.
 # This can help installing the suite in a relocatable way.
 
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
 prefix = $(HOME)
+endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 mandir = share/man
@@ -235,7 +238,6 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
-# DESTDIR=
 
 export prefix bindir sharedir sysconfdir
 


