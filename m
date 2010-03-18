Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0CRVPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:15:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56664 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0CRVPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:15:41 -0400
Date: Thu, 18 Mar 2010 22:15:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318211529.GA21367@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA294D4.2060700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA294D4.2060700@redhat.com>
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


* Zachary Amsden <zamsden@redhat.com> wrote:

> On 03/18/2010 12:50 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>The moment any change (be it as trivial as fixing a GUI detail or as
> >>>complex as a new feature) involves two or more packages, development speed
> >>>slows down to a crawl - while the complexity of the change might be very
> >>>low!
> >>Why is that?
> >It's very simple: because the contribution latencies and overhead compound,
> >almost inevitably.
> >
> >If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
> >...
> >
> >Even with the best-run projects in existence it takes forever and is very
> >painful - and here i talk about first hand experience over many years.
> 
> Ingo, what you miss is that this is not a bad thing.  Fact of the
> matter is, it's not just painful, it downright sucks.

Our experience is the opposite, and we tried both variants and report about 
our experience with both models honestly.

You only have experience about one variant - the one you advocate.

See the assymetry?

> This is actually a Good Thing (tm).  It means you have to get your
> feature and its interfaces well defined and able to version forwards
> and backwards independently from each other.  And that introduces
> some complexity and time and testing, but in the end it's what you
> want.  You don't introduce a requirement to have the feature, but
> take advantage of it if it is there.
> 
> It may take everyone else a couple years to upgrade the compilers,
> tools, libraries and kernel, and by that time any bugs introduced by
> interacting with this feature will have been ironed out and their
> patterns well known.

Sorry, but this is pain not true. The 2.4->2.6 kernel cycle debacle has taught 
us that waiting long to 'iron out' the details has the following effects:

 - developer pain
 - user pain
 - distro pain
 - disconnect
 - loss of developers, testers and users
 - grave bugs discovered months (years ...) down the line
 - untested features
 - developer exhaustion

It didnt work, trust me - and i've been around long enough to have suffered 
through the whole 2.5.x misery. Some of our worst ABIs come from that cycle as 
well.

So we first created the 2.6.x process, then as we saw that it worked much 
better we _sped up_ the kernel development process some more, to what many 
claimed was an impossible, crazy pace: two weeks merge window, 2.5 months 
stabilization and a stable release every 3 months.

And you can also see the countless examples of carefully drafted, well thought 
out, committee written computer standards that were honed for years, which are 
not worth the paper they are written on.

'extra time' and 'extra buerocratic overhead to think things through' is about 
the worst thing you can inject into a development process.

You should think about the human brain as a cache - the 'closer' things are 
both in time and pyshically, the better they end up being. Also, the more 
gradual, the more concentrated a thing is, the better it works out in general. 
This is part of the basic human nature.

Sorry, but i really think you are really trying to rationalize a disadvantage 
here ...

	Ingo
