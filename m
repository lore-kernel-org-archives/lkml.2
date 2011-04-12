Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1DLOve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:51:34 -0400
Received: from kroah.org ([198.145.64.141]:57598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab1DLOiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:53 2011
Message-Id: <20110412143553.086578038@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Olsa <jolsa@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [048/105] perf: Fix task_struct reference leak
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit fd1edb3aa2c1d92618d8f0c6d15d44ea41fcac6a upstream.

sys_perf_event_open() had an imbalance in the number of task refs it
took causing memory leakage

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5917,6 +5917,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if (task) {
+		put_task_struct(task);
+		task = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */


