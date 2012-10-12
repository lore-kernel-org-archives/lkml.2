Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab2JLJHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:07:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39068 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab2JLJHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:07:25 -0400
Date: Fri, 12 Oct 2012 11:08:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] perf updates/fixes
Message-ID: <20121012090810.GA11763@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
References: <20121012081947.GA20570@gmail.com>
 <20121012083926.GA30327@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121012083926.GA30327@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:39:26AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > Linus,
> > 
> > Please pull the latest perf-urgent-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> > 
> >    HEAD: 95cf59ea72331d0093010543b8951bb43f262cac perf: Fix perf_cgroup_switch for sw-events
> 
> Note that if you merge it then there's a new semantic conflict 
> with recent rbtree.c changes in your tree, causing a tools/perf/ 
> build failure:
> 
> ../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such file or directory compilation terminated.
> 
> See the fix below.
> 
> ( If the __maybe_unused annotations are too ugly for 
>   lib/rbtree.c then we'll fix that in tools/perf in a cleaner
>   way, weakening the compiler checks for the rbtree build. We 
>   are using stronger compiler checks in tools/perf/, which has 
>   served us very well so far and is a big net win - the price is 
>   the occasional extra annotation of dummy inline function 
>   parameters. )

Btw,

Markus fixed it that way recently:

http://marc.info/?l=linux-kernel&m=134980573527738

by adding the -Wno-unused-parameter switch only to lib/rbtree.o when
built from within perf.

I see now though that his patch has some unrelated changes to
trace-event-perl.c's permissions which shouldn't be there.

-- 
Regards/Gruss,
Boris.
