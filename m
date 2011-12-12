Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1LLPR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1LLPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:26 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] perf tools: Fix a memory leak on perf_read_values_destroy
Date: Tue, 13 Dec 2011 00:16:53 +0900
Message-Id: <1323703017-6060-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After freeing each elements of the @values->value, we should free
itself too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/values.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index bdd33470b235..697c8b4e59cc 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -32,6 +32,7 @@ void perf_read_values_destroy(struct perf_read_values *values)
 
 	for (i = 0; i < values->threads; i++)
 		free(values->value[i]);
+	free(values->value);
 	free(values->pid);
 	free(values->tid);
 	free(values->counterrawid);
-- 
1.7.6

