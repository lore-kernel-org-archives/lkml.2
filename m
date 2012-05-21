Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2EUJqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab2EUJqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:46:03 -0400
Date: Mon, 21 May 2012 02:45:43 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-a591c73f127505cdbd0aa399a92112a8ddff8730@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, vnagarnaik@google.com,
        hpa@zytor.com, mingo@kernel.org, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
In-Reply-To: <1336066834-1673-1-git-send-email-vnagarnaik@google.com>
References: <1336066834-1673-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix initial buffer_size_kb state
Git-Commit-ID: a591c73f127505cdbd0aa399a92112a8ddff8730
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:45:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a591c73f127505cdbd0aa399a92112a8ddff8730
Gitweb:     http://git.kernel.org/tip/a591c73f127505cdbd0aa399a92112a8ddff8730
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Thu, 3 May 2012 10:40:34 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 19 May 2012 08:28:50 -0400

tracing: Fix initial buffer_size_kb state

Make sure that the state of buffer_size_kb is initialized correctly and
returns actual size of the ring buffer.

Link: http://lkml.kernel.org/r/1336066834-1673-1-git-send-email-vnagarnaik@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08a08ba..a44d4c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5112,7 +5112,8 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] = &per_cpu(max_tr_data, i);
 	}
 
-	set_buffer_entries(&global_trace, ring_buf_size);
+	set_buffer_entries(&global_trace,
+			   ring_buffer_size(global_trace.buffer, 0));
 #ifdef CONFIG_TRACER_MAX_TRACE
 	set_buffer_entries(&max_tr, 1);
 #endif
