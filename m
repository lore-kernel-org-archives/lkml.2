Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0CRJWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:22:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0CRJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:22:47 -0400
Date: Thu, 18 Mar 2010 10:22:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318092232.GC2157@elte.hu>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1E24B.6090904@redhat.com>
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

> >  - move a clean (and minimal) version of the Qemu code base to tools/kvm/, 
> >    in the upstream kernel repo, and work on that from that point on.
> 
> I'll ignore the repository location which should be immaterial to a serious 
> developer and concentrate on the 'clean and minimal' aspect, since it has 
> some merit.  [...]

To the contrary, experience shows that repository location, and in particular 
a shared repository for closely related bits is very much material!

It matters because when there are two separate projects, even a "serious 
developer" is finding it double and triple difficult to contribute even 
trivial changes.

It becomes literally a nightmare if you have to touch 3 packages: kernel, a 
library and an app codebase. It takes _forever_ to get anything useful done.

Also, 'focus on a single thing' is a very basic aspect of humans, especially 
those who do computer programming. Working on two code bases in two 
repositories at once can be very challenging physically and psychically.

So what i've seen is that OSS programmers tend to pick a side, pretty much 
randomly, and then rationalize it in hindsight why they prefer that side ;-)

Most of them become either a kernel developer or a user-space package 
developer - and then they specialize on that field and shy away from changes 
that involve both. It's a basic human thing to avoid the hassle that comes 
with multi-package changes. (One really has to be outright stupid, fanatic or 
desperate to even attempt such changes these days - such are the difficulties 
for a comparatively low return.)

The solution is to tear down such artificial walls of contribution where 
possible. And tearing down the wall between KVM and qemu-kvm seems very much 
possible and the advantages would be numerous.

Unless by "serious developer" you meant: "developer willing to [or forced to] 
waste time and effort on illogically structured technology".

> [...]
>
> Do you really think the echo'n'cat school of usability wants to write a GUI?  
> In linux-2.6.git?

Then you'll be surprised to hear that it's happening as we speak and the 
commits are there in linux-2.6.git. Both a TUI and GUI is in the works.

Furthermore, the numbers show that half of the usability fixes to tools/perf/ 
came not from regular perf contributors but from random kernel developers and 
testers who when they build the latest kernel and try out perf at the same 
time (it's very easy because you already have it in the kernel repository - no 
separate download, no installation, etc. necessary).

I had literally zero such contributions when (the precursor to) 'perf' was 
still a separate user-space project.

You could have the same effect for Qemu: the latest bits in tools/kvm/ would 
be built by regular kernel testers and developers. The integration benefits 
dont just extend to developers, a unified project is vastly easier to test as 
well.

Thanks,

	Ingo
