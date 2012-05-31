Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2EaSpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:45:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab2EaSpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:45:18 -0400
Message-ID: <4FC7BC1D.8030002@zytor.com>
Date: Thu, 31 May 2012 11:44:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
References: <20120531012829.160060586@goodmis.org> <20120531020441.500105258@goodmis.org>
In-Reply-To: <20120531020441.500105258@goodmis.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 06:28 PM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When the NMI handler runs, it checks if it preempted a debug
> handler and if that handler is using the debug stack. If it is, it
> changes the IDT table not to update the stack, otherwise it will
> reset the debug stack and corrupt the debug handler it preempted.
> 
> Now that ftrace uses breakpoints to change functions from nops to 
> callers, many more places may hit a breakpoint. Unfortunately this 
> includes some of the calls that lockdep performs. Which causes
> issues with the debug stack. It too needs to change the debug stack
> before tracing (if called from the debug handler).
> 
> Allow the debug_stack_set_zero() and debug_stack_reset() to be
> nested so that the debug handlers can take advantage of them too.
> 

NAK on this in its current form.  A few minutes to let me write up a
technical review.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

