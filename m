Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab0EGSkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:40:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:59598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757Ab0EGSkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:40:33 -0400
Date: Fri, 7 May 2010 18:40:24 GMT
From: tip-bot for Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tfransosi@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tfransosi@gmail.com, tglx@linutronix.de
In-Reply-To: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix "integer as NULL pointer" warning.
Message-ID: <tip-668eb65f092902eb7dd526af73d4a7f025a94612@git.kernel.org>
Git-Commit-ID: 668eb65f092902eb7dd526af73d4a7f025a94612
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:40:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  668eb65f092902eb7dd526af73d4a7f025a94612
Gitweb:     http://git.kernel.org/tip/668eb65f092902eb7dd526af73d4a7f025a94612
Author:     Thiago Farina <tfransosi@gmail.com>
AuthorDate: Sun, 24 Jan 2010 11:03:50 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 5 May 2010 12:01:26 -0400

tracing: Fix "integer as NULL pointer" warning.

kernel/trace/trace_output.c:256:24: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
LKML-Reference: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..2404c12 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 	void *ret;
 
 	if (s->full)
-		return 0;
+		return NULL;
 
 	if (len > ((PAGE_SIZE - 1) - s->len)) {
 		s->full = 1;
