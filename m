Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0C2Gqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:46:46 -0400
Received: from ozlabs.org ([203.10.76.45]:35388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0C2Gqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:46:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] cpuhog: implement and use cpuhog
Date: Mon, 29 Mar 2010 17:16:42 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       sivanich@sgi.com, heiko.carstens@de.ibm.com,
       torvalds@linux-foundation.org, mingo@elte.hu, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
       akpm@linux-foundation.org
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268249155.5279.128.camel@twins> <4B99B15B.8060002@kernel.org>
In-Reply-To: <4B99B15B.8060002@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291716.42504.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 01:43:31 pm Tejun Heo wrote:
> Hello, Peter.
> 
> On 03/11/2010 04:25 AM, Peter Zijlstra wrote:
> > cpuhog as a name doesn't work for me, stop-machine had a name that
> > described its severity and impact, cpuhog makes me think of while(1);.
> >
> > Can't we keep the stop_machine name and make that a workqueue interface
> > like you propose?
> >
> > That way we'd end up with something like:
> > 
> > kernel/stop_machine.c
> >   int stop_cpu(int cpu, stop_fn_t fn, void *arg)
> >   int stop_machine(struct cpumask *mask, stop_fn_t fn, void *arg)
> 
> The distinction would be diabling of IRQ on each CPU.
> hog_[one_]cpu[s]() schedule highest priority task to, well, hog the
> cpu but doesn't affect contextless part of the cpu (irq, bh, whatnot).

I rather like the name.  And the stop_machine name is still there; it's just
using cpuhog rather than workqueues.

Ugly things should have ugly names.

For Patch 2/4 at least:

	Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Great work Tejun!
Rusty.
