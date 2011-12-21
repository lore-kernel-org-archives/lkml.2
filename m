Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1LUIpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:45:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1LUIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:45:44 -0500
Date: Wed, 21 Dec 2011 00:45:22 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-0161d82e9b740caa90f508138d1ae1b9d981b6d3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-5-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-5-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix a memory leak on perf_read_values_destroy
Git-Commit-ID: 0161d82e9b740caa90f508138d1ae1b9d981b6d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:45:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0161d82e9b740caa90f508138d1ae1b9d981b6d3
Gitweb:     http://git.kernel.org/tip/0161d82e9b740caa90f508138d1ae1b9d981b6d3
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:41:34 -0200

perf tools: Fix a memory leak on perf_read_values_destroy

After freeing each elements of the @values->value, we should free itself
too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-5-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/values.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index bdd3347..697c8b4 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -32,6 +32,7 @@ void perf_read_values_destroy(struct perf_read_values *values)
 
 	for (i = 0; i < values->threads; i++)
 		free(values->value[i]);
+	free(values->value);
 	free(values->pid);
 	free(values->tid);
 	free(values->counterrawid);
