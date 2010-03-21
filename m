Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0CUTHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:07:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0CUTHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:07:11 -0400
Date: Sun, 21 Mar 2010 20:06:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100321190656.GC25922@elte.hu>
References: <4BA250BF.80704@codemonkey.ws>
 <20100318162853.GB447@elte.hu>
 <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA47AD0.2010509@redhat.com>
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

> >> [...] Second, from my point of view all contributors are volunteers 
> >> (perhaps their employer volunteered them, but there's no difference from 
> >> my perspective). Asking them to repaint my apartment as a condition to 
> >> get a patch applied is abuse.  If a patch is good, it gets applied.
> >
> > This is one of the weirdest arguments i've seen in this thread. Almost all 
> > the time do we make contributions conditional on the general shape of the 
> > project. Developers dont get to do just the fun stuff.
> 
> So, do you think a reply to a patch along the lines of
> 
>   NAK.  Improving scalability is pointless while we don't have a decent GUI.  
> I'll review you RCU patches
>   _after_ you've contributed a usable GUI.
> 
> ?

What does this have to do with RCU?

I'm talking about KVM, which is a Linux kernel feature that is useless without 
a proper, KVM-specific app making use of it.

RCU is a general kernel performance feature that works across the board. It 
helps KVM indirectly, and it helps many other kernel subsystems as well. It 
needs no user-space tool to be useful.

KVM on the other hand is useless without a user-space tool.

[ Theoretically you might have a fair point if it were a critical feature of 
  RCU for it to have a GUI, and if the main tool that made use of it sucked. 
  But it isnt and you should know that. ]

Had you suggested the following 'NAK', applied to a different, relevant 
subsystem:

  |   NAK.  Improving scalability is pointless while we don't have a usable 
  | tool.  I'll review you perf patches _after_ you've contributed a usable 
  | tool.

you would have a fair point. In fact, we are doing that we are living by that. 
It makes absolutely zero sense to improve the scalability of perf if its 
usability sucks.

So where you are trying to point out an inconsistency in my argument there is 
none.

> > This is a basic quid pro quo: new features introduce risks and create 
> > additional workload not just to the originating developer but on the rest 
> > of the community as well. You should check how Linus has pulled new 
> > features in the past 15 years: he very much requires the existing code to 
> > first be top-notch before he accepts new features for a given area of 
> > functionality.
> 
> For a given area, yes. [...]

That is my precise point.

KVM is a specific subsystem or "area" that makes no sense without the 
user-space tooling it relates to. You seem to argue that you have no 'right' 
to insist on good quality of that tooling - and IMO you are fundamentally 
wrong with that.

Thanks,

	Ingo
