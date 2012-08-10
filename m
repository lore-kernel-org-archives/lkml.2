Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab2HJDrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:47:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2HJDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:47:09 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=KowBXteM5tIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IKcmcdY0M_uWaMAZ-3AA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120810034302.758092203@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 23:43:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 0/4] tracing/perf: Use helper functions to help shrink kernel size
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is another effort to bring down the size of trace events.

Helper functions are used to remove duplicate code that is created
for each event by the TRACE_EVENT() macros. With a config that enables
707 events in the core kernel, the size is brought down 91,774 bytes!


Steven Rostedt (4):
      tracing: Move print code from macro to standalone function
      tracing: Move event storage for array from macro to standalone function
      tracing: Use helper functions in event assignment to shrink macro size
      perf/events: Use helper functions in event assignment to shrink macro size

----
 include/linux/ftrace_event.h    |   40 +++++++++++++++--
 include/trace/ftrace.h          |   85 +++++++++---------------------------
 kernel/trace/trace_event_perf.c |   26 +++++++++++
 kernel/trace/trace_events.c     |    6 ---
 kernel/trace/trace_export.c     |   12 ++----
 kernel/trace/trace_output.c     |   90 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 176 insertions(+), 83 deletions(-)
