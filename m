Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0CTPAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0CTPAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:00:22 -0400
Date: Sat, 20 Mar 2010 15:59:43 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zamsden@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100320145943.GI29874@random.random>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA294D4.2060700@redhat.com>
 <20100318211529.GA21367@elte.hu>
 <4BA2A70B.5080101@redhat.com>
 <20100318224446.GC19669@elte.hu>
 <4BA3260D.5090407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA3260D.5090407@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 09:21:49AM +0200, Avi Kivity wrote:
> On 03/19/2010 12:44 AM, Ingo Molnar wrote:
> >
> > Too bad - there was heavy initial opposition to the arch/x86 unification as
> > well [and heavy opposition to tools/perf/ as well], still both worked out
> > extremely well :-)
> >    
> 
> Did you forget that arch/x86 was a merging of a code fork that happened 
> several years previously?  Maybe that fork shouldn't have been done to 
> begin with.

We discussed and probably timidly tried to share the sharable
initially but we realized it was too time wasteful. In addition to
having to adapt the code to 64bit we would also had to constantly
solve another problem on top of it (see the various split on _32/_64,
those takes time to achieve, maybe not huge time but still definitely
some time and effort). Even in retrospect I am quite sure the way
x86-64 happened was optimal and if we would go back we would do it
again the exact same way even if the final object was to have a common
arch/x86 (and thankfully Linus is flexible and smart enough to realize
that code that isn't risking to destabilize anything shouldn't be
forced out just because it's not to a totally
theoretical-perfect-nitpicking-clean-state yet). It's still a lot of
work do the unification later as a separate task, but it's not like if
we did it immediately it would have been a lot less work. It's about
the same amount of effort and we were able to defer it for later and
decrease the time to market which surely has contributed to the
success of x86-64.

Problem of qemu is not some lack of GUI or that it's not included in
the linux kernel git tree, the definitive problem is how to merge
qemu-kvm/kvm and qlx into it. If you (Avi) were the qemu maintainer I
am sure there wouldn't two trees so as a developer I would totally
love it, and I am sure that with you as maintainer it would have a
chance to move forward with qlx on desktop virtualization without
proposing to extend vnc instead to achieve a "similar" result (imagine
if btrfs is published on a website and people starts to discuss if it
should ever be merged ever because reinventing some part of btrfs
inside ext5 might achieve ""similar"" results).

About a GUI for KVM to use on desktop distributions, that is an
irrelevant concern compared to the lack of protocol more efficient
than rdesktop/rdp/vnc for desktop virtualization. I've people asking
me to migrate hundreds of desktops to desktop virtualization on KVM in
their organizations and I tell them to use spice because I believe
it's the most efficient option available (at least as far as we stick
to open source open protocols), there are universities using spice on
thousand of student desktops, and I think we need paravirt graphics to
happen ASAP in the main qemu tree too.

In short: running KVM on the desktop is irrelevant compared to running
the desktop on KVM so I suggest to focus on what is more important
first ;).

Thanks,
Andrea
