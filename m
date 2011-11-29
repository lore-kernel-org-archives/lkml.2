Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1K2TRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:17:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1K2TR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:17:29 -0500
Message-Id: <20111129191638.756761754@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Nov 2011 23:12:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members to /proc/$pid/stat
References: <20111129191252.769160532@openvz.org>
Content-Disposition: inline; filename=fs-proc-Add-start_data-end_data-start_brk-members
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps to dump and restore this mm_struct members.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/array.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime));
+		cputime_to_clock_t(cgtime),
+		mm ? (permitted ? mm->start_data : 1) : 0,
+		mm ? (permitted ? mm->end_data : 1) : 0,
+		mm ? (permitted ? mm->start_brk : 1) : 0);
 	if (mm)
 		mmput(mm);
 	return 0;

