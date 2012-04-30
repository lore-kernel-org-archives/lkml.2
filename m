Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2D3E4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:56:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61445 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2D3E4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:56:14 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-6d-4f9e1b6ccc16
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 0/7] perf ui: Add basic error handling for GTK2 front-end
Date: Mon, 30 Apr 2012 13:55:04 +0900
Message-Id: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patch set for improving GTK2 support. Patch 1 - 5 are
generalization of setup_browser() to support GTK browser seamlessly.
These are basically resend of previous version that got ack from
Pekka - Only patch 4 was slightly modified to make TUI default as
it does now.

On patch 6, introduce perf_error_ops structure and its helper
perf_error__[un]register_functions to set UI specific error
reporting functions and make TUI use them. To do this, split
TUI specific bits to ui/tui/util.c file. Patch 7 applies it
to GTK also.

Patches are based on current tip/perf/core - 1fa2e84db3f9 ("Merge tag
'perf-annotate-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
into perf/core"). All of these are build-tested for all combinations
of NO_NEWT and NO_GTK2.

Any comments are welcome.

Thanks,
Namhyung


Namhyung Kim (7):
  perf ui: Make setup_browser() generic
  perf ui: Drop arg[cv] arguments from perf_gtk_setup_browser()
  perf ui/gtk: Rename functions for consistency
  perf ui: Add gtk2 support into setup_browser()
  perf ui: Change fallback policy of setup_browser()
  perf ui: Introduce struct perf_error_ops
  perf ui/gtk: Use struct perf_error_ops

 tools/perf/Makefile         |    9 ++
 tools/perf/builtin-report.c |   10 +-
 tools/perf/ui/gtk/browser.c |   37 +++---
 tools/perf/ui/gtk/gtk.h     |    4 +
 tools/perf/ui/gtk/setup.c   |   18 +++
 tools/perf/ui/gtk/util.c    |   67 +++++++++++
 tools/perf/ui/setup.c       |  168 +++++---------------------
 tools/perf/ui/tui/setup.c   |  146 +++++++++++++++++++++++
 tools/perf/ui/tui/util.c    |  243 +++++++++++++++++++++++++++++++++++++
 tools/perf/ui/util.c        |  277 +++++++++----------------------------------
 tools/perf/ui/util.h        |    9 +-
 tools/perf/util/cache.h     |   24 ++--
 tools/perf/util/debug.c     |    2 +-
 tools/perf/util/debug.h     |   23 +++-
 14 files changed, 635 insertions(+), 402 deletions(-)
 create mode 100644 tools/perf/ui/gtk/setup.c
 create mode 100644 tools/perf/ui/gtk/util.c
 create mode 100644 tools/perf/ui/tui/setup.c
 create mode 100644 tools/perf/ui/tui/util.c

-- 
1.7.10

