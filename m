Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0CUT7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:59:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0CUT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:59:17 -0400
Date: Sun, 21 Mar 2010 20:59:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321195903.GA29490@elte.hu>
References: <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA674F1.6070603@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA674F1.6070603@nagafix.co.uk>
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


* Antoine Martin <antoine@nagafix.co.uk> wrote:

> On 03/22/2010 02:17 AM, Ingo Molnar wrote:
> >* Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >>On 03/19/2010 03:53 AM, Ingo Molnar wrote:
> >>>* Avi Kivity<avi@redhat.com>   wrote:
> >>>>>There were two negative reactions immediately, both showed a fundamental
> >>>>>server versus desktop bias:
> >>>>>
> >>>>>  - you did not accept that the most important usecase is when there is a
> >>>>>    single guest running.
> >>>>Well, it isn't.
> >>>Erm, my usability points are _doubly_ true when there are multiple guests ...
> >>>
> >>>The inconvenience of having to type:
> >>>
> >>>   perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
> >>>   --guestmodules=/home/ymzhang/guest/modules top
> >>>
> >>>is very obvious even with a single guest. Now multiply that by more guests ...
> >>If you want to improve this, you need to do the following:
> >>
> >>1) Add a userspace daemon that uses vmchannel that runs in the guest and can
> >>    fetch kallsyms and arbitrary modules.  If that daemon lives in
> >>    tools/perf, that's fine.
> >
> > Adding any new daemon to an existing guest is a deployment and usability 
> > nightmare.
>
> Absolutely. In most cases it is not desirable, and you'll find that in a lot 
> of cases it is not even possible - for non-technical reasons.
>
> One of the main benefits of virtualization is the ability to manage and see 
> things from the outside.
>
> > The basic rule of good instrumentation is to be transparent. The moment we 
> > have to modify the user-space of a guest just to monitor it, the purpose 
> > of transparent instrumentation is defeated.
>
> Not to mention Heisenbugs and interference.

Correct.

Frankly, i was surprised (and taken slightly off base) by both Avi and Anthony 
suggesting such a clearly inferior "add a demon to the guest space" solution. 
It's a usability and deployment non-starter.

Furthermore, allowing a guest to integrate/mount its files into the host VFS 
space (which was my suggestion) has many other uses and advantages as well, 
beyond the instrumentation/symbol-lookup purpose.

So can we please have some resolution here and move on: the KVM maintainers 
should either suggest a different transparent approach, or should retract the 
NAK for the solution we suggested.

We very much want to make progress and want to write code, but obviously we 
cannot code against a maintainer NAK, nor can we code up an inferior solution 
either.

Thanks,

	Ingo
