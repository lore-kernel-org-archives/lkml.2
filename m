Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab2HJWXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:23:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37695 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2HJWXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:30 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 01/16] perf symbol: correct comment wrt kallsyms loading
Date: Fri, 10 Aug 2012 15:22:47 -0700
Message-Id: <1344637382-22789-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-1976-0000-0000-000010120833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kallsyms_parse() when calling process_symbol() (a callback argument
to kallsyms_parse()), we pass start as both start & end (ie:
start=start, end=start).

In map__process_kallsym_symbol(), the length is calculated as 'end - start + 1',
making the length 1, not 0.

Essentially, start & end define an inclusive range.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f02de8a..891f83c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -605,7 +605,7 @@ int kallsyms__parse(const char *filename, void *arg,
 
 		/*
 		 * module symbols are not sorted so we add all
-		 * symbols with zero length and rely on
+		 * symbols, setting length to 1, and rely on
 		 * symbols__fixup_end() to fix it up.
 		 */
 		err = process_symbol(arg, symbol_name,
-- 
1.7.11.3

