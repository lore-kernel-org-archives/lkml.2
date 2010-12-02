Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab0LBW6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:58:52 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13950 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0LBW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:58:50 -0500
Message-ID: <4CF824A8.2070807@caviumnetworks.com>
Date: Thu, 02 Dec 2010 14:58:48 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC][PATCH 1/2] [PATCH 1/2] tracing: Add TRACE_EVENT_CONDITIONAL()
References: <20101202223654.596106888@goodmis.org> <20101202224814.667536793@goodmis.org>
In-Reply-To: <20101202224814.667536793@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2010 22:59:52.0705 (UTC) FILETIME=[A11C7710:01CB9274]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 02:36 PM, Steven Rostedt wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> There are instances in the kernel that we only want to trace
> a tracepoint when a certain condition is set. But we do not
> want to test for that condition in the core kernel.
> If we test for that condition before calling the tracepoin, then
> we will be performing that test even when tracing is not enabled.
> This is 99.99% of the time.
>
> We currently can just filter out on that condition, but that happens
> after we write to the trace buffer. We just wasted time writing to
> the ring buffer for an event we never cared about.
>
> This patch adds:
>
>     TRACE_EVENT_CONDITION() and DECLARE_TRACE_CLASS_CONDITION()
>
> These have a new TP_CONDITION() argument that comes right after
> the TP_ARGS().  This condition can use the parameters of the
> TRACE_EVENT() to determine if the tracepoint should be traced
> or not. The TP_CONDITION() will be placed in a if (cond) trace;
>
> For example, for the tracepoint sched_wakeup, it is useless to
> trace an wakeup event where the caller never actually work
> anything up (success = 0). So adding:
                       ^^^
                    s/=/==/

As much as I hate to be a pedant, I would suggest changing this change 
log for the sake of clarity.

David Daney
