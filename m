Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0HVR1C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 13:27:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:37767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0HVR07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 13:26:59 -0400
Date: Sun, 22 Aug 2010 10:25:48 -0700
From: Greg KH <gregkh@suse.de>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
Message-ID: <20100822172548.GB8957@suse.de>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com> <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain> <1282470917.11348.891.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282470917.11348.891.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 10:55:17AM +0100, Ian Campbell wrote:
> On Sun, 2010-08-22 at 08:33 +0100, Ian Campbell wrote:
> > On Sun, 2010-08-22 at 07:57 +0100, Ian Campbell wrote:
> > > On Sat, 2010-08-21 at 08:48 -0700, Linus Torvalds wrote:
> > > > On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> > > > >
> > > > > I don't know that they are particularly good tests for this change but I
> > > > > also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
> > > > > issue. Are there any good mlock heavy workloads?
> > > > 
> > > > mlock itself isn't very interesting, I think more interesting is
> > > > testing that the doubly linked list handles all the cases correctly.
> > > > Something that splits mappings, unmaps partial ones etc etc. Running
> > > > something like Electric Fence is probably a good idea.
> > > 
> > > EF_DISABLE_BANNER=1 EF_ALLOW_MALLOC_0=1 LD_PRELOAD=libefence.so.0.0 make
> > > 
> > > craps out pretty quickly with:
> > > 
> > >           CC      init/main.o
> > >         
> > >         ElectricFence Exiting: mprotect() failed: Cannot allocate memory
> > >         make[1]: *** [init/main.o] Error 255
> > >         make: *** [init] Error 2
> > > 
> > > but it does that with 2.6.35.3, 2.6.35.2, 2.6.35.1 and 2.6.35 too so it
> > > doesn't seem to be breakage relating to any of the stack guard stuff
> > 
> > I increased the vm.max_map_count sysctl and now things are rolling
> > along. Will let you know how I get on.
> 
> So its slow and memory intensive as hell due to efence so my test box is
> struggling[0] but it has compiled 270+ .o files successfully so I think
> it's OK from that perspective. I think it'll be quite a while before I
> can say its passed an allmodconfig under efence though.
> 
> In the meantime I notice you've committed the patches. Can we get them
> queued up for stable backports at some point? I appreciate you might
> want them to bake for a bit longer in 2.6.36-rc first.
> 
> Greg, we are talking about:
> 0e8e50e20c837eeec8323bba7dcd25fe5479194c mm: make stack guard page logic use vm_prev pointer
> 7798330ac8114c731cfab83e634c6ecedaa233d7 mm: make the mlock() stack guard page checks stricter
> 297c5eee372478fc32fec5fe8eed711eedb13f3d mm: make the vma list be doubly linked

I must be missing something, but aren't these patches just "cleanups"
and changing the logic here to be nicer?  Or do they fix real problems
with the previous stack guard stuff?

Is it the second one you really need here?

thanks,

greg k-h
