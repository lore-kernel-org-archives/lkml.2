Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab2D0QUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:20:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab2D0QUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:20:31 -0400
Message-ID: <1335543613.13683.112.camel@twins>
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
Date: Fri, 27 Apr 2012 18:20:13 +0200
In-Reply-To: <20120427160748.GE27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
	 <20120427072153.GB4766@gmail.com> <20120427080613.GA7359@gmail.com>
	 <20120427153119.GC27997@infradead.org> <1335541737.2463.135.camel@laptop>
	 <20120427160748.GE27997@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 13:07 -0300, Arnaldo Carvalho de Melo wrote:
> > >      0.00 │┌─→ c0:    cmp    %rax,%rbx
> > >      0.00 ││          mov    %rax,%rcx
> > >      0.00 ││      ↓   ↓je    5dd
> > >      0.00 ││   cc:    test   %rcx,%rcx
> > >      0.00 ││      ↓   ↓je    da
> > >      0.00 ││          mov    0x8(%rcx),%esi
> > >      0.00 ││          shr    $0x4,%esi
> > >      0.00 ││          sub    $0x2,%esi
> > >      0.00 ││   da:    mov    %rcx,0x10(%rbx)
> > >      0.00 ││          mov    %rcx,%rax
> > >      0.00 ││          cmpl   $0x0,%fs:0x18
> > >      0.00 ││      ↓   ↓je    ed
> > >      0.00 ││          lock   cmpxchg %rbx,(%rdx)
> > >      0.00 ││          cmp    %rax,%rcx
> > >           ││
> > >      0.00 │└──────↑ } jne    c0
> > > 
> > > Does it still stands out? I think so, we expect a letter there,
> > > something very different is there, matching the other down arrowsome
> > > columns to the left. 
> > 
> > That just looks daft.. what's wrong with the single up/down arrow?
> 
> Yeah, that too, or perhaps we can bring the instruction column closer to
> the jump column and then that makes it stand out better? 

Well, there should be at least one space between the arrows and the
instruction, otherwise it reads funny. And looking at the above that's
already the case, except for that indenting you did.


