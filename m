Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1KMRpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 12:45:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54810 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1KMRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 12:45:34 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net
Cc: anton@samba.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: fix crash with invalid CPU list
Date: Sun, 13 Nov 2011 10:45:27 -0700
Message-Id: <1321206327-5881-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5d67be9 added the option to specify a range of CPUs of interest,
but does not catch an invalid CPU list:

$ perf script -c foo
Segmentation fault (core dumped)

Signed-off-by: David Ahern <dsahern@gmail.com>
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
1.7.7.1

