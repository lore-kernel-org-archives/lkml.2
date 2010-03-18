Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0CRK2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:28:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0CRK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:28:14 -0400
Date: Thu, 18 Mar 2010 11:28:03 +0100
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
Message-ID: <20100318102803.GA24464@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1FC80.2000401@redhat.com>
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

> On 03/18/2010 10:56 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>On 03/17/2010 10:10 AM, Ingo Molnar wrote:
> >>>>It's about who owns the user interface.
> >>>>
> >>>>If qemu owns the user interface, than we can satisfy this in a very
> >>>>simple way by adding a perf monitor command.  If we have to support third
> >>>>party tools, then it significantly complicates things.
> >>>Of course illogical modularization complicates things 'significantly'.
> >>Who should own the user interface then?
> >If qemu was in tools/kvm/ then we wouldnt have such issues. A single patch (or
> >series of patches) could modify tools/kvm/, arch/x86/kvm/, virt/ and
> >tools/perf/.
> 
> We would have exactly the same issues, only they would be in a single 
> repository.  The only difference is that we could ignore potential 
> alternatives to qemu, libvirt, and RHEV-M.  But that's not how kernel ABIs 
> are developed, we try to make them general, not suited to just one consumer 
> that happens to be close to our heart.

Not at all - as i replied to in a previous mail, tools/perf/ still has a clear 
userspace interface and ABI, and external projects are making use of it.

So there's no problem with the ABI at all.

In fact our experience has been the opposite: the perf ABI is markedly better 
_because_ there's an immediate consumer of it in the form of tools/perf/. It 
gets tested better and external projects can get their ABI tweaks in as well 
and can provide a reference implementation for tools/perf. This has happened a 
couple of times. It's a win-win scenario.

So the exact opposite of what you suggest is happening in practice.

Thanks,

	Ingo
