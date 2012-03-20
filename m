Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2CTDdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:33:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50068 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2CTDdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:33:07 -0400
Date: Mon, 19 Mar 2012 20:33:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120320033300.GH2393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120319152317.GA3932@gmail.com>
 <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032003-1780-0000-0000-000004194E21
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000258; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00123544; UDB=6.00029630; UTC=2012-03-20
 03:33:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 05:18:21PM -0700, Linus Torvalds wrote:
> On Mon, Mar 19, 2012 at 8:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest core-rcu-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus
> 
> So Ingo, Paul - I'd really have liked to have some high-level
> user-readable explanation of the changes that I could have put in the
> merge message.
> 
> This is especially true for something like RCU, which (a) seems to be
> continually growing and (b) has had cases of "oops, now it stopped
> working" or "uhhuh, new rules due to new rcu implementations
> interacting differently with spinlocks" etc.
> 
> So when the diffstat summary looks like this:
> 
>   29 files changed, 2965 insertions(+), 642 deletions(-)
> 
> with basically 2000+ new lines (yes, many of them in Documebntation,
> happily, but rcutree grew noticeably too), it really would have been
> nice to have some blurb about what the heck actually happened, ok?

Yep, 2072 of the net additions were in Documentation.

> I'm starting to get explanations in signed tags or in the "please
> pull" messages from a fairly large number of maintainers now, and the
> pulls from Ingo are beginning to look sad and unexplained in contrast.

Many of the change to rcutree.c were due to additions of checks for illegal
use of RCU from idle or offlined CPUs, reworking of the CPU-offline code
path, and fixes to allow use of RCU from idle CPUs (which has always been
illegal, but many uses have nevertheless slipped in over the years).

If it would help, I would be happy to put together an itemized list.
I will of course do so for the next merge window.

							Thanx, Paul

