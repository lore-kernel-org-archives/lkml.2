Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0CVU3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:29:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab0CVU3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:29:53 -0400
Date: Mon, 22 Mar 2010 21:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322202937.GA18126@elte.hu>
References: <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7AF2D.7060306@redhat.com>
 <20100322192033.GC21919@elte.hu>
 <4BA7C885.5010901@redhat.com>
 <20100322200617.GD3306@elte.hu>
 <4BA7CFF4.8080102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7CFF4.8080102@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> > I think you didnt understand my point. I am talking about 'perf kvm top' 
> > hanging if Qemu hangs.
> 
> Use non-blocking I/O, report that guest as dead.  No point in profiling it, 
> it isn't making any progress.

Erm, at what point do i decide that a guest is 'dead' versus 'just lagged due 
to lots of IO' ?

Also, do you realize that you increase complexity (the use of non-blocking 
IO), just to protect against something that wouldnt happen if the right 
solution was used in the first place?

> > With a proper in-kernel enumeration the kernel would always guarantee the 
> > functionality, even if the vcpu does not make progress (i.e. it's "hung").
> >
> > With this implemented in Qemu we lose that kind of robustness guarantee.
> 
> If qemu has a bug in the resource enumeration code, you can't profile one 
> guest.  If the kernel has a bug in the resource enumeration code, the system 
> either panics or needs to be rebooted later.

This is really simple code, not rocket science. If there's a bug in it we'll 
fix it. On the other hand a 500KLOC+ piece of Qemu code has lots of places to 
hang, so that is a large cross section.

	Ingo
