Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0KHShJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:37:09 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:48904 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0KHShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:37:07 -0500
Date: Mon, 8 Nov 2010 13:37:01 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101108183701.GA20262@sundance.ccs.neu.edu>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
 <4CD5DCE3.3000109@cs.columbia.edu>
 <20101107194222.GG31077@sundance.ccs.neu.edu>
 <4CD71A6B.3020905@cs.columbia.edu>
 <20101107230516.GJ31077@sundance.ccs.neu.edu>
 <4CD774CA.8030004@cs.columbia.edu>
 <20101108162630.GN31077@sundance.ccs.neu.edu>
 <4CD83DF4.4080009@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD83DF4.4080009@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the careful response, Oren.  For others who read this,
one could interpret Oren's rapid post as criticizing the work of
Andres Lagar Cavilla.  I'm sure that this was not Oren's intention.
Please read below for a brief clarification of the novelty of SnowFlock.
    Anyway, I really look forward to the phone discussion.  I've also
enjoyed our interchange, for giving me an opportunity to explain more about
the DMTCP design.  Thank you.
                                                        Best wishes,
                                                        - Gene

On Mon, Nov 08, 2010 at 01:14:12PM -0500, Oren Laadan wrote:
> Hi,
> 
> Ok, I'll bite the bullet for now - to be continued...
> 
> Just one important clarification:
> 
> >>Linux-cr can do live migration - e.g. VDI, move the desktop - in
> >>which case skype's sockets' network stacks are reconstructed,
> >>transparently to both skype (local apps) and the peer (remote apps).
> >>Then, at the destination host and skype continues to work.
> >
> >That's a really cool thing to do, and it's definitely not part of what
> >DMTCP does.  It might be possible to do userland live migration,
> >but it's definitely not part of our current scope.  But if we're talking
> >about live migration, have you also looked at the work of
> >Andres Lagar Caviilla on SnowFlock?
> >     http://andres.lagarcavilla.com/publications/LagarCavillaEurosys09.pdf
> >He does live migration of entire virtual machines, again with very
> >small delay.  Of course, the issue for any type of live migration is that
> >if the rate of dirtying pages is very high (e.g. HPC), then there is
> >still a delay or slow response, due to page faults to a remote host.
> 
> VMware, Xen and KVM already do live migration. However, VMs
> are a separate beast.

I absolutely agree with your point that live migration of
applications is a different beast, and technically very novel.
    Since I know Andres Lagar Cavilla personally, I also feel obligated
to comment why SnowFlock truly is novel in the VM space.  First, as Andres
writes:
"SnowFlock is an open-source project [SnowFlock] built on the Xen 3.0.3
VMM [Barham 2003]."
In the abstract, Andres points out one of the major points of novelty:
"To evaluate SnowFlock, we focus on the demanding
scenario of services requiring on-the-fly creation of hundreds
of parallel workers in order to solve computationallyintensive
queries in seconds."
We must be careful that we don't destroy someone's reputation without
a careful study of their work.

> We are concerned about _application_ level c/r and migration
> (complete containers or individual applications). Many proven
> techniques from the VM world apply to our context too (in your
> example, post-copy migration).
> 
> Oren.
