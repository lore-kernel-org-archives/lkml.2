Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab2E2EXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:23:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37705 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2E2EXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:23:10 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] perf ui: Add basic error handling for GTK2 front-end (v3)
Date: Tue, 29 May 2012 13:22:55 +0900
Message-Id: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements ui__warning/error() functions for GTK2.
Patch 1 is a resend (which forgot to cc LKML) and independent of
this series. Patch 2 converts invocations of ui__warning followed
by exit (or similar effect) into ui__error.

I chose GtkInfoBar widget to implement ui__warning since it provides
a simple way to do what we want IMHO. In fact, a guy sat next to me
at the Korean GNOME hackfest suggested to use it. The only problem
is it requires 2.18 (or newer) version of GTK+ libraries. So I added
status bar as a fallback when info bar is not supported, and this
can be used to implement helpline functions later.

Changes from v2:
 * Convert critical use of ui__warning to ui__error (by Ingo)
 * Use GtkInfoBar instead of a message dialog (by Pekka)

Any comments are welcome.

Thanks,
Namhyung


Namhyung Kim (7):
  perf ui: Make --stdio default when TUI is not supported
  perf tools: Convert critical messages to ui__error()
  perf ui: Introduce struct perf_error_ops
  perf ui/gtk: Introduce struct perf_gtk_context
  perf ui/gtk: Add GTK statusbar widget to browser window
  perf ui/gtk: Add GTK info_bar widget to browser window
  perf ui/gtk: Use struct perf_error_ops

 tools/perf/Makefile                 |    6 +
 tools/perf/builtin-annotate.c       |    2 +-
 tools/perf/builtin-record.c         |   14 +-
 tools/perf/builtin-report.c         |   14 +-
 tools/perf/builtin-top.c            |   22 +--
 tools/perf/config/feature-tests.mak |   13 ++
 tools/perf/ui/gtk/browser.c         |   67 ++++++++-
 tools/perf/ui/gtk/gtk.h             |   31 ++++
 tools/perf/ui/gtk/setup.c           |    5 +
 tools/perf/ui/gtk/util.c            |  129 ++++++++++++++++
 tools/perf/ui/setup.c               |    1 +
 tools/perf/ui/tui/setup.c           |    6 +
 tools/perf/ui/tui/util.c            |  243 ++++++++++++++++++++++++++++++
 tools/perf/ui/util.c                |  277 +++++++----------------------------
 tools/perf/ui/util.h                |    9 +-
 tools/perf/util/debug.c             |    2 +-
 tools/perf/util/debug.h             |   23 ++-
 17 files changed, 609 insertions(+), 255 deletions(-)
 create mode 100644 tools/perf/ui/gtk/util.c
 create mode 100644 tools/perf/ui/tui/util.c

-- 
1.7.9.2

