Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2IUFYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:24:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47199 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2IUFYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:24:46 -0400
X-AuditID: 9c930197-b7b6dae000000e70-83-505bfa1c4e52
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 0/4] perf header: Save and reuse feature information in header (v4)
Date: Fri, 21 Sep 2012 14:16:00 +0900
Message-Id: <1348204564-1105-1-git-send-email-namhyung@kernel.org>
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

Namhyung Kim (4):
  perf header: Add struct perf_session_env
  perf header: Add ->process callbacks to most of features
  perf header: Use pre-processed session env when printing
  perf header: Remove unused @feat arg from ->process callback

 tools/perf/util/header.c | 547 +++++++++++++++++++++++++++++++++--------------
 tools/perf/util/header.h |  24 +++
 2 files changed, 408 insertions(+), 163 deletions(-)

-- 
1.7.11.4

