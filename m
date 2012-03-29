Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2C2Gg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:36:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2C2Ggt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:36:49 -0400
X-AuditID: 9c93016f-b7c86ae000005478-19-4f7402fe162b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [RFC v2 0/7] perf ui: Small preparation for furthure UI work
Date: Thu, 29 Mar 2012 15:36:37 +0900
Message-Id: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my ground work of UI generalization. As we now get GTK2 support on
perf report, improve setup_browser() to handle it properly so that we can
add various UI specific initialization codes to the function. At least, we
need basic error/warning handlers ASAP to see what's going on when an error
occurred, IMHO.

Any comments are welcome.
Thanks.


v1 -> v2:
 * Move whole UI codes to tools/perf/ui directory and split front-end
   specific bits to subdirectories.
 * Add ACK's from Pekka Enberg.

Namhyung Kim (7):
  perf tools: Move UI bits to tools/perf/ui directory
  perf tools: Move GTK+ bits to tools/perf/ui/gtk directory
  perf ui: Make setup_browser() generic
  perf ui: Drop arg[cv] arguments from perf_gtk_setup_browser()
  perf ui/gtk: Rename functions for consistency
  perf ui: Add gtk2 support into setup_browser()
  perf ui: Change fallback policy of setup_browser()

 tools/perf/Makefile                          |   50 +++++++++-------
 tools/perf/builtin-report.c                  |   10 +--
 tools/perf/{util => }/ui/browser.c           |    8 +-
 tools/perf/{util => }/ui/browser.h           |    2 +-
 tools/perf/{util => }/ui/browsers/annotate.c |   10 ++--
 tools/perf/{util => }/ui/browsers/hists.c    |   12 ++--
 tools/perf/{util => }/ui/browsers/map.c      |    6 +-
 tools/perf/{util => }/ui/browsers/map.h      |    0
 tools/perf/{util => ui}/gtk/browser.c        |   41 +++++---------
 tools/perf/{util => ui}/gtk/gtk.h            |    0
 tools/perf/ui/gtk/setup.c                    |   12 ++++
 tools/perf/{util => }/ui/helpline.c          |    2 +-
 tools/perf/{util => }/ui/helpline.h          |    0
 tools/perf/{util => }/ui/keysyms.h           |    0
 tools/perf/{util => }/ui/libslang.h          |    0
 tools/perf/{util => }/ui/progress.c          |    2 +-
 tools/perf/{util => }/ui/progress.h          |    0
 tools/perf/ui/setup.c                        |   42 ++++++++++++++
 tools/perf/{util/ui => ui/tui}/setup.c       |   77 ++++++++++---------------
 tools/perf/{util => }/ui/ui.h                |    0
 tools/perf/{util => }/ui/util.c              |    6 +-
 tools/perf/{util => }/ui/util.h              |    0
 tools/perf/util/cache.h                      |   24 ++++++--
 tools/perf/util/debug.h                      |    2 +-
 tools/perf/util/hist.h                       |    2 +-
 25 files changed, 174 insertions(+), 134 deletions(-)

-- 
1.7.7.6

