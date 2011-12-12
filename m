Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1LLPSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:18:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1LLPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:22 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] perf symbols: Fix error path on symbol__init()
Date: Tue, 13 Dec 2011 00:16:52 +0900
Message-Id: <1323703017-6060-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The order of freeing comm_list and dso_list should be
reversed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e54b13d4c357..215d50f2042e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2604,10 +2604,10 @@ int symbol__init(void)
 	symbol_conf.initialized = true;
 	return 0;
 
-out_free_dso_list:
-	strlist__delete(symbol_conf.dso_list);
 out_free_comm_list:
 	strlist__delete(symbol_conf.comm_list);
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
 	return -1;
 }
 
-- 
1.7.6

