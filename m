Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423Ab1CYKb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:31:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47140 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934109Ab1CYKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:31:56 -0400
Date: Fri, 25 Mar 2011 11:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325103138.GC31903@elte.hu>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325101238.GC1409@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325101238.GC1409@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
> >         USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
> >  SIMPLE 61107  354977    217  8099529  845.100 MB/sec
> >  SPIN   63140  364888    214  6840527  879.077 MB/sec
> > 
> > On various runs, the adaptive spinning trylock consistently posts
> > higher throughput.  The amount of difference varies but it outperforms
> > consistently.
> 
> I've been running more of these tests and am having doubts about the
> consistency.  It seems that, even on a fresh filesystem, some random
> initial condition seems to have persistent effect on the whole run.
> I'll run more tests and report back.

Ok, and there's the deadlock issue as well which Steve noticed.

I'll zap the patches from tip:core/urgent and lets do this via tip:core/locking 
with a .40 timeframe and plenty of time of testing.

Thanks,

	Ingo
