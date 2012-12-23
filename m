Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2LWC6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 21:58:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:27514 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab2LWC6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 21:58:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,338,1355126400"; 
   d="scan'208";a="266064205"
Date: Sun, 23 Dec 2012 10:58:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dynticks:3.7-nohz1 5/25] arch/x86/kernel/apm_32.c:910:38:
 sparse: incorrect type in argument 3 (different modifiers)
Message-ID: <20121223025820.GC14002@localhost>
References: <50d402bb.vyOeS/aP5n0UGfmx%fengguang.wu@intel.com>
 <CAFTL4hxPW829tM=dB6T5USpkRyuHAvE3KiEj2csCR=RZ3Ab90w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxPW829tM=dB6T5USpkRyuHAvE3KiEj2csCR=RZ3Ab90w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 07:11:49PM +0100, Frederic Weisbecker wrote:
> 2012/12/21 kbuild test robot <fengguang.wu@intel.com>:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git 3.7-nohz1
> > head:   46209cdbb7d5346c29b2243c54b298a233684a5a
> > commit: 40d488f9fcd6840722402976f7a168e05819f526 [5/25] cputime: Use accessors to read task cputime stats
> >
> >
> > sparse warnings:
> >
> > + arch/x86/kernel/apm_32.c:910:38: sparse: incorrect type in argument 3 (different modifiers)
> > arch/x86/kernel/apm_32.c:910:38:    expected unsigned long [nocast] [usertype] *stime
> > arch/x86/kernel/apm_32.c:910:38:    got unsigned long *<noident>
> 
> Ok I must say I don't really understand this report. Do you have any
> hint on what it means?

It's possibly due to this "__nocast" modifier in the type definition:

typedef unsigned long __nocast cputime_t;

Not sure how to fix it though.

> 40d488f9 arch/x86/kernel/apm_32.c Frederic Weisbecker 2012-11-13  902   cputime_t stime;
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  903
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  904   int apm_idle_done = 0;
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  905   unsigned int jiffies_since_last_check = jiffies - last_jiffies;
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  906   unsigned int bucket;
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  907
> 99c63221 arch/x86/kernel/apm_32.c Len Brown           2011-04-01  908   WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
> ^1da177e arch/i386/kernel/apm.c   Linus Torvalds      2005-04-16  909  recalc:
> 40d488f9 arch/x86/kernel/apm_32.c Frederic Weisbecker 2012-11-13 @910   task_cputime(current, NULL, &stime);

Thanks,
Fengguang
