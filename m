Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1GNJZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:25:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1GNJZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:25:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf tools: Make test use the preset debugfs path
Date: Thu, 14 Jul 2011 11:25:34 +0200
Message-Id: <1310635534-4013-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310635534-4013-1-git-send-email-jolsa@redhat.com>
References: <1310635534-4013-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use preset debugfs path instead of hardcoded one.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index b5cd5f5..55f4c76 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -246,8 +246,8 @@ static int trace_event__id(const char *evname)
 	int err = -1, fd;
 
 	if (asprintf(&filename,
-		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
-		     evname) < 0)
+		     "%s/syscalls/%s/id",
+		     debugfs_path, evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
-- 
1.7.4

