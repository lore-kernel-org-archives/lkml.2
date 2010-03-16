Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231Ab0CPNbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:31:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965058Ab0CPNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:31:38 -0400
Date: Tue, 16 Mar 2010 14:31:14 +0100
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
Message-ID: <20100316133114.GB575@elte.hu>
References: <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
 <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F84C0.70706@redhat.com>
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

> On 03/16/2010 03:08 PM, Ingo Molnar wrote:
> >
> >>>I mean, i can trust a kernel service and i can trust /proc/kallsyms.
> >>>
> >>>Can perf trust a random process claiming to be Qemu? What's the trust
> >>>mechanism here?
> >>Obviously you can't trust anything you get from a guest, no matter how you
> >>get it.
> >I'm not talking about the symbol strings and addresses, and the object
> >contents for allocation (or debuginfo). I'm talking about the basic protocol
> >of establishing which guest is which.
> 
> There is none.  So far, qemu only dealt with managing just its own
> guest, and left all multiple guest management to higher levels up
> the stack (like libvirt).
> 
> >I.e. we really want to be able users to:
> >
> >  1) have it all working with a single guest, without having to specify 'which'
> >     guest (qemu PID) to work with. That is the dominant usecase both for
> >     developers and for a fair portion of testers.
> 
> That's reasonable if we can get it working simply.

IMO such ease of use is reasonable and required, full stop.

If it cannot be gotten simply then that's a bug: either in the code, or in the 
design, or in the development process that led to the design. Bugs need 
fixing.

> >  2) Have some reasonable symbolic identification for guests. For example a
> >     usable approach would be to have 'perf kvm list', which would list all
> >     currently active guests:
> >
> >      $ perf kvm list
> >        [1] Fedora
> >        [2] OpenSuse
> >        [3] Windows-XP
> >        [4] Windows-7
> >
> >     And from that point on 'perf kvm -g OpenSuse record' would do the obvious
> >     thing. Users will be able to just use the 'OpenSuse' symbolic name for
> >     that guest, even if the guest got restarted and switched its main PID.
> >
> > Any such facility needs trusted enumeration and a protocol where i can 
> > trust that the information i got is authorative. (I.e. 'OpenSuse' truly 
> > matches to the OpenSuse session - not to some local user starting up a 
> > Qemu instance that claims to be 'OpenSuse'.)
> >
> > Is such a scheme possible/available? I suspect all the KVM configuration 
> > tools (i havent used them in some time - gui and command-line tools alike) 
> > use similar methods to ease guest management?
> 
> You can do that through libvirt, but that only works for guests started 
> through libvirt.  libvirt provides command-line tools to list and manage 
> guests (for example autostarting them on startup), and tools built on top of 
> libvirt can manage guests graphically.
> 
> Looks like we have a layer inversion here.  Maybe we need a plugin system - 
> libvirt drops a .so into perf that teaches it how to list guests and get 
> their symbols.

Is libvirt used to start up all KVM guests? If not, if it's only used on some 
distros while other distros have other solutions then there's apparently no 
good way to get to such information, and the kernel bits of KVM do not provide 
it.

To the user (and to me) this looks like a KVM bug / missing feature. (and the 
user doesnt care where the blame is) If that is true then apparently the 
current KVM design has no technically actionable solution for certain 
categories of features!

	Ingo
