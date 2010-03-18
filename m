Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0CRLUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:20:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0CRLUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:20:24 -0400
Date: Thu, 18 Mar 2010 12:19:59 +0100
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
Message-ID: <20100318111959.GB2174@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318092232.GC2157@elte.hu>
 <4BA20153.5060409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA20153.5060409@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 03/18/2010 11:22 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>  - move a clean (and minimal) version of the Qemu code base to tools/kvm/,
> >>>    in the upstream kernel repo, and work on that from that point on.
> >>I'll ignore the repository location which should be immaterial to a serious
> >>developer and concentrate on the 'clean and minimal' aspect, since it has
> >>some merit.  [...]
> >
> > To the contrary, experience shows that repository location, and in 
> > particular a shared repository for closely related bits is very much 
> > material!
> >
> > It matters because when there are two separate projects, even a "serious 
> > developer" is finding it double and triple difficult to contribute even 
> > trivial changes.
> >
> > It becomes literally a nightmare if you have to touch 3 packages: kernel, 
> > a library and an app codebase. It takes _forever_ to get anything useful 
> > done.
> 
> You can't be serious.  I find that the difficulty in contributing a patch 
> has mostly to do with writing the patch, and less with figuring out which 
> email address to send it to.

My own experience and everyone i've talked about such topics (developers and 
distro people) about feature contribution tells the exact opposite: it's much 
harder to contribute features to multiple packages than to a single project.

kernel+library+app features take forever to propagate, and there's constant 
fear of version friction, productization deadlines are uncertain and ABI 
messups are frequent as well due to disjoint testing. Also, each component has 
essential veto power: so if the proposed API or approach is opposed or changed 
in a later stage then that affects (sometimes already committed) changes. If 
you've ever done it you'll know how tedious it is.

This very thread and recent threads about KVM usability demonstrate the same 
complications.

Thanks,

	Ingo
