Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab0EDRXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:23:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:43784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760084Ab0EDRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:23:42 -0400
Message-ID: <4BE057EB.80604@kernel.org>
Date: Tue, 04 May 2010 19:22:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272976724-14312-5-git-send-email-tj@kernel.org> <1272993090.1642.184.camel@laptop>
In-Reply-To: <1272993090.1642.184.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 17:22:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/04/2010 07:11 PM, Peter Zijlstra wrote:
> On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
>> Add @rq to perf_event_task_sched_out() so that its argument matches
>> those of trace_sched_switch().  This will help unifying notifiers in
>> sched.
> 
> The alternative is dropping rq from the trace events, its not like
> anybody outside sched.o can do anything sensible with it anyway.

The comment in include/trace/events/sched.h says...

 * (NOTE: the 'rq' argument is not used by generic trace events,
 *        but used by the latency tracer plugin. )

So, I left it there.  It would be great if all those @rq params can be
removed tho.  The latency tracer thing needs it, right?

Thanks.

-- 
tejun
