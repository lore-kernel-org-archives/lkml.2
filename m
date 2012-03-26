Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2CZIvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:51:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46627 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2CZIvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:51:39 -0400
X-AuditID: 9c93016f-b7cc6ae00000317e-15-4f702e186ec9
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [RFC PATCHSET] perf ui: Small preparation on further UI work
Date: Mon, 26 Mar 2012 17:51:31 +0900
Message-Id: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my initial work of UI generalization. As we now get GTK2 support on
perf report, improve setup_browser() to handle it properly so that we can
add various UI specific initialization codes to the function. At least, we
need basic error/warning handlers ASAP to see what's going on when an error
occurred, IMHO.

I put new file setup.c under ui directory (not under util/ui) and it may or
may not be compiled depending on the system configuration. I think it'd be
better moving generic UI codes to the directory and TUI specific codes to
ui/tui, and so on, so that the util directory doesn't contain any UI codes.
But before proceeding, I'd like to listen to your opinions :).

Any comments are welcome.
Thanks.

Namhyung Kim (5):
  perf ui: Make setup_browser() generic
  perf ui: Drop arg[cv] arguments from perf_gtk_setup_browser()
  perf ui: Add gtk2 support into setup_browser()
  perf gtk: Rename functions for consistency
  perf ui: Change fallback policy of setup_browser()

 tools/perf/Makefile           |    7 ++++-
 tools/perf/builtin-report.c   |    5 +---
 tools/perf/ui/setup.c         |   44 +++++++++++++++++++++++++++++
 tools/perf/util/cache.h       |   24 +++++++++++-----
 tools/perf/util/gtk/browser.c |   27 +++++++++---------
 tools/perf/util/gtk/gtk.h     |    4 +++
 tools/perf/util/ui/setup.c    |   61 +++++++++++++++-------------------------
 7 files changed, 108 insertions(+), 64 deletions(-)
 create mode 100644 tools/perf/ui/setup.c

-- 
1.7.7.6

