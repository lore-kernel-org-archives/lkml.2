Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab1APJ33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 04:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1APJ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 04:29:27 -0500
Date: Sun, 16 Jan 2011 17:30:02 +0800
From: Han Pingtian <phan@redhat.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf test: free cpus at the end of
 test__open_syscall_event_on_all_cpus()
Message-ID: <20110116093002.GA5038@localhost.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call free() on cpu_map pointer cpus to clean up malloced memories
at the end of test__open_syscall_event_on_all_cpus().

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/builtin-test.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e7f098b..ae1e9a4 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -422,6 +422,7 @@ out_evsel_delete:
 	perf_evsel__delete(evsel);
 out_cpu_free:
 	CPU_FREE(cpu_set);
+	free(cpus);
 out_thread_map_delete:
 	thread_map__delete(threads);
 	return err;
-- 
1.7.3.4
