Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0ENIWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:22:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:53653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENIWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:22:00 -0400
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECF00D.6080800@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-12-git-send-email-yinghai@kernel.org>
	 <1273804238.21352.389.camel@pasglop>  <4BECF00D.6080800@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:19:47 +1000
Message-ID: <1273825187.21352.590.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:39 -0700, Yinghai wrote:
> > Oh and this wont' work on sparc. You should probably instead add a
> > lmb_find_in_nid() to lmb which shares code with lmb_alloc_nid().
> 
> should work with sparc...
> 
> +               if (addr == LMB_ERROR)
> +                       continue;
> 
> should do the trick.

Ugh ?

OK, I'll have to let Davem deal with the fine point of the sparc bits,
but I think basically sparc has CONFIG_ARCH_POPULATES_NODE_MAP set, but
the way it's NUMA affinity works, the early_node_map[] is crap, you
cannot rely on the ranges in there.

So it will "work" in the sense that you won't get errors, but the
allocations will -not- be node local. At least that's my understanding.

There's a reason we are adding node local allocations to LMB itself, so
it can deal with that during early boot, please use those and stop
trying to re-invent things slightly differently in ways that will not
work with various existing platforms. 

> keep switch smooth. maybe later could try to replace that one by one.
> also i could use lmb_reserve_area() to take name and print out name to
> make debug easy.

I don't want those _area() variants. If you want to pass a name for
debugging purposes, then add it to lmb_reserve() or something like that
and fix the callers.

Cheers,
Ben.

