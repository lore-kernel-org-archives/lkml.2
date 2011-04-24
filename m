Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1DXJOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:14:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:19110 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1DXJOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:14:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,262,1301900400"; 
   d="scan'208";a="424547677"
Subject: [PATCH] perf probe: Fix the missed parameter initialization in
 fastpath lookup
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 17:14:40 +0800
Message-Id: <1303636480.3928.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pubname_callback_param::found should be initialized to 0.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/probe-finder.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a7c7145..3b9d0b8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1538,6 +1538,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 			.file	  = pp->file,
 			.cu_die	  = &pf->cu_die,
 			.sp_die	  = &pf->sp_die,
+			.found	  = 0,
 		};
 		struct dwarf_callback_param probe_param = {
 			.data = pf,


