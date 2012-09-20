Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2ITFpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:45:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60822 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2ITFpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:45:35 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-75-505aad7b48d5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf header: Save and reuse feature information in header (v3)
Date: Thu, 20 Sep 2012 14:36:43 +0900
Message-Id: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently the perf header information is used only at initial setup
time and discarded.  If it's saved we could reuse the information for
various purpose in the future.

Thanks,
Namhyung


v2 -> v3:
 * patch 1-3 in v2 merged into tip
 * rebased on current acme/perf/core

v1 -> v2:
 * not touch EVENT_DESC feature handling
 * split out struct perf_header_info
 * simplify multi-string handling
 * add some cleanup patches


Namhyung Kim (4):
  perf header: Add struct perf_header_info
  perf header: Add ->process callbacks to most of features
  perf header: Use pre-processed header info when printing
  perf header: Remove unused @feat arg from ->process callback

 tools/perf/util/header.c | 547 +++++++++++++++++++++++++++++++++--------------
 tools/perf/util/header.h |  24 +++
 2 files changed, 408 insertions(+), 163 deletions(-)

-- 
1.7.11.4

