Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0CPPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:52:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab0CPPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:52:34 -0400
Date: Tue, 16 Mar 2010 16:52:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316155221.GA19699@elte.hu>
References: <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mbpeo1f1y.fsf@fche.csb>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> 
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > [...]
> >> >I.e. we really want to be able users to:
> >> >
> >> >  1) have it all working with a single guest, without having to specify 'which'
> >> >     guest (qemu PID) to work with. That is the dominant usecase both for
> >> >     developers and for a fair portion of testers.
> >> 
> >> That's reasonable if we can get it working simply.
> >
> > IMO such ease of use is reasonable and required, full stop.
> > If it cannot be gotten simply then that's a bug: either in the code, or in the 
> > design, or in the development process that led to the design. Bugs need 
> > fixing. [...]
> 
> Perhaps the fact that kvm happens to deal with an interesting application 
> area (virtualization) is misleading here.  As far as the host kernel or 
> other host userspace is concerned, qemu is just some random unprivileged 
> userspace program (with some *optional* /dev/kvm services that might happen 
> to require temporary root).
> 
> As such, perf trying to instrument qemu is no different than perf trying to 
> instrument any other userspace widget.  Therefore, expecting 'trusted 
> enumeration' of instances is just as sensible as using 'trusted ps' and 
> 'trusted /var/run/FOO.pid files'.

You are quite mistaken: KVM isnt really a 'random unprivileged application' in 
this context, it is clearly an extension of system/kernel services.

( Which can be seen from the simple fact that what started the discussion was 
  'how do we get /proc/kallsyms from the guest'. I.e. an extension of the 
  existing host-space /proc/kallsyms was desired. )

In that sense the most natural 'extension' would be the solution i mentioned a 
week or two ago: to have a (read only) mount of all guest filesystems, plus a 
channel for profiling/tracing data. That would make symbol parsing easier and 
it's what extends the existing 'host space' abstraction in the most natural 
way.

( It doesnt even have to be done via the kernel - Qemu could implement that
  via FUSE for example. )

As a second best option a 'symbol server' might be used too.

Thanks,

	Ingo
