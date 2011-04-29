Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1D2IdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:33:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:41912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1D2IdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,286,1301900400"; 
   d="scan'208";a="685836908"
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH 1/2] perf probe: Fix the missed parameter initialization
Date: Fri, 29 Apr 2011 08:41:57 +0000
Message-Id: <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pubname_callback_param::found should be initialized to 0 in fastpath lookup.

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
-- 
1.7.4.4

