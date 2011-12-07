Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1LGPrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:47:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1LGPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:47:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>,
        devel@openvz.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf header: Use event_name() to get an event name
Date: Wed,  7 Dec 2011 13:47:29 -0200
Message-Id: <1323272849-15077-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1323272849-15077-1-git-send-email-acme@infradead.org>
References: <1323272849-15077-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

perf_evsel.name may be not initialized

Cc: David Ahern <dsahern@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>
Cc: devel@openvz.org
Link: http://lkml.kernel.org/r/1322471015-107825-2-git-send-email-avagin@openvz.org
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..33c17a2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -388,7 +388,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, attr->name);
+		ret = do_write_string(fd, event_name(attr));
 		if (ret < 0)
 			return ret;
 		/*
-- 
1.7.8.rc0.35.gee6df

