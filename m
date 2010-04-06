Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0DFJui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:50:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0DFJuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:50:32 -0400
Date: Tue, 6 Apr 2010 11:50:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT PULL] break implicit percpu.h -> slab.h dependency
Message-ID: <20100406095012.GA23593@elte.hu>
References: <4BB95DEE.3050607@kernel.org>
 <20100406092523.GA30270@elte.hu>
 <4BBB0118.307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBB0118.307@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> On 04/06/2010 06:25 PM, Ingo Molnar wrote:
> > FYI, -tip testing found a build breakage with your changes:
> > 
> >  drivers/base/node.c:373: error: implicit declaration of function 'kmalloc'
> >  drivers/base/node.c:377: error: implicit declaration of function 'kfree'
> 
> These are NODEMASK_ALLOC() and NODEMASK_FREE() macros which become
> kmalloc/kfree() iff NODES_SHIFT > 8.  I'll grep for these macros and
> commit a proper fix.
> 
> > The fix is below. Since my first test today triggered a build failure i'd 
> > expect there to be more - i'll send all subsequent fixes to this thread.
> 
> Thanks.  Much appreciated.

It's looking pretty good so far with about a dozen tests passed. Thanks for 
doing this transition so carefully!

	Ingo
