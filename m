Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0LJSqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:46:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:43857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0LJSqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:46:37 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <alpine.DEB.2.00.1012101236300.13986@router.home>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>
	 <1292001500.3580.268.camel@edumazet-laptop>
	 <1292003346.13513.30.camel@laptop>
	 <1292004859.3580.387.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1012101236300.13986@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 19:46:28 +0100
Message-ID: <1292006788.13513.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 12:39 -0600, Christoph Lameter wrote:
> On Fri, 10 Dec 2010, Eric Dumazet wrote:
> 
> > > Yeah, but that kinda defeats the purpose of having it implemented in
> > > seqlock.h. Ideally we'd teach gcc about these long pointers and have
> > > something like:
> > >
> > >   write_seqcount_begin(&this_cpu_read(irq_time_seq));
> > >
> > > do the right thing.
> >
> > gcc wont be able to do this yet (%fs/%gs selectors)
> 
> The kernel can do that using the __percpu annotation.

That's not true:

# define __percpu

Its a complete NOP.

> > But we can provide this_cpu_write_seqcount_{begin|end}()
> 
> No we cannot do hat. this_cpu ops are for per cpu data and not for locking
> values shared between processors. We have a mechanism for passing per cpu
> pointers with a corresponding annotation.

-enoparse, its not locking anything, is a per-cpu sequence count.


