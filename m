Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2DNLRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:17:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNLRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:17:51 -0400
Message-ID: <1334402250.2528.68.camel@twins>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Tejun Heo <tj@kernel.org>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Date: Sat, 14 Apr 2012 13:17:30 +0200
In-Reply-To: <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
	 <1333535915.7188.18.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
	 <1333542649.7188.40.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
	 <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1333601231.7783.31.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
	 <1333604949.7783.76.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 23:07 -0700, David Rientjes wrote:
> On Thu, 5 Apr 2012, Mike Galbraith wrote:
> 
> > I submitted that, and it didn't fly.  I like the generic exclusion
> > better, so I submit that for consideration.
> > 
> 
> [+akpm]
> 
> The last time we went through this, it was left after Andrew had fixed it 
> up when the cpusets version was merged in -mm without any disagreement 
> from Peter who was cc'd and that version was acked both by myself and Paul 
> Menage at https://lkml.org/lkml/2011/12/14/402.  Andrew dropped it and 
> asked for a repost since there was some on-going scheduler work going on 
> in linux-next that caused that version not to apply.  No follow-up was 
> ever offered.
> 
> Why have we now gone in a completely different direction again?

I really absolutely hate the cpuset only feature. The whole point of
kthreadd's existence is to provide a clean environment to spawn kthreads
from. Adding kthreadd to controllers violates this premise.

New and fresh kthreads should always get a bare minimum state, this
includes not being part of any particular cgroup.


