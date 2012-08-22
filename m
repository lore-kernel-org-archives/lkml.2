Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2HVFz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:55:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49264 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2HVFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:55:25 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-17-5034744b5037
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] perf tools: Cleanup hist printing code (v4)
Date: Wed, 22 Aug 2012 14:48:32 +0900
Message-Id: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a cleanup and refactoring patchset for the hist printing code
by adding perf_hpp__format functions and perf_hpp.  I believe it makes
the code easy to maintain and to add new features like upcoming group
viewing and callchain accumulation.

Any comments are welcome, thanks.
Namhyung

v3 -> v4:
 * Rebase to current acme/perf/core
 * The first two in the previous series have been merged
 * Rename hist_period_print to perf_hpp_fmt (Arnaldo)
 * Rename ctx->s to hpp->buf (Arnaldo)

v2 -> v3:
 * Move fprintf code to ui/stdio/hist.c (Arnaldo)
 * Add ack from Pekka


Namhyung Kim (5):
  perf hists: Introduce perf_hpp for hist period printing
  perf hists: Handle field separator properly
  perf hists: Use perf_hpp__format->width to calculate the column widths
  perf ui/browser: Use perf_hpp__format functions
  perf gtk/browser: Use perf_hpp__format functions

 tools/perf/Makefile            |   2 +
 tools/perf/builtin-diff.c      |   1 +
 tools/perf/ui/browsers/hists.c |  94 ++++++++---
 tools/perf/ui/gtk/browser.c    | 101 ++++++++++--
 tools/perf/ui/gtk/gtk.h        |   1 +
 tools/perf/ui/gtk/setup.c      |   1 +
 tools/perf/ui/hist.c           | 366 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/setup.c          |   8 +-
 tools/perf/ui/stdio/hist.c     | 239 +++++----------------------
 tools/perf/ui/tui/setup.c      |   4 +
 tools/perf/util/hist.c         |  33 ----
 tools/perf/util/hist.h         |  37 +++++
 12 files changed, 616 insertions(+), 271 deletions(-)
 create mode 100644 tools/perf/ui/hist.c

-- 
1.7.11.4

