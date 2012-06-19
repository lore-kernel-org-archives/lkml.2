Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2FSMOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:14:30 -0400
Received: from linux-sh.org ([111.68.239.195]:39363 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab2FSMOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:14:03 -0400
Date: Tue, 19 Jun 2012 21:13:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Makefile: fix up CROSS_COMPILE and READABLE_ASM
 interaction.
Message-ID: <20120619121337.GA5623@linux-sh.org>
References: <20120618045500.GC19803@linux-sh.org>
 <CAMuHMdU5juQMyzoTV62-hwzKW980fkQNDBKGP8i5WfDcsf95jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU5juQMyzoTV62-hwzKW980fkQNDBKGP8i5WfDcsf95jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:17:59AM +0200, Geert Uytterhoeven wrote:
> On Mon, Jun 18, 2012 at 6:55 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > (Apologies for the re-send, forgot to Cc linux-kernel)
> >
> > When the READABLE_ASM cc-option tests were added they were done so prior
> > to the arch Makefile include, resulting in cc-option being run on the
> > host cc instead of the factoring in the cross prefix set up by the
> > architecture.
> >
> > This bumps the include back up so that cc-option actually runs on the
> > compiler that we're building with.
> 
> I find it a real pity these reported, hard to investigate, and fixed
> build issues keep
> flowing into mainline, without the corresponding fix...
> 
> https://lkml.org/lkml/2012/5/12/36
> 
Agreed. These one-off things are always a nuisance, and often fall
through the cracks. I've yet to find a good solution for them, although
having them rolled in to -next helps.

In this case I got bit by -fno-partial-inlining instead, and since you
didn't have READABLE_ASM in the subject I missed your patch entirely. In
retrospect I should have searched for cc-option. At least we've now both
scratched our heads and come up with an identical fix independently,
which counts a lot more than a Tested-by ;-)

