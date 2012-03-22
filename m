Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2CVJqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:46:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:37611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2CVJqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:46:17 -0400
Message-ID: <1332409539.18960.508.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 22 Mar 2012 10:45:39 +0100
In-Reply-To: <CAOhV88NafiU7hseTzQfApthMk3X=_GT09gEM2Zzx5OJ=8z6vvw@mail.gmail.com>
References: <20120316144028.036474157@chello.nl>
	 <CAOhV88NafiU7hseTzQfApthMk3X=_GT09gEM2Zzx5OJ=8z6vvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I was going to try and test this on power, but it fails to build:
> 
>   mm/filemap_xip.c: In function ‘__xip_unmap’:
>   mm/filemap_xip.c:199: error: implicit declaration of function
> ‘numa_add_vma_counter’

Add: 

#include <linux/mempolicy.h>

to that file and it should build.

> >  [26/26] sched, numa: A few debug bits
> 
> introduced a new warning:
> 
>   kernel/sched/numa.c: In function ‘process_cpu_runtime’:
>   kernel/sched/numa.c:210: warning: format ‘%lu’ expects type ‘long
> unsigned int’, but argument 3 has type ‘u64’
>   kernel/sched/numa.c:210: warning: format ‘%lu’ expects type ‘long
> unsigned int’, but argument 4 has type ‘u64’

Yeah, that's a known trainwreck, some archs define u64 as unsigned long
others as unsigned long long, so whatever you write: %ul or %ull is
wrong and I can't be arsed to add an explict cast since its all debug
bits that won't ever make it in anyway.
