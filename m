Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2EBVC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:02:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab2EBVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:02:55 -0400
Date: Wed, 2 May 2012 14:02:20 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-5a26c8f0cf1e95106858bb4e23ca6dd14c9b842f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, eduard.munteanu@linux360.ro,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, eduard.munteanu@linux360.ro,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120420063145.GA22649@elgon.mountain>
References: <20120420063145.GA22649@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Remove an unneeded check in trace_seq_buffer()
Git-Commit-ID: 5a26c8f0cf1e95106858bb4e23ca6dd14c9b842f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 02 May 2012 14:02:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a26c8f0cf1e95106858bb4e23ca6dd14c9b842f
Gitweb:     http://git.kernel.org/tip/5a26c8f0cf1e95106858bb4e23ca6dd14c9b842f
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Fri, 20 Apr 2012 09:31:45 +0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 23 Apr 2012 21:16:10 -0400

tracing: Remove an unneeded check in trace_seq_buffer()

memcpy() returns a pointer to "bug".  Hopefully, it's not NULL here or
we would already have Oopsed.

Link: http://lkml.kernel.org/r/20120420063145.GA22649@elgon.mountain

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1ab8e35..bbcde54 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -629,7 +629,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
-	void *ret;
 
 	if (s->len <= s->readpos)
 		return -EBUSY;
@@ -637,9 +636,7 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	len = s->len - s->readpos;
 	if (cnt > len)
 		cnt = len;
-	ret = memcpy(buf, s->buffer + s->readpos, cnt);
-	if (!ret)
-		return -EFAULT;
+	memcpy(buf, s->buffer + s->readpos, cnt);
 
 	s->readpos += cnt;
 	return cnt;
