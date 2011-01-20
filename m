Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1ATJdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:33:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:37607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1ATJdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:33:03 -0500
Date: Thu, 20 Jan 2011 09:32:46 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: [PATCH] perftools: Fix build error
Message-ID: <20110120093246.GA8031@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 Jan 2011 09:32:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
CC builtin-top.o
cc1: warnings being treated as errors
builtin-top.c: In function 'print_sym_table':
builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 05344c6..8202a2e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -537,7 +537,7 @@ static void print_sym_table(void)
 	if (nr_counters == 1 || !display_weighted) {
 		struct perf_evsel *first;
 		first = list_entry(evsel_list.next, struct perf_evsel, node);
-		printf("%Ld", first->attr.sample_period);
+		printf("%Ld", (unsigned long long)first->attr.sample_period);
 		if (freq)
 			printf("Hz ");
 		else
-- 
1.7.3.4

