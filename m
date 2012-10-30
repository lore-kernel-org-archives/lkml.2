Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab2J2D6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:58:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:42679 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab2J2D5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544425"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 4/8] perf ui/browser: Integrate script browser into annotation browser
Date: Tue, 30 Oct 2012 11:56:05 +0800
Message-Id: <1351569369-26732-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate the script browser into annotation, users can press function
key 'r' to list all perf scripts and select one of them to run that
script, the output will be shown in a separate browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/annotate.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
1.7.9.5

