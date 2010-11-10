Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0KJQGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:06:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab0KJQGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:06:08 -0500
Date: Wed, 10 Nov 2010 11:05:16 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101110160516.GZ4823@redhat.com>
References: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
 <20101110074941.GD29493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110074941.GD29493@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:49:41AM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > I ran into a scenario where while one cpu was stuck and should have panic'd 
> > because of the NMI watchdog, it didn't.  The reason was another cpu was spewing 
> > stack dumps on to the console.  Upon investigation, I noticed that when writing to 
> > the console and also when dumping the stack, the watchdog is touched.
> > 
> > This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu 
> > just spins forever.
> 
> Hm, the flip side is that if a CPU is stuck spewing backtraces, we will now make all 
> the other CPUs a lot more noisy - which might only 'lock up' because this CPU is 
> stuck spewing oopses, right?

When you say the other CPUs will be a lot more noisy, is that because they
are busy processing backtraces for the first cpu to spew?  I guess I don't
understand how the other CPUs could have their interrupts off the whole
time while the first cpu is spewing a backtrace (just trying to educate
myself).

Cheers,
Don
