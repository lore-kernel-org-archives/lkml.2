Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768111Ab2KOPdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:33:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423639Ab2KOPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:36 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EpaI2TIWF1kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2jZCArAghvoA:10 a=VwQbUJbxAAAA:8 a=4mL_EhcM6hxUukfmDUAA:9 a=lXdXa5Gj6u0A:10 a=T0Q2F5TkVXYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153036.550942394@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8][RFC] ftrace: Optimizing the function tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past I've worked on tricks to make the function tracer a bit
faster. I've lowered the overhead by 18% which is quite an improvement.
Thus, instead of only taking 11x longer in the kernel, it takes 9x ;-)

Anyway, these are the latest patches to improve function tracing and
are pretty much good to go mainline. I just wanted to do one last
RFC post before pushing them forward.

-- Steve


These patches can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/function-preempt-only-v2

Head SHA1: bf9d25e084984439cb32c1fc7cb0f1936c95c51a


Steven Rostedt (8):
      ftrace: Fix global function tracers that are not recursion safe
      ftrace: Fix function tracing recursion self test
      ftrace: Optimize the function tracer list loop
      ftrace: Add context level recursion bit checking
      tracing: Make the trace recursion bits into enums
      tracing: Avoid unnecessary multiple recursion checks
      ftrace: Use only the preempt version of function tracing
      ring-buffer: User context bit recursion checking

----
 kernel/trace/ftrace.c          |   82 ++++++++++++++++---------
 kernel/trace/ring_buffer.c     |   85 +++++++++++++++++--------
 kernel/trace/trace.h           |  133 ++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace_functions.c |   61 +++++-------------
 kernel/trace/trace_selftest.c  |    3 +-
 5 files changed, 248 insertions(+), 116 deletions(-)

