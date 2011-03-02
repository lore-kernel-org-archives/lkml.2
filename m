Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1CBSIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:08:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab1CBSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:08:38 -0500
Date: Wed, 2 Mar 2011 19:08:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302180827.GA13693@elte.hu>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
 <20110302161900.GP3319@htj.dyndns.org>
 <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
 <20110302170702.GS3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302170702.GS3319@htj.dyndns.org>
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
> On Wed, Mar 02, 2011 at 08:47:54AM -0800, Yinghai Lu wrote:
> > > > Yeah, it's a pretty interesting piece of code in need of some cleanup.
> > No, i mean second one is not causing any problem.
> > 
> > that only take end is intentionally. that will make sure we can get
> > space for page table even in extreme case.
> 
> Hmmm... it seems like it only took @end because it always allocated
> the whole page table in one go.  Always from the bottom to top.  Am I
> missing something?
> 
> > > > If you're interested in doing the above, please go ahead and let me
> > > > know.
> > 
> > No. please don't revert it.
> > 
> > Ingo, please get patches that will align to 1G ... from
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
> 
> If you were gonna do that, you could have just said that you objected
> to the reverting.  The message was Request for Comments - soliciting
> responses.
> 
> As I wrote multiple times, I think the code as implemented is a bit
> heavy handed for the problem.  And a bigger problem for me is that it
> kind of just piles on the existing messiness and worsens it.  I really
> hope we wouldn't be doing that anymore.
> 
> I tried to clean up the page table allocation code but the necessary
> changes felt a bit too large at this stage, so IMO that's best left to
> the next cycle.

Do you plan to implement it more cleanly?

> To me, it seems complicated for not good enough reasons.  I'll defer
> the decision to x86 maintainers.  Ingo, hpa, Thomas, what do you guys
> think?

Would be nice to see an actual patch that does the revert.

Thanks,

	Ingo
