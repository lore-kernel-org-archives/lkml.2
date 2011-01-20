Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1ATAnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:43:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab1ATAnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:43:17 -0500
Date: Wed, 19 Jan 2011 16:41:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Milton Miller <miltonm@bga.com>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <peterz@infradead.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] smp_call_function_many SMP race
Message-Id: <20110119164159.2ff499c8.akpm@linux-foundation.org>
In-Reply-To: <smp-call-function-simplified@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	<1295288253.30950.280.camel@laptop>
	<smp-call-function-peter-reply@mdm.bga.com>
	<smp-call-function-simplified@mdm.bga.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 15:07:25 -0600
Milton Miller <miltonm@bga.com> wrote:

> I noticed a failure where we hit the following WARN_ON in
> generic_smp_call_function_interrupt:
> 
>                 if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
>                         continue;
> 
>                 data->csd.func(data->csd.info);
> 
>                 refs = atomic_dec_return(&data->refs);
>                 WARN_ON(refs < 0);      <-------------------------
> 
> We atomically tested and cleared our bit in the cpumask, and yet the
> number of cpus left (ie refs) was 0. How can this be?
> 
> It turns out commit 54fdade1c3332391948ec43530c02c4794a38172
> (generic-ipi: make struct call_function_data lockless)
> is at fault. It removes locking from smp_call_function_many and in
> doing so creates a rather complicated race.

I've been waving https://bugzilla.kernel.org/show_bug.cgi?id=23042 at
the x86 guys for a while now, to no avail.  Do you think you just fixed
it?

