Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab2CMMLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:11:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab2CMMK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:10:57 -0400
Date: Tue, 13 Mar 2012 13:10:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313121034.GA15543@elte.hu>
References: <20120313083310.GA27560@flint.arm.linux.org.uk>
 <20120313083630.GA10131@elte.hu>
 <20120313084713.GB27560@flint.arm.linux.org.uk>
 <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
 <20120313092649.GA15406@elte.hu>
 <20120313095020.GA13220@flint.arm.linux.org.uk>
 <20120313101859.GA2626@elte.hu>
 <20120313112729.GA25835@flint.arm.linux.org.uk>
 <20120313115640.GA27378@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313115640.GA27378@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [...]
> 
> Having a patch applied to an old scheduler tree that is barely 
> out of -rc1 and then pushing it out into linux-next at -rc8, 
> without even checking how it integrates with upstream, barely 
> a few days before the merge window is just plain stupid.

So, while I cannot know what Linus will think and do once he 
gets such a conflict (my guess is that he'd just fix it up 
silently - it's really trivial), I can tell you what the 
conflict told *me*: that the communication channels between the 
ARM tree and the scheduler tree are not in the best of shape.

And that is what worried me enough to write a reply while 
recognizing that PeterZ acked the patch - not the triviality of 
the patch or the triviality of the conflict.

And dammit, I have the right and the duty to be concerned about 
a conflict in the scheduler code if I see it for the first time, 
not just Linus. Conflicts aren't magically just for Linus to be 
interested and act upon, they can occasionally be informative at 
subsystem maintainer levels just as well - like here...

What we should not do in terms of conflict avoidance are 
*excessive* cross-subsystem merges: for example you 
indiscriminately merging the totality of all pending scheduler 
changes into the ARM tree and thus forcing Linus's hand in terms 
of not being able to reject to pull the scheduler tree.

But if I got it right, working together on a trivial, 
well-isolated callback patch to make life easier is not frowned 
upon by Linus at all ...

Thanks,

	Ingo
