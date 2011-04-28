Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1D1EDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:03:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52992 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1D1EDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:03:42 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 2/3] comm: timerstats: Protect task->comm access by using get_task_comm()
Date: Wed, 27 Apr 2011 21:03:30 -0700
Message-Id: <1303963411-2064-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1303963411-2064-1-git-send-email-john.stultz@linaro.org>
References: <1303963411-2064-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converts the timerstats code to use get_task_comm for protected
comm access.

CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..85308fb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -379,7 +379,7 @@ void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
 		return;
 
 	timer->start_site = addr;
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	get_task_comm(timer->start_comm, current);
 	timer->start_pid = current->pid;
 }
 
-- 
1.7.3.2.146.gca209

