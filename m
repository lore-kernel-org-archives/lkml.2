Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0K3UxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:53:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43787 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0K3UxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AiZ1Nz5vY39H0+EPevb6YHRd3rMsQz9HByhsXgJyHccVbZX6m9Z6VQxCnOQ6o1DAEJ
         vSV1sN3mZwdLo2sHrP+3IAI2zfTVxF2gP31Ai3Wj1PETnO3RPM5L+FapzseTl2QvM4qt
         CKagj+wGJo8z4pqL7k9GKhhzViRVp5lwbIcTs=
Date: Tue, 30 Nov 2010 23:52:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#2 04/16] x86: Use local variable to cache
	smp_processor_id() in setup_local_APIC()
Message-ID: <20101130205257.GD20818@lenovo>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4CF53E61.1030307@kernel.org> <20101130182251.GC20818@lenovo> <4CF553A3.8030000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF553A3.8030000@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 08:42:27PM +0100, Tejun Heo wrote:
...
> Not really.  smp_processor_id() outside of preemption/irq disabled
> area is suspicious exactly the same and having @cpu initialized at the
> head of the function has the advantage of making it clear that the
> function as a whole is special w.r.t. which cpu it runs on.  In fact,
> I think it's actually worse to put it inside preemption disabled area
> as it gives the wrong impression that the function isn't special and

well, i take the opposite, if function is not ever supposed to be called
outside of cpu it runs on there should not be references even in local
variables outside of preempt scope (even if we know that it is safe
to cache 'cpu' early), but I think this is a question of habbit :)

> might be able to handle being called from another cpu.  In fact,
> caching smp_processor_id() in @cpu is better than calling it every
> time as it makes it clear that the function is bound to that cpu.
> 
> That said, I really don't think this matters one way or the other.
> This function is called during smp bring up to initialize the CPU.
> Things don't get much more arch/cpu dependent than this and the code
> is thoroughly tested on each and every boot and power management
> operations.  How @cpu is cached and used just doesn't matter, which is
> why I didn't really care about it and changed as suggested.  So, let's
> just let it go.

*sure*, as one Ingo merge it we would be able to clean it a bit on top

[ in particular I believe we should preempt disable at the very beginning
  on the function and use cached cpu then until the preemption gets on
  at the end, and we would cover cmci_recheck with cached cpu as well.
  this would eliminate all the questions I believe ]

> 
> Thanks.
> 
> -- 
> tejun
> 
  Cyrill
