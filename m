Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1GCNUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab1GCNUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:20:43 -0400
Message-ID: <4E106C9B.6020403@redhat.com>
Date: Sun, 03 Jul 2011 16:20:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>, Jeff Law <law@redhat.com>
Subject: Re: [PATCH v4 8/9] KVM-GST: adjust scheduler cpu power
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>	 <1309555369-16867-9-git-send-email-glommer@redhat.com> <1309602291.10073.22.camel@twins>
In-Reply-To: <1309602291.10073.22.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2011 01:24 PM, Peter Zijlstra wrote:
> static void update_rq_clock_task(struct rq *rq, s64 delta)
> {
> 	s64 irq_delta = 0, steal = 0;
>
> 	rq->clock_task += delta;
>
> 	if ((irq_delta + steal)&&  sched_feat(NONTASK_POWER))
> 		sched_rt_avg_update(rq, irq_delta + steal);
> }
>
> And we want it to emit the equivalent of:
>
> static void update_rq_clock_task(struct rq *rq, s64 delta)
> {
> 	rq->clock_task += delta;
> }
>
> Now Glauber is properly paranoid and doesn't trust his compiler (this is
> very hot code in the kernel so any extra code emitted here is sad) and
> chose the heavy handed CPP solution.
>
> Now without checking a all relevant gcc versions on all relevant
> architectures (see you in a few weeks etc..) can we actually rely on gcc
> doing such relatively simple things correct, or should we stick with CPP
> just to make sure?

I'm pretty sure any relevant version of gcc will do the right optimizations.

-- 
error compiling committee.c: too many arguments to function

