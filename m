Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0ELRxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:53:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34510 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752Ab0ELRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:53:08 -0400
Date: Wed, 12 May 2010 13:53:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512175305.GB32496@Krystal>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com> <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com> <20100512144811.GA5405@nowhere> <1273678596.27703.30.camel@gandalf.stny.rr.com> <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop> <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273686425.1626.142.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:50:52 up 109 days, 20:28, 10 users,  load average: 0.05, 0.12,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-05-12 at 13:07 -0400, Mathieu Desnoyers wrote:
> > > Its mostly an interface/api question. You cannot easily splice() a
> > > mmap()'ed buffer on machines that have address constraints like sparc.
> > 
> > Ah ? Can you explain this issue a bit more ? There is possibly a concern I don't
> > quite see here. 
> 
> IIRC Sparc has virtually tagged D-caches on the lower 9 bits of the pfn,
> so to avoid cache aliasing both mappings (kernel and user) need to be
> aligned.

I see.

> 
> Since splice needs to swap pages it needs to allocate replacement pages
> with the exact right alignment, which is rather expensive (in either
> time or space).
> 

Hrm ? Why does splice() _need_ to swap pages exactly ? Or is it purely just the
way the current Ftrace implementation happens to work ? ;)

Would you be fine with an alternative implementation and API that support both
mmap() and splice(), without any need to swap pages ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
