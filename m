Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0ELRHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:07:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50293 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753575Ab0ELRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:07:37 -0400
Date: Wed, 12 May 2010 13:07:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512170734.GA15953@Krystal>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com> <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com> <20100512144811.GA5405@nowhere> <1273678596.27703.30.camel@gandalf.stny.rr.com> <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273683624.1626.127.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:05:06 up 109 days, 19:42,  9 users,  load average: 0.22, 0.29,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-05-12 at 18:46 +0200, Frederic Weisbecker wrote:
> > But there is no strong reason for perf record not to use splice,
> > a part the fact that perf doesn't support splice.
> > 
> Its mostly an interface/api question. You cannot easily splice() a
> mmap()'ed buffer on machines that have address constraints like sparc.

Ah ? Can you explain this issue a bit more ? There is possibly a concern I don't
quite see here.

Thanks,

Mathieu

> 
> The thing I was thinking about is adding a new syscall that creates a
> single buffer of specified size and provides a fd. Then use
> PERF_EVENT_IOC_SET_OUTPUT, to connect an event to that fd/buffer and use
> splice() on that fd.
> 
> It could reuse most of the perf buffer code, but simply not map it into
> userspace and therefore not have the restriction on the vaddr.
> 
> Once you have that, a .splice_read implementation shouldn't be too hard.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
