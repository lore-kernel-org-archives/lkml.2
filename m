Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0CUVwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:52:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0CUVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:52:22 -0400
Date: Sun, 21 Mar 2010 22:52:07 +0100
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321215207.GA13219@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <4BA6900B.1040408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA6900B.1040408@redhat.com>
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

> > I.e. you are arguing for microkernel Linux, while you see me as arguing 
> > for a monolithic kernel.
> 
> No. I'm arguing for reducing bloat wherever possible.  Kernel code is more 
> expensive than userspace code in every metric possible.

1)

One of the primary design arguments of the micro-kernel design as well was to 
push as much into user-space as possible without impacting performance too 
much so you very much seem to be arguing for a micro-kernel design for the 
kernel.

I think history has given us the answer for that fight between microkernels 
and monolithic kernels.

Furthermore, to not engage in hypotheticals about microkernels: by your 
argument the Oprofile design was perfect (it was minimalistic kernel-space, 
with all the complexity in user-space), while perf was over-complex (which 
does many things in the kernel that could have been done in user-space).

Practical results suggest the exact opposite happened - Oprofile is being 
replaced by perf. How do you explain that?

2)

In your analysis you again ignore the package boundary costs and artifacts as 
if they didnt exist.

That was my main argument, and that is what we saw with oprofile and perf: 
while maintaining more kernel-code may be more expensive, it sure pays off for 
getting us a much better solution in the end.

And getting a 'much better solution' to users is the goal of all this, isnt 
it?

I dont mind what you call 'bloat' per se if it's for a purpose that users find 
like a good deal. I have quite a bit of RAM in most of my systems, having 50K 
more or less included in the kernel image is far less important than having a 
healthy and vibrant development model and having satisfied users ...

	Ingo
