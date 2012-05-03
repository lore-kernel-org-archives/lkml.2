Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2ECRqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:46:49 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59193 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2ECRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:46:47 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] tracing: Fix initial buffer_size_kb state
Date: Thu,  3 May 2012 10:40:34 -0700
Message-Id: <1336066834-1673-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the state of buffer_size_kb is initialized correctly and
returns actual size of the ring buffer.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6d4c2dd..a90386c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5087,7 +5087,8 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] = &per_cpu(max_tr_data, i);
 	}
 
-	set_buffer_entries(&global_trace, ring_buf_size);
+	set_buffer_entries(&global_trace,
+			   ring_buffer_size(global_trace.buffer, 0));
 #ifdef CONFIG_TRACER_MAX_TRACE
 	set_buffer_entries(&max_tr, 1);
 #endif
-- 
1.7.7.3

