Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab1JNPIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:08:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49470 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1JNPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:08:06 -0400
Date: Fri, 14 Oct 2011 12:07:53 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/6] perf/core fixes and improvements
Message-ID: <20111014150753.GA19655@ghostprotocols.net>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
 <20111014071610.GA20648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014071610.GA20648@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 14, 2011 at 09:16:10AM +0200, Ingo Molnar escreveu:
> Hm, got a segfault with a plain 'perf top' on a 3.0-0.rc7.git3-ish 
> box:
> 
>  ./perf top
>  Segmentation fault (core dumped)
> 
> It took about 20 attempts to reproduce the segfault, and it always 
> occured right after the first refresh (which, unlike the working 
> cases showed zero samples):
> 
> Program received signal SIGSEGV, Segmentation fault.                                                    
> [Switching to Thread 0x7ffff13a3700 (LWP 21657)]
> ui_browser__hists_seek (whence=<optimized out>, offset=0, 
> self=0x7fffec0008c0)
>     at util/ui/browsers/hists.c:682
> 682		h->row_offset = 0;
> (gdb) 
> 
> (gdb) bt
> #0  ui_browser__hists_seek (whence=<optimized out>, offset=0, self=0x7fffec0008c0)

browser->top was NULL at that point, it was only being initialized in
the refresh routine, fixed in my tree, please re-pull.

One can easily trigger it by specifying a seldom ocurring event, which
will start the browser without samples, then generating such event, I
used net:netif_rx + ping on my workstation.

> Btw., a side note: could we try to reset the console on segfaults and 
> similar crashes? TUI crashes tend to leave the console in a messed up 
> (blue, etc.) state.

I'll work on that, and also on allowing changing the browser colors,
say, to look like the stdio one.

- Arnaldo
