Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab2D0PtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:49:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:44815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760390Ab2D0PtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:49:18 -0400
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20120427153119.GC27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
	 <20120427072153.GB4766@gmail.com> <20120427080613.GA7359@gmail.com>
	 <20120427153119.GC27997@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 17:48:57 +0200
Message-ID: <1335541737.2463.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 12:31 -0300, Arnaldo Carvalho de Melo wrote:
> > So the forward conditional jumps get moved by one character to 
> > the right and get prefixed with '.', which has the following 
> > effects:
> > 
> >  - the flow of all the 'other', register modifying and loop 
> >    instructions can be seen more clearly
> > 
> >  - the 'exception' forward conditional jumps get moved into the 
> >    visual background, slightly.
> > 
> >  - blocks of instructions with no branches amongst them are more 
> >    clearly visible.
> > 
> > If '.' is too aggressive or too confusing then some other 
> > (possibly graphical) character could be used as well?
> 
> Yeah, there are some unused graphical chars. But perhaps we should just
> use ↓ again?
> 
>      0.00 │┌─→ c0:    cmp    %rax,%rbx
>      0.00 ││          mov    %rax,%rcx
>      0.00 ││      ↓   ↓je    5dd
>      0.00 ││   cc:    test   %rcx,%rcx
>      0.00 ││      ↓   ↓je    da
>      0.00 ││          mov    0x8(%rcx),%esi
>      0.00 ││          shr    $0x4,%esi
>      0.00 ││          sub    $0x2,%esi
>      0.00 ││   da:    mov    %rcx,0x10(%rbx)
>      0.00 ││          mov    %rcx,%rax
>      0.00 ││          cmpl   $0x0,%fs:0x18
>      0.00 ││      ↓   ↓je    ed
>      0.00 ││          lock   cmpxchg %rbx,(%rdx)
>      0.00 ││          cmp    %rax,%rcx
>           ││
>      0.00 │└──────↑ } jne    c0
> 
> Does it still stands out? I think so, we expect a letter there,
> something very different is there, matching the other down arrowsome
> columns to the left. 

That just looks daft.. what's wrong with the single up/down arrow?

Also, can we keep all this on the list please?

