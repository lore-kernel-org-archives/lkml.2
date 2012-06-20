Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab2FTSVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab2FTSVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:41 -0400
Message-Id: <20120620173022.353110255@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 16/61] tracing: Have tracing_off() actually turn tracing off
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit f2bf1f6f5f89d031245067512449fc889b2f4bb2 upstream.

A recent update to have tracing_on/off() only affect the ftrace ring
buffers instead of all ring buffers had a cut and paste error.
The tracing_off() did the exact same thing as tracing_on() and
would not actually turn off tracing. Unfortunately, tracing_off()
is more important to be working than tracing_on() as this is a key
development tool, as it lets the developer turn off tracing as soon
as a problem is discovered. It is also used by panic and oops code.

This bug also breaks the 'echo func:traceoff > set_ftrace_filter'

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -383,7 +383,7 @@ EXPORT_SYMBOL_GPL(tracing_on);
 void tracing_off(void)
 {
 	if (global_trace.buffer)
-		ring_buffer_record_on(global_trace.buffer);
+		ring_buffer_record_off(global_trace.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race


