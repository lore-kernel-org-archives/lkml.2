Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2HIWWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:22:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46361 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2HIWWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:22:01 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 01/16] perf symbol: correct comment wrt kallsyms loading
Date: Thu,  9 Aug 2012 15:18:26 -0700
Message-Id: <1344550721-21024-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-7606-0000-0000-000002AF8524
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
index 07e7bd6..df4736d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -616,7 +616,7 @@ int kallsyms__parse(const char *filename, void *arg,
 
 		/*
 		 * module symbols are not sorted so we add all
-		 * symbols with zero length and rely on
+		 * symbols, setting length to 1, and rely on
 		 * symbols__fixup_end() to fix it up.
 		 */
 		err = process_symbol(arg, symbol_name,
-- 
1.7.11.3

