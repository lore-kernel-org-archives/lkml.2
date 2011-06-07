Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab1FGSEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:04:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab1FGSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:04:45 -0400
Date: Tue, 7 Jun 2011 20:04:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options
Message-ID: <20110607180427.GA22523@elte.hu>
References: <20110606165130.GA1844@leaf>
 <tip-2458073da04571182748aa4289630dca52ba63cc@git.kernel.org>
 <20110606214502.GB17026@somewhere.redhat.com>
 <20110606220905.GB1999@leaf>
 <20110607101851.GA21356@elte.hu>
 <20110607153411.GA5175@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607153411.GA5175@leaf>
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


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Tue, Jun 07, 2011 at 12:18:51PM +0200, Ingo Molnar wrote:
> > 
> > * Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > On Mon, Jun 06, 2011 at 11:45:04PM +0200, Frederic Weisbecker wrote:
> > > > On Mon, Jun 06, 2011 at 09:39:40PM +0000, tip-bot for Josh Triplett wrote:
> > > > > Commit-ID:  2458073da04571182748aa4289630dca52ba63cc
> > > > > Gitweb:     http://git.kernel.org/tip/2458073da04571182748aa4289630dca52ba63cc
> > > > > Author:     Josh Triplett <josh@joshtriplett.org>
> > > > > AuthorDate: Mon, 6 Jun 2011 09:51:30 -0700
> > > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > > CommitDate: Mon, 6 Jun 2011 19:30:01 +0200
> > > > > 
> > > > > debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options
> > > > > 
> > > > > Several debugging options currently default to y, such as
> > > > > CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.
> > > > > 
> > > > > Embedded users might want to turn those options off to save space;
> > > > > however, turning them off requires turning on CONFIG_DEBUG_KERNEL to
> > > > > unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
> > > > > unhide debugging options, and CONFIG_EXPERT exists specifically
> > > > > to unhide options potentially needed by experts and/or embedded
> > > > > users, make CONFIG_EXPERT automatically imply CONFIG_DEBUG_KERNEL.
> > > > > 
> > > > > Change various debugging options to only reference DEBUG_KERNEL,
> > > > > not EXPERT.
> > > > > 
> > > > > Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed
> > > > > wrong, since EXPERT should not directly affect anything except
> > > > > the availability of other options.  (And EXPERT definitely
> > > > > shouldn't mean "implicitly turn off default safety features".)
> > > > > 
> > > > > Change it to default to y, which means that turning on EXPERT
> > > > > does not automatically disable it, but will provide the option
> > > > > to disable it.
> > > > > 
> > > > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > > > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > 
> > > > No, Nacked actually. I'm fine with the v2 that only changed
> > > > the EXPERT config to imply DEBUG_KERNEL. But all the other
> > > > changes here need to be revised, as I outlined in the thread.
> > > 
> > > Fixed in v4; please replace the patch in tip with that.
> > 
> > i applied the much simpler v2 twoliner version instead.
> 
> OK...
> 
> So, should I prepare a separate patch which changes the instances 
> of DEBUG_KERNEL && EXPERT, or just leave them?

Yeah, would be nice to send a separate patch for that - 'DEBUG_KERNEL 
&& EXPERT' is equivalent to EXPERT now, right?

Thanks,

	Ingo
