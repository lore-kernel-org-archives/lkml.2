Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2IXIXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:23:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42779 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2IXIXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:23:32 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-d1-50601882b5a1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/6] perf header: Save and reuse feature information in header (v5)
Date: Mon, 24 Sep 2012 17:14:57 +0900
Message-Id: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently the perf header information is used only at initial setup
time and discarded.  If it's saved we could reuse the information for
various purpose - for instance, perf kvm stat needs to know cpuid so
it had to invent an accessor.

Thanks,
Namhyung


v4 -> v5:
 * Use saved cpuid info for perf kvm (David)

v3 -> v4:
 * rename perf_header_info to perf_session_env (Arnaldo)

v2 -> v3:
 * patch 1-3 in v2 merged into tip
 * rebased on current acme/perf/core

v1 -> v2:
 * not touch EVENT_DESC feature handling
 * split out struct perf_header_info
 * simplify multi-string handling
 * add some cleanup patches

Namhyung Kim (6):
  perf header: Add struct perf_session_env
  perf header: Add ->process callbacks to most of features
  perf header: Use pre-processed session env when printing
  perf header: Remove unused @feat arg from ->process callback
  perf kvm: Use perf_session_env for reading cpuid
  perf header: Remove perf_header__read_feature

 tools/perf/builtin-kvm.c |  10 +-
 tools/perf/util/header.c | 598 ++++++++++++++++++++++++++++++-----------------
 tools/perf/util/header.h |  25 +-
 3 files changed, 406 insertions(+), 227 deletions(-)

-- 
1.7.11.4

