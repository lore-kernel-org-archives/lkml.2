Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2HFJDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:03:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51232 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2HFJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:03:49 -0400
X-AuditID: 9c930179-b7bdcae000003d91-10-501f8873147f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 0/7] perf hists: Cleanup hist printing code (v2)
Date: Mon,  6 Aug 2012 17:57:35 +0900
Message-Id: <1344243462-28403-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a cleanup and refactoring patchset for the hist printing code
by adding hist_period_print functions and hpp_context. I believe it
makes the code easy to maintain and to add new functionalities like
upcoming group viewing and callchain accumulation.

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (7):
  perf hists: Separate out hist print functions
  perf hists: Refactor some functions
  perf hists: Introduce hist_period_print functions
  perf hists: Handle field separator properly
  perf hists: Use hpp_functions->width to calculate the column widths
  perf ui/browser: Use hist_period_print functions
  perf gtk/browser: Use hist_period_print functions

 tools/perf/Makefile            |   4 +-
 tools/perf/builtin-diff.c      |   1 +
 tools/perf/ui/browsers/hists.c |  96 +++--
 tools/perf/ui/gtk/browser.c    | 101 ++++-
 tools/perf/ui/gtk/gtk.h        |   2 +
 tools/perf/ui/gtk/setup.c      |   1 +
 tools/perf/ui/hist.c           | 885 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/setup.c          |   8 +-
 tools/perf/ui/tui/setup.c      |   4 +
 tools/perf/util/hist.c         | 710 +--------------------------------
 tools/perf/util/hist.h         |  41 +-
 11 files changed, 1115 insertions(+), 738 deletions(-)
 create mode 100644 tools/perf/ui/hist.c

-- 
1.7.11.2

