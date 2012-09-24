Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2IXPAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:00:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab2IXPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:00:54 -0400
Date: Mon, 24 Sep 2012 16:00:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120924150048.GB11266@suse.de>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 02:42:44PM -0700, Linus Torvalds wrote:
> On Fri, Sep 14, 2012 at 2:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > as Nikolay says below, we have a regression in 3.6 with pgbench's
> > benchmark in postgresql.
> >
> > I was able to reproduce it on another box here and did a bisection run.
> > It pointed to the commit below.
> 
> Ok. I guess we should just revert it. However, before we do that,
> maybe Mike can make it just use the exact old semantics of
> select_idle_sibling() in the update_top_cache_domain() logic.
> 

The patch that you being reverted was meant to fix problems with
commit 4dcfe102 (sched: Avoid SMT siblings in select_idle_sibling() if
possible). That patch made select_idle_sibling() quite fat and I know it
is responsible for a 2% regression in a kernel compile benchmark between
kernel 3.1 and 3.2 on an old AMD Phenom II X4 940. Reverting Mike's patch
might fix this Postgres regression but it reintroduces the overhead caused
by commit 4dcfe102 for other cases.  I do not have a suggestion on how to
make this better, I'm just pointing out that the revert has some downsides.

-- 
Mel Gorman
SUSE Labs
