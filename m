Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2I1IhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:21636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2I1IhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188625"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 4/8] perf ui/browser: Integrate script browser into annotation browser
Date: Fri, 28 Sep 2012 16:30:36 +0800
Message-Id: <1348821040-9724-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate the script browser into annotation, users can press function
key 'r' to list all perf scripts and select one of them to run that
script, the output will be shown in a separate browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/annotate.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 8f8cd2d..28f8aab 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -676,8 +676,14 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		"o             Toggle disassembler output/simplified view\n"
 		"s             Toggle source code view\n"
 		"/             Search string\n"
+		"r             Run available scripts\n"
 		"?             Search previous string\n");
 			continue;
+		case 'r':
+			{
+				script_browse(NULL);
+				continue;
+			}
 		case 'H':
 			nd = browser->curr_hot;
 			break;
-- 
1.7.1

