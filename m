Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0FULIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:08:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:36109 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab0FULIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:08:21 -0400
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] tracing: Fix undelared ENOSYS in include/linux/tracepoint.h
Date: Mon, 21 Jun 2010 19:09:09 +0800
Message-Id: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 21 Jun 2010 11:07:59.0105 (UTC) FILETIME=[02135710:01CB1132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

The header file include/linux/tracepoint.h may be included without
include/linux/errno.h and then the compiler will fail on building for
undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
to include/linux/tracepoint.h.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 include/linux/tracepoint.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9a59d1f..103d1b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -14,6 +14,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 
-- 
1.6.3.3

