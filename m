Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1FFWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:02:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989Ab1FFWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:02:52 -0400
Date: Tue, 7 Jun 2011 00:02:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to
 unhide debug options
Message-ID: <20110606220240.GB12079@elte.hu>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
 <20110606181606.GB7862@somewhere>
 <20110606183939.GA2335@leaf>
 <20110606213446.GA17026@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606213446.GA17026@somewhere.redhat.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Jun 06, 2011 at 11:39:39AM -0700, Josh Triplett wrote:
> > On Mon, Jun 06, 2011 at 08:16:09PM +0200, Frederic Weisbecker wrote:
> > > On Mon, Jun 06, 2011 at 09:51:30AM -0700, Josh Triplett wrote:
> > > > Several debugging options currently default to y, such as
> > > > CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> > > > want to turn those options off to save space; however, turning them off
> > > > requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> > > > CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> > > > CONFIG_EXPERT exists specifically to unhide options potentially needed
> > > > by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> > > > CONFIG_DEBUG_KERNEL.
> > > > 
> > > > Change various debugging options to only reference DEBUG_KERNEL, not
> > > > EXPERT.
> > > 
> > > Ok, so ideally this should have been done in two patches. They are both
> > > different logical changes that don't imply the same.
> > 
> > Fair enough; I'd considered whether to split this patch or not, and
> > ended up with "not" on the theory that this seemed like a case of "fix
> > an API and fix up the callers", but I can easily split it in v4.
> 
> You haven't just fixed the API and propagated to the callers accordingly.
> What you did is to fix the API and also completely change the behaviour of the callers.
> 
> You have changed EXPERT to imply DEBUG_KERNEL.

yes, i suggested that, because it leads to a more maintainable 
(EXPERT noise free) DEBUG_KERNEL Kconfig section.

> You'd have fixed the callers accordingly if you only changed 
> "depend on EXPERT && DEBUG_KERNEL" into "depend on EXPERT" in the 
> callers, because if EXPERT => DEBUG_KERNEL then (EXPERT && 
> DEBUG_KERNEL) == EXPERT. Thus it would have fit into the same logic 
> and gathering the whole into a single patch would have made sense 
> (although that's debatable, I would have cut that personally, but 
> we don't care at that level).

Hm, that's my fault - i missed that.

Thanks,

	Ingo
