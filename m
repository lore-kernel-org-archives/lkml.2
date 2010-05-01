Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0EALzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 07:55:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:45672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0EALzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 07:55:37 -0400
Date: Sat, 1 May 2010 11:54:41 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, paulus@au1.ibm.com,
       stable@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, peterz@infradead.org,
       tj@kernel.org, tglx@linutronix.de, paulus@au1.ibm.com, mingo@elte.hu
In-Reply-To: <4BDBE237.1040809@kernel.org>
References: <4BDBE237.1040809@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix resource leak in failure path of perf_event_open()
Message-ID: <tip-048c852051d2bd5da54a4488bc1f16b0fc74c695@git.kernel.org>
Git-Commit-ID: 048c852051d2bd5da54a4488bc1f16b0fc74c695
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 01 May 2010 11:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  048c852051d2bd5da54a4488bc1f16b0fc74c695
Gitweb:     http://git.kernel.org/tip/048c852051d2bd5da54a4488bc1f16b0fc74c695
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sat, 1 May 2010 10:11:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 1 May 2010 13:11:25 +0200

perf: Fix resource leak in failure path of perf_event_open()

perf_event_open() kfrees event after init failure which doesn't
release all resources allocated by perf_event_alloc().  Use
free_event() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <4BDBE237.1040809@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2f3fbf8..3d1552d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4897,7 +4897,7 @@ err_fput_free_put_context:
 
 err_free_put_context:
 	if (err < 0)
-		kfree(event);
+		free_event(event);
 
 err_put_context:
 	if (err < 0)
