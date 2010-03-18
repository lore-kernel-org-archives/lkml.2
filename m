Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0CROXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:23:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab0CROXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:23:04 -0400
Date: Thu, 18 Mar 2010 15:22:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318142255.GG25642@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E7E2.3010803@redhat.com>
 <20100318095418.GD2157@elte.hu>
 <4BA2030B.3090007@redhat.com>
 <20100318105826.GA2174@elte.hu>
 <4BA2296A.90401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2296A.90401@redhat.com>
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


* Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> On 03/18/10 11:58, Ingo Molnar wrote:
> >
> >* Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
> >>Thats a very glorified statement but it's not reality, sorry. You can do
> >>that with something like perf because it's so small and development of perf
> >>is limited to a very small group of developers.
> >
> > I was not talking about just perf: i am also talking about the arch/x86/ 
> > unification which is 200+ KLOC of highly non-trivial kernel code with 
> > hundreds of contributors and with 8000+ commits in the past two years.
> 
> Sorry but you cannot compare merging two chunks of kernel code that 
> originated from the same base, with the efforts of mixing a large userland 
> project with a kernel component. Apples and oranges.

That's true to a certain degree, but combined with the perf experience it's 
all rather clear.

Similar arguments were made against the x86 unification and against perf. 
Similar arguments were made against KVM and in favor of Xen years ago - back 
when few of you knew about it ;-)

These are all repeating patterns in my experience.

You could fairly contrast that with a _failed_ unification perhaps - but i'm 
not aware of any such failed unification. (please educate me if you are)

The thing is, unifications are rare in the OSS space not because they dont 
make sense technically (to the contrary), they are rare due to blind inertia 
(why change if we managed to muddle through with the current scheme?) and to a 
certain degree due to the egos involved ;-)

As such we have a proliferation of packages in Linux, and we'd be much better 
off in a more focused fashion. And whenever i see that in the kernel's context 
i'll mention it - as it happened here too.

> > Also, it applies to perf as well: people said exactly that a year ago: 
> > 'perf has it easy to be clean as it is small, once it gets as large as 
> > Oprofile tooling it will be in the same messy situation'.
> >
> > Today perf has more features than Oprofile, has a larger and more complex 
> > code base, has more contributors, and no, it's not in the same messy 
> > situation at all.
> 
> Both perf and oprofile are still relatively small projects in comparison to 
> QEMU.

So is your argument that the unification does not make sense due to size? 
Would a smaller Qemu be more appropriate for this purpose?

> > So whatever you think of large, unified projects, you are quite clearly 
> > mistaken. I have done and maintained through two different types of 
> > unifications and the experience was very similar: both developers and 
> > users (and maintainers) are much better off.
> 
> You believe that I am wrong in my assessment of unified projects, and I 
> obviously think you are mistaken and underestimating the cost and effects of 
> trying to merge the two.
> 
> Well I think we are just going to agree to disagree on this one. I am not 
> against merging projects where it makes sense, but in this particular case I 
> am strongly convinced the loss would be much greater than the gain.

I wish you said that based on first hand negative experience with 
unifications, not based on just pure speculation.

(and yes, i speculate too, but at least with some basis)

	Ingo
