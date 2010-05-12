Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0ELUwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:52:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40367 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757632Ab0ELUw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:52:27 -0400
Date: Wed, 12 May 2010 16:52:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512205225.GA31848@Krystal>
References: <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop> <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal> <1273690142.1626.158.camel@laptop> <20100512185111.GH21432@Krystal> <1273690878.1626.165.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273690878.1626.165.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:49:37 up 109 days, 23:26,  4 users,  load average: 0.24, 0.24,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-05-12 at 14:51 -0400, Mathieu Desnoyers wrote:
> > 
> > It makes it hard to use splice() or read() if you don't specify the buffer size
> > at creation time. That alone seems like a pretty good argument for fixing the
> > size before the mmap() call. 
> 
> Our read() doesn't actually provide the same data splice()/mmap() would.
> But yeah, hence my proposal to create a separate syscall that creates
> buffer objects.
> 

Well, it's a bit strange to have read() vs splice() outputting different data,
isn't it ?

I would think it's rather more natural to have read() and splice()
implementations outputting the exact same data, and mmap() just mmapping the
ring buffer in userspace. If you really want to export that information in text
format, then a different file descriptor could be used for that, with read()
and splice() support.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
