Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0FMRLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 13:11:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57898 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0FMRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 13:11:53 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
Date: Sun, 13 Jun 2010 13:11:48 -0400
Message-Id: <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
condition. We know the exact size of nsecs_str, so use it instead of
math that may overflow.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 trace-ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/trace-ftrace.c b/trace-ftrace.c
index af9ac8d..ee7c6dc 100644
--- a/trace-ftrace.c
+++ b/trace-ftrace.c
@@ -148,7 +148,7 @@ static void print_graph_duration(struct trace_seq *s, unsigned long long duratio
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if ((s->len - len) < 7) {
-		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
+		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);
 		trace_seq_printf(s, ".%s", nsecs_str);
 	}
 
-- 
1.7.0.4

