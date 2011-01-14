Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1ANXAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:00:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1ANXAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:00:07 -0500
Date: Sat, 15 Jan 2011 07:00:50 +0800
From: Han Pingtian <phan@redhat.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf test: check if cpu_map__new() return NULL
Message-ID: <20110114230050.GA7011@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like we should check if cpus is NULL after

	cpus = cpu_map__new(NULL);

in test__open_syscall_event_on_all_cpus().

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 419ce20..e7f098b 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -348,8 +348,8 @@ static int test__open_syscall_event_on_all_cpus(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
 		return -1;
 	}
 
-- 
1.7.3.4
