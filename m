Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0DEPRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:17:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0DEPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:17:26 -0400
X-Authority-Analysis: v=1.1 cv=HGzZEZllc7l+rGriDeLGo6RTzaxOKII9nWt1C4P+aSw= c=1 sm=0 a=lCZnNc42cWUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=n7_h5HR9FGrHuRqvOMQA:9 a=6qL_nnPzzWdbb8ONdtHFalsQn0cA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Fix uninitialized variable of
 tracing/trace output
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 05 Apr 2010 11:17:24 -0400
Message-ID: <1270480644.19685.14822.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Lai Jiangshan (1):
      tracing: Fix uninitialized variable of tracing/trace output

----
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit aa27497c2fb4c7f57706099bd489e683e5cc3e3b
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Mon Apr 5 17:11:05 2010 +0800

    tracing: Fix uninitialized variable of tracing/trace output
    
    Because a local variable is not initialized, I got these
    when I did 'cat tracing/trace'. (not trace_pipe):
    
    CPU:0 [LOST 18446744071579453134 EVENTS]
                  ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
    CPU:0 [LOST 18446744071579453134 EVENTS]
                  ps-3099  [000]   560.770221: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
    CPU:0 [LOST 18446612133255294080 EVENTS]
                  ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
    CPU:0 [LOST 18446744071579453134 EVENTS]
                  ps-3099  [000]   560.770222: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
    CPU:0 [LOST 18446744071579453134 EVENTS]
                  ps-3099  [000]   560.770222: lock_release: ffffffff816cfb98 dcache_lock
    
    See peek_next_entry(), it does not set *lost_events when we 'cat tracing/trace'
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    LKML-Reference: <4BB9A929.2000303@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0498beb..b9be232 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1571,7 +1571,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
-	unsigned long lost_events, next_lost = 0;
+	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;


