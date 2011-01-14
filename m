Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab1ANHQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:16:09 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54783 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab1ANHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:16:04 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] fs/eventpoll.c: fix compilation warning
Date: Fri, 14 Jan 2011 12:45:52 +0530
Message-ID: <1294989352-2003-1-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compilation warning
fs/eventpoll.c:1119: warning: 'slack' may be used uninitialized in this function

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8cf0724..c24a032 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 {
 	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack;
+	long slack = 0;
 	wait_queue_t wait;
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
-- 
1.7.2.2

