Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0IJI7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:59:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0IJI7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OqAGifQdAKCkLLVw/QCW/cpUhRJZHiP56lbzuw3VeH3GRMqAuwHrTZE+ZgZFfkt7Gx
         xsOe7QsQaw8HeDEnOi2g==
MIME-Version: 1.0
In-Reply-To: <4C89EF37.5080803@kernel.org>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	<1284040322.2589.174.camel@edumazet-laptop>
	<AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
	<1284106566.402.26.camel@laptop>
	<4C89EF37.5080803@kernel.org>
Date: Fri, 10 Sep 2010 10:59:41 +0200
Message-ID: <AANLkTi=7PJPCwrnK+4ejX7RHC-sautVgK-_+kpoT27k5@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:41 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On 09/10/2010 10:16 AM, Peter Zijlstra wrote:
> > On Thu, 2010-09-09 at 23:41 +0200, Stephane Eranian wrote:
> >>> alloc_percpu() is zalloc_percpu() in fact, memory is already cleared.
> >>>
> >> I remember thinking about this and trying to trace to the code down
> >> to figure this out. But it is rather complicated. If alloc_percpu() always
> >> clears the memory, then I think that calling is zalloc_percpu()
> >> would be more helpful....
>
> Maybe but at this point it might be a bit too late.  The allocator has
> been that way since the beginning.
>
Then add a comment in the header or at the definition of the function
to make this more explicit.


> > pcpu_populate_chunk() in mm/percpu-vm.c does indeed do that memset, the
> > one in mm/percpu-km.c does not.
> >
> > It is not obviously clear to me the -km allocator does indeed result in
> > zero filled memory.
>
> Nice catch.  Fortunately, the -km allocator isn't currently being used
> in upstrea although it was enabled for linux-next a couple of days
> ago.  I'll fix it up.
>
> Thank you.
>
> --
> tejun
