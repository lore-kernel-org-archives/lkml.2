Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1F0Kpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:45:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab1F0KoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:44:22 -0400
Subject: Re: perf: is PERF_COUNT_SW_CONTEXT_SWITCHES a kernel or user event?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1106241658420.23095@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106241658420.23095@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 12:43:23 +0200
Message-ID: <1309171403.6701.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 17:03 -0400, Vince Weaver wrote:
> Hello
> 
> the commit included in 2.6.34:
>   perf: Use hot regs with software sched switch/migrate events
>   e49a5bd38159dfb1928fd25b173bc9de4bbadb21
> 
> Changes the behavior of the PERF_COUNT_SW_CONTEXT_SWITCHES
> counter.
> 
> Before 2.6.34 all of the PERF_COUNT_SW_CONTEXT_SWITCHES events were 
> counted as happening in userspace (they show up in "perf stat -e cs:u") 
> but after the commit they always happen in kernelspace ("perf stat -e 
> cs:k").
> 
> Was this intended behavior?
> I'm writing a validation test for this and want to make sure I get it
> right.
> 
> This can be confusing if your tool defaults to userspace only counts (PAPI 
> does this).

hurm, difficult case, like the changelog explains the previous behaviour
wasn't ideal either. Seems like we want somewhat of a middle ground
there, but I'm not quite sure how to make that happen.

Let me ponder things for a bit.
