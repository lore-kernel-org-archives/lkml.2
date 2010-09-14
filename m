Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0INFeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:34:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:6434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0INFeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:34:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,362,1280732400"; 
   d="scan'208";a="837401452"
Subject: Re:  [PATCH 00/20] mm: Preemptibility -v4
From: "Alex,Shi" <alex.shi@intel.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <AANLkTikSm2Mq8hGNac9rpFH-3pvryw2kW57EP45Ny6Vp@mail.gmail.com>
References: <20100828141637.421594670@chello.nl>
	 <AANLkTikSm2Mq8hGNac9rpFH-3pvryw2kW57EP45Ny6Vp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 13:36:25 +0800
Message-ID: <1284442585.26157.8150.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter:
We tested your tree base on 2.6.36-rc3 kernel. The testing covered on
Core2 2P, NHM-EP/WSM-EP machines, no clear performance regression found
on your patch compare to 36-rc3, and also no clear improvements on our
benchmarks. 

The benchmarks are listed in the following website, and plus some of
FFSB/FIO scenarios.  http://kernel-perf.sourceforge.net/ 

Regards! 
Alex 

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat, Aug 28, 2010 at 10:16 PM
> Subject: [PATCH 00/20] mm: Preemptibility -v4
> To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity
> <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Rik van Riel
> <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
> akpm@linux-foundation.org, Linus Torvalds
> <torvalds@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Benjamin
> Herrenschmidt <benh@kernel.crashing.org>, David Miller
> <davem@davemloft.net>, Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel
> Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>, Peter Zijlstra
> <a.p.zijlstra@chello.nl>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
> Yanmin Zhang <yanmin_zhang@linux.intel.com>, Stephen Rothwell
> <sfr@canb.auug.org.au>
> 
> 
> This patch-set makes part of the mm a lot more preemptible. It converts
> i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
> preemptible.
> 
> The main motivation was making mm_take_all_locks() preemptible, since it
> appears people are nesting hundreds of spinlocks there.
> 
> The side-effects are that can finally make mmu_gather preemptible,
> something which lots of people have wanted to do for a long time.
> 
> It also gets us anon_vma refcounting, which seems to result in a nice
> cleanup of the anon_vma lifetime rules wrt KSM and compaction.
> 
> This patch-set it build and boot-tested on x86_64 (a previous version was
> also tested on Dave's Niagra2 machines, and I suppose s390 did too when
> Martin provided the conversion patch for his arch).
> 
> There are no known architectures left unconverted, although some arch code
> never did see a compiler (superh and ia64 come to mind, I'll try and
> update my toolchains next week).
> 
> Yanmin ran the last posting through the comprehensive Intel test farm
> and didn't find any regressions.
> 
> ( Not included in this posting are the 4 Sparc64 patches that implement
>  gup_fast, those can be applied separately after this series gets
>  anywhere. )
> 
> Full series (including the Sparc64 gup_fast bits) also available in -git
> form from (against Linus' tree as of about an hour ago):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
> mmu_preempt
> 
> Do people feel its ready to get added to -next?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


