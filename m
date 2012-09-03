Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2ICIU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:13446 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab2ICIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902996"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 6/7] perf ui/browser: Integrate script browser into annotation browser
Date: Mon,  3 Sep 2012 16:14:32 +0800
Message-Id: <1346660073-20279-7-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate the script browser into annotation, users can press function
key 'r' to list all perf scripts and select one of them to run that
script, the output will be shown in a separate browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/annotate.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 67a2703..29a273a 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -11,6 +11,8 @@
 #include <pthread.h>
 #include <newt.h>

+#include "scripts.h"
+
 struct browser_disasm_line {
 	struct rb_node	rb_node;
 	double		percent;
@@ -675,8 +677,14 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
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

