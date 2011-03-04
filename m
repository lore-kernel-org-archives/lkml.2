Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab1CDVbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:31:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14992 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167Ab1CDVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:31:24 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@openvz.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH rh6] mm: skip zombie in OOM-killer
Date: Sat,  5 Mar 2011 00:30:56 +0300
Message-Id: <1299274256-2122-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A parent may wait a memory and zombie will prevent killing another task.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..2fc554e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -311,7 +311,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
+		if (test_tsk_thread_flag(p, TIF_MEMDIE) && p->mm)
 			return ERR_PTR(-1UL);
 
 		/*
-- 
1.7.1

