Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2GKBG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:06:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55231 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2GKBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:06:56 -0400
MIME-Version: 1.0
Date: Wed, 11 Jul 2012 09:06:55 +0800
Message-ID: <CACV3sbK7jUCDZxGBs3RUYnQ4s+VyEt7VYeRKD50F07zZrYKgCg@mail.gmail.com>
Subject: [PATCH] perf: fix perf-lock report coredump
From: Jovi Zhang <bookjovi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4b363bf16c12b76788fbace1475123b7214ae58d Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 11 Jul 2012 16:53:57 +0800
Subject: [PATCH] perf: fix perf-lock report coredump

Check sample type event raw_data is existed in perf.data firstly,
then invoke process_raw_event, otherwise it will coredump.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 tools/perf/builtin-lock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fd53319..4b0c230 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -860,7 +860,9 @@ static int process_sample_event(struct perf_tool
*tool __used,
 		return -1;
 	}

-	process_raw_event(sample->raw_data, sample->cpu, sample->time, thread);
+	if (sample->raw_data)
+		process_raw_event(sample->raw_data, sample->cpu, sample->time,
+				  thread);

 	return 0;
 }
-- 
1.7.9.7
