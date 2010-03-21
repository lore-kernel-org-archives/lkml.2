Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0CUSnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:43:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0CUSnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:43:09 -0400
Date: Sun, 21 Mar 2010 19:43:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: oerg Roedel <joro@8bytes.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100321184300.GB25922@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <1268969929.2813.184.camel@localhost>
 <20100319082122.GE12576@elte.hu>
 <20100319172903.GI13108@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319172903.GI13108@8bytes.org>
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


* oerg Roedel <joro@8bytes.org> wrote:

> On Fri, Mar 19, 2010 at 09:21:22AM +0100, Ingo Molnar wrote:
> > Unfortunately, in a previous thread the Qemu maintainer has indicated that he 
> > will essentially NAK any attempt to enhance Qemu to provide an easily 
> > discoverable, self-contained, transparent guest mount on the host side.
> > 
> > No technical justification was given for that NAK, despite my repeated 
> > requests to particulate the exact security problems that such an approach 
> > would cause.
> > 
> > If that NAK does not stand in that form then i'd like to know about it - it 
> > makes no sense for us to try to code up a solution against a standing 
> > maintainer NAK ...
> 
> I still think it is the best and most generic way to let the guest do the 
> symbol resolution. [...]

Not really.

> [...] This has several advantages:
> 
> 	1. The guest knows best about its symbol space. So this would be
> 	   extensible to other guest operating systems.  A brave
> 	   developer may even implement symbol passing for Windows or
> 	   the BSDs ;-)

Having access to the actual executable files that include the symbols achieves 
precisely that - with the additional robustness that all this functionality is 
concentrated into the host, while the guest side is kept minimal (and 
transparent).

> 	2. The guest can decide for its own if it want to pass this
> 	   inforamtion to the host-perf. No security issues at all.

It can decide whether it exposes the files. Nor are there any "security 
issues" to begin with.

> 	3. The guest can also pass us the call-chain and we don't need
> 	   to care about complicated of fetching from the guest
> 	   ourself.

You need to be aware of the fact that symbol resolution is a separate step 
from call chain generation.

I.e. call-chains are a (entirely) separate issue, and could reasonably be done 
in the guest or in the host.

It has no bearing on this symbol resolution question.

> 	4. This way extensible to nested virtualization too.

Nested virtualization is actually already taken care of by the filesystem 
solution via an existing method called 'subdirectories'. If the guest offers 
sub-guests then those symbols will be exposed in a similar way via its own 
'guest files' directory hierarchy.

I.e. if we have 'Guest-2' nested inside 'the 'Guest-Fedora-1' instance, we get:

 /guests/
 /guests/Guest-Fedora-1/etc/
 /guests/Guest-Fedora-1/usr/

we'd also have:

 /guests/Guest-Fedora-1/guests/Guest-2/

So this is taken care of automatically.

I.e. none of the four 'advantages' listed here are actually advantages over my 
proposed solution, so your conclusion is subsequently flawed as well.

> How we speak to the guest was already discussed in this thread. My personal 
> opinion is that going through qemu is an unnecessary step and we can solve 
> that more clever and transparent for perf.

Meaning exactly what?

Thanks,

	Ingo
