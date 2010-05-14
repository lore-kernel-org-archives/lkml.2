Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0ENFnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:43:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52372 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab0ENFnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:43:45 -0400
Date: Fri, 14 May 2010 11:13:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100514054336.GX3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <eJktY-7JG-7@gated-at.bofh.it>
 <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <1273785546.5605.3556.camel@twins>
 <20100514000252.GB30093@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100514000252.GB30093@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Poettering <mzxreary@0pointer.de> [2010-05-14 02:02:52]:

> On Thu, 13.05.10 23:19, Peter Zijlstra (peterz@infradead.org) wrote:
> 
> > 
> > On Thu, 2010-05-13 at 16:03 +0200, Lennart Poettering wrote:
> > > > On Wed, 2010-05-12 at 21:07 +0200, Lennart Poettering wrote:
> > > > > See Dhaval's patch on the background of systemd
> > > > > (http://0pointer.de/blog/projects/systemd.html). When a service is
> > > > > started in systemd, we create a cgroup for it, when it ends, we remove
> > > > > it. 
> > > > 
> > > > I seriously hope that's optional, because I for one would really hate a
> > > > system that does that. I still mostly build kernels with only cpuset in
> > > > and really don't want anybody but me creating groups in there.
> > > 
> > > By default systemd will create its groups in the "debug" hierarchy, (at
> > > least for now, in the long run i'd like to see "noop" hierarchy or so,
> > > that doesn't sound so temporary), since that controller is not useful
> > > for anything but keeping track of processes. So it shouldn't bother you
> > > at all. 
> > 
> > Will it still work with a CONFIG_CGROUP=n kernel? I see distributions
> > deteriorate, you cannot even boot a raw bzImage kernel without initrd on
> > most distros (sure, its not too hard to fix, but still).
> 
> No it won't work without cgroups.
> 
> > Also, I get all kinds of dumb-ass init-script failures for not having
> > modules but stuff built-in. A prime example is NFS failing on start on
> > both fedora and ubuntu with a built-in nfs server (for different but
> > both retarded reasons).
> > 
> > Requiring CONFIG_CGROUP=y to even get init running seems like a final
> > straw to ensure nobody will ever get anything to boot these days.
> 
> Well, I wasn't aware that cgroups is now in the kernel for the purpose
> that people should *not* use it.
> 
> Next time something is added to the kernel please mark it as "Hey,
> please don't use it, this is only here so that you don't use
> it. Thanks!" Maybe then dumb-ass folks like me will notice and refrain
> from using it.
> 
> Requiring a single kernel options is not really too much to ask, is it?
> Don't be that conservative. systemd certainly won't require an initrd
> or anything else equally intrusive btw.
>

I think the config options are the domains of the distributors and if
the code is there and works, most distros will enable it. As long as
they have a feature that uses that option or a need for it.

I am not sure why CONFIG_CGROUP=y is so bad, Peter, could you
elaborate?

-- 
	Three Cheers,
	Balbir
