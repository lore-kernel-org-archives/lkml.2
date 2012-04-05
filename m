Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2DETTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:19:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:58209 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab2DETTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:19:33 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <mark.asselstine@windriver.com>
Subject: [PATCH 2/3] trace-cmd: don't call stop_threads() if doing latency tracing
Date: Thu, 5 Apr 2012 15:19:45 -0400
Message-ID: <1333653586-3379-3-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
References: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are using a latency tracer we do not call start_threads() we
should therefore not call stop_threads() if 'latency'. Attempting
to call stop_threads() without first calling start_threads() will
cause a segfault since pids will be uninitialized.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
 trace-record.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index fcec28b..1c56fa9 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2216,7 +2216,8 @@ void trace_record (int argc, char **argv)
 		}
 
 		disable_tracing();
-		stop_threads();
+		if (!latency)
+			stop_threads();
 	}
 
 	for (cpu = 0; cpu < cpu_count; cpu++) {
-- 
1.7.5.4

