Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2HTE7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:59:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44965 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HTE7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:59:07 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-0b-5031c41a95bc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/7] Cleanup hist printing code (v3)
Date: Mon, 20 Aug 2012 13:52:04 +0900
Message-Id: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a cleanup and refactoring patchset for the hist printing code
by adding hist_period_print functions and hpp_context.  I believe it
makes the code easy to maintain and to add new functionalities like
upcoming group viewing and callchain accumulation.

Any comments are welcome, thanks.
Namhyung

v2 -> v3:
 * Rebase to current acme/perf/core
 * Move fprintf code to ui/stdio/hist.c (Arnaldo)
 * Add ack from Pekka


Namhyung Kim (7):
  perf hists: Separate out hist print functions
  perf hists: Refactor some functions
  perf hists: Introduce hist_period_print functions
  perf hists: Handle field separator properly
  perf hists: Use hpp_functions->width to calculate the column widths
  perf ui/browser: Use hist_period_print functions
  perf gtk/browser: Use hist_period_print functions

 tools/perf/Makefile            |   5 +-
 tools/perf/builtin-diff.c      |   1 +
 tools/perf/ui/browsers/hists.c |  96 ++++--
 tools/perf/ui/gtk/browser.c    | 101 +++++-
 tools/perf/ui/gtk/gtk.h        |   1 +
 tools/perf/ui/gtk/setup.c      |   1 +
 tools/perf/ui/hist.c           | 391 +++++++++++++++++++++++
 tools/perf/ui/setup.c          |   8 +-
 tools/perf/ui/stdio/hist.c     | 498 +++++++++++++++++++++++++++++
 tools/perf/ui/tui/setup.c      |   4 +
 tools/perf/util/hist.c         | 710 ++---------------------------------------
 tools/perf/util/hist.h         |  43 ++-
 12 files changed, 1121 insertions(+), 738 deletions(-)
 create mode 100644 tools/perf/ui/hist.c
 create mode 100644 tools/perf/ui/stdio/hist.c

-- 
1.7.11.2

