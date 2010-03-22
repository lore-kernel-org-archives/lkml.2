Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0CVT25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0CVT24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:28:56 -0400
Date: Mon, 22 Mar 2010 20:28:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322192825.GW29874@random.random>
References: <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
 <20100322163215.GC18796@elte.hu>
 <4BA7AC6B.3050103@redhat.com>
 <20100322191028.GB21919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322191028.GB21919@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 08:10:28PM +0100, Ingo Molnar wrote:
> I posit that it's both: and that priorities can be communicated - if only you 
> try as a maintainer. All i'm suggesting is to add 'usable, unified user-space' 
> to the list of unfun priorities, because it's possible and because it matters.

IMHO blaming anybody for it but qemu maintainership is very
unfair. They intentionally reinveinted a less self contained,
inferior, underperforming, underfeatured wheel instead of doing the
right thing and just making sure that it as self contained enough as
possible to avoid risking destabilizing their existing codebase. What
can anybody (without qemu git commit access) do about it unless qemu
git maintainer change attitude, dumps its qemu/kvm-all.c nosense for
good, and do the right thing so we can unify for real?

We need to move forward, including multithread the qemu core and be
ready to include desktop virtualization protocol when they're ready
for submission without being suggested to extend vnc instead to gain a
similar speedup (i.e. yet another inferior wheel).

Unification means that _all_ qemu users, pure research, theoretical
interest, Xen, virtualbox, weird pure software architecture, will be
able to push their stuff in for the common good, but that also shall
apply to KVM! It has to become clear that reinveinting inferior wheels
instead of merging the real thing, is absolutely time wasteful,
unnecessary, and it won't make any difference as far as KVM is
concerned, proof is that 0% of userbase runs qemu git to run KVM
(except the kvm-all.c developers to test it perhaps or somebody by
mistake not adding -kvm prefix to command line maybe). I don't pretend
to rate KVM as more important than all the rest of niche usages for
qemu but it shall be _as_ important as the rest and it'd be nice one
day to be able to install only qemu on a system and get something
actually usable in production.

I very much like that qemu gets contributions from everywhere, it's
also nice it can run without KVM (that is purely useful as a
debugging tool to me but still...). I think it can all happen and
unification should be the object for the gain of everyone in both
qemu/kvm and even xen and all the rest.
