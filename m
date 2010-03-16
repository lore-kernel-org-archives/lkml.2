Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937865Ab0CPMaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:30:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937852Ab0CPMaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:30:01 -0400
Date: Tue, 16 Mar 2010 13:29:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316122903.GA8831@elte.hu>
References: <20100316072449.GB11881@elte.hu>
 <4B9F4D74.4090403@redhat.com>
 <20100316095336.GI7961@elte.hu>
 <4B9F59DE.1060008@redhat.com>
 <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
 <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F77E7.2060101@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/16/2010 01:25 PM, Ingo Molnar wrote:
> >
> >>I haven't followed vmchannel closely, but I think it is.  vmchannel is
> >>terminated in qemu on the host side, not in the host kernel.  So perf would
> >>need to connect to qemu.
> >Hm, that sounds rather messy if we want to use it to basically expose kernel
> >functionality in a guest/host unified way. Is the qemu process discoverable in
> >some secure way?
> 
> We know its pid.

How do i get a list of all 'guest instance PIDs', and what is the way to talk 
to Qemu?

> > Can we trust it?
> 
> No choice, it contains the guest address space.

I mean, i can trust a kernel service and i can trust /proc/kallsyms.

Can perf trust a random process claiming to be Qemu? What's the trust 
mechanism here?

> > Is there some proper tooling available to do it, or do we have to push it 
> > through 2-3 packages to get such a useful feature done?
> 
> libvirt manages qemu processes, but I don't think this should go through 
> libvirt.  qemu can do this directly by opening a unix domain socket in a 
> well-known place.

So Qemu has never run into such problems before?

( Sounds weird - i think Qemu configuration itself should be done via a 
  unix domain socket driven configuration protocol as well. )

> >( That is the general thought process how many cross-discipline useful
> >   desktop/server features hit the bit bucket before having had any chance of
> >   being vetted by users, and why Linux sucks so much when it comes to feature
> >   integration and application usability. )
> 
> You can't solve everything in the kernel, even with a well populated tools/.

Certainly not, but this is a technical problem in the kernel's domain, so it's 
a fair (and natural) expectation to be able to solve this within the kernel 
project.

	Ingo
