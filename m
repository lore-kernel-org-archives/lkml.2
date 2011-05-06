Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1EFMFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:05:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36283 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab1EFMFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:05:12 -0400
Date: Fri, 6 May 2011 14:04:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Samuel <chris@csamuel.org>
Cc: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use
 ax/bx as a pair
Message-ID: <20110506120452.GB17112@elte.hu>
References: <1303566747.12067.10.camel@localhost.localdomain>
 <201105052157.06317.chris@csamuel.org>
 <20110505121059.GA31473@elte.hu>
 <201105062147.09398.chris@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105062147.09398.chris@csamuel.org>
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


* Chris Samuel <chris@csamuel.org> wrote:

> On Thu, 5 May 2011 10:10:59 PM Ingo Molnar wrote:
> 
> > Thanks for the update!
> 
> My pleasure.
> 
> > Note that the noapic and the scsi-sync-scan boot parameter suggests
> > that  there's two regressions remaining.
> 
> Understood, I would guess that the SCSI one would map to the
> introduction of the async scsi scanning patch in 2.6.19-rc2
> and its enablement in later Ubuntu kernels.

Yeah. Async SCSI scanning was not supposed to break any existing setup.

> No idea on the APIC one but I'm happy to try and bisect both
> cases if you'd like me to try ?

I could definitely do something about the APIC regression if managed to narrow 
down the commit range (a specific guilty commit would be fantastic of course). 
If the regression got introduced after the e801 regression you'll need to run:

  git cherry-pick 39b68976ac65

at every bisection step that needs that fix - but still bisect as if that extra 
commit was not there. (bisection will throw away that cherry-picking temporary 
tree so you will have to re-pick the commit again and again)

Note that during bisection the current tree might jump in and out of regions 
that need this fix, so be prepared to have to do the cherry-picking at random 
places. You can attempt the cherry-pick at every step and you will get a 
conflict and it will not succeed if the fix is not needed. You can throw away 
the conflicting state via 'git reset --hard'.

> > The stock kernel wont boot - you can work it around via boot
> > options but most  users wont be able to do that.
> 
> Indeed - though at the moment you can't even install a current
> Debian release as the boot loader on the install CD locks the
> box up. :-(

Is that hang due to one of these 3 regressions - or is it a fourth regression 
perhaps?

While the installed base of your hardware is small, i think such old-hardware 
testing is still very valuable feedback to us: it gives us a feel for how 
corrosive our development process is to long-term (10+ years) stability.

Thanks,

	Ingo
