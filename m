Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab2C3QKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:49264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2C3QJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf symbols: Handle NULL dso in dso__name_len
Date: Fri, 30 Mar 2012 13:09:19 -0300
Message-Id: <1333123764-15662-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

We should use "[unknown]" in this case, in concert with the code in
_hist_entry__dso_snprintf().

Otherwise we'll crash when recomputing the histogram column lengths in
hists__calc_col_len().

Signed-off-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120325.162822.2267799792062571623.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d9e995b..c0a028c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -50,6 +50,8 @@ struct symbol_conf symbol_conf = {
 
 int dso__name_len(const struct dso *dso)
 {
+	if (!dso)
+		return strlen("[unknown]");
 	if (verbose)
 		return dso->long_name_len;
 
-- 
1.7.9.2.358.g22243

