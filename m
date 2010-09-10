Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0IJQdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:33:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab0IJQdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:33:19 -0400
Date: Fri, 10 Sep 2010 09:31:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Subject: Re: [PATCH percpu#for-next] percpu: clear memory allocated with the
 km allocator
Message-Id: <20100910093115.2f0859af.randy.dunlap@oracle.com>
In-Reply-To: <1284108918.402.31.camel@laptop>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	<1284040322.2589.174.camel@edumazet-laptop>
	<AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
	<1284106566.402.26.camel@laptop>
	<4C89EF37.5080803@kernel.org>
	<4C89F1CE.4050302@gmail.com>
	<1284108918.402.31.camel@laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 10:55:18 +0200 Peter Zijlstra wrote:

> On Fri, 2010-09-10 at 10:52 +0200, Tejun Heo wrote:
> > Percpu allocator should clear memory before returning it but the km
> > allocator forgot to do it.  Fix it.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Spotted-by: Peter Zijlstra <peterz@infradead.org>
> 
> (fwiw, -tip uses Reported-by)

fyi, Documentation/SubmittingPatches does also.


> Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> > ---
> >  mm/percpu-km.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> > index 7037bc7..89633fe 100644
> > --- a/mm/percpu-km.c
> > +++ b/mm/percpu-km.c
> > @@ -35,7 +35,11 @@
> > 
> >  static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
> >  {
> > -	/* noop */
> > +	unsigned int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
> > +
> >  	return 0;
> >  }


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
