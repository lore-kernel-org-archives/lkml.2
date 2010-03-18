Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0CRUSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:18:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0CRUSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:18:39 -0400
Date: Thu, 18 Mar 2010 21:18:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: drepper@gmail.com
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318201826.GA20588@elte.hu>
References: <20100318191555.GA9741@elte.hu>
 <g6xyqstzrxva01v1nlUYAxe124vaj_firegpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g6xyqstzrxva01v1nlUYAxe124vaj_firegpg@mail.gmail.com>
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


* drepper@gmail.com <drepper@gmail.com> wrote:

> On Thu, Mar 18, 2010 at 12:15, Ingo Molnar <mingo@elte.hu> wrote:
>
> > I didnt say it's glibc's fault - if then it's more of the kernel's fault 
> > as most of the complexity is on that side. I said it's due to the 
> > fundamental distance between the app that makes use of it, the library and 
> > the kernel, and the resulting difficulties in getting a combined solution 
> > out.
> 
> This is wrong, too.  Once there is a kernel patch that has a reasonable 
> syscall interface it's easy enough to hack up the glibc side. [...]

Where 'reasonable' is defined by you, right?

As i said, the KAIO situation is mostly the kernel's fault, but you are a 
pretty passive and unhelpful entity in this matter too, arent you?

For example, just to state the obvious: libaio has been written 8 years ago in 
2002 and has been used in apps early on. Why arent those kernel APIs, while 
not being a full/complete solution, supported by glibc, and wrapped to 
pthreads based emulation on kernels that dont support it?

I'm not talking about a 100% full POSIX AIO implementation (the kernel side is 
not complete enough for that) - i'm just talking about the APIs that libaio 
and the kernel supports today.

Why isnt glibc itself making use of those AIO capabilities internally? (even 
if it's not possible to support full POSIX AIO)

I checked today's glibc repo, and there's no sign of any of that:

 glibc> git grep io_submit 
 glibc> git grep aio_context_t 
 glibc> 

Zero, nil, nada.

Getting _something_ into glibc would certainly help move the situation. Glibc 
itself using existing KAIO bits internally would help too and dont tell me 
it's 100% unusable: it's certainly capable enough to run DB servers. glibc 
using it would create further demand (and pressure, and incentives) for 
improvements.

There were even glibc patches created by Ben LaHaise for some of these bits, 
IIRC.

One can certainly make the argument that glibc not using _any_ of the current 
KAIO capabilities harms its further development.

> [...] Don't try to artificially find an argument to support your thesis.

Charming argumentation style, i really missed it.

Thanks,

	Ingo
