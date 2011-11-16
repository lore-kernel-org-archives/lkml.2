Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1KPOwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:52:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:39889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1KPOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:52:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf session: Fix crash with invalid CPU list
Date: Wed, 16 Nov 2011 12:51:39 -0200
Message-Id: <1321455099-7110-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1321455099-7110-1-git-send-email-acme@infradead.org>
References: <1321455099-7110-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

commit 5d67be9 added the option to specify a range of CPUs of interest,
but does not catch an invalid CPU list:

$ perf script -c foo
Segmentation fault (core dumped)

Cc: Anton Blanchard <anton@samba.org>
Link: http://lkml.kernel.org/r/1321206327-5881-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..0f4555c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1333,6 +1333,10 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 	}
 
 	map = cpu_map__new(cpu_list);
+	if (map == NULL) {
+		pr_err("Invalid cpu_list\n");
+		return -1;
+	}
 
 	for (i = 0; i < map->nr; i++) {
 		int cpu = map->map[i];
-- 
1.7.8.rc0.35.gee6df

