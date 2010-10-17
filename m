Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0JQArV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab0JQArU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:47:20 -0400
Date: Sat, 16 Oct 2010 20:46:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
Message-ID: <20101017004641.GB4140@redhat.com>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
 <1287250157.1998.124.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287250157.1998.124.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:29:17PM +0200, Peter Zijlstra wrote:
> On Sat, 2010-10-16 at 16:36 +0000, tip-bot for Huang Ying wrote:
> > Commit-ID:  e21f3e4957f4a55f546873605a5caa59556bb144
> > Gitweb:     http://git.kernel.org/tip/e21f3e4957f4a55f546873605a5caa59556bb144
> > Author:     Huang Ying <ying.huang@intel.com>
> > AuthorDate: Fri, 15 Oct 2010 22:22:16 -0400
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 16 Oct 2010 15:01:27 +0200
> > 
> > x86, NMI: Rewrite NMI handler
> > 
> > The original NMI handler is quite outdated in many aspects. This
> > patch tries to fix it.
> > 
> > The order to process the NMI sources are changed as follow:
> > 
> >  notify_die(DIE_NMI_IPI);
> >  notify_die(DIE_NMI);
> >  /* process io port 0x61 */
> >  nmi_watchdog_touch();
> >  unknown_nmi();
> 
> NACK!
> 
> I object to the DIE_NMI_IPI existance..

Hmm, well to his defense, he isn't adding DIE_NMI_IPI.  That code is
already there.  He is just re-arranging it, making it look painfully
obvious the die_chain probably isn't as efficient as it should be.

I think a bunch of us agree that we need to revamp the NMI notifier to
make it less wasteful.  I was hoping we could do that in a separate patch
that would be layered on top of Huangs.

Would you object to at least consider having this patch series in a
work-in-progress git branch that we can build on top of, with the final
outcome containing an nmi notifier that meets your expectations?

Cheers,
Don

