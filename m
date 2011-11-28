Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1K1JFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:05:20 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28286 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1K1JFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:05:12 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: [PATCH 1/7] perf: use event_name() to get an event name
Date: Mon, 28 Nov 2011 12:03:29 +0300
Message-Id: <1322471015-107825-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1322471015-107825-1-git-send-email-avagin@openvz.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_evsel.name may be not initialized

Signed-off-by: Andrew Vagin <avagin@openvz.org>
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
1.7.1

