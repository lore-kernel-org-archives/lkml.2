Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1L0Pge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:36:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1L0PgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:36:04 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip:perf/core 3/4] perf top: Fix a memory leak
Date: Wed, 28 Dec 2011 00:35:50 +0900
Message-Id: <1325000151-4463-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'buf' should be freed when symbol wasn't found too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-top.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c3836b966ccf..4f81eeb99875 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -351,7 +351,6 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (!found) {
 		fprintf(stderr, "Sorry, %s is not active.\n", buf);
 		sleep(1);
-		return;
 	} else
 		perf_top__parse_source(top, found);
 
-- 
1.7.6

