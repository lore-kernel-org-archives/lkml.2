Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab1EMJ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:27:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032Ab1EMJ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:27:12 -0400
Date: Fri, 13 May 2011 11:26:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110513092646.GK13647@elte.hu>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
 <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513083738.GA19733@n2100.arm.linux.org.uk>
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, May 13, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
> > 
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi all,
> > > 
> > > Today's linux-next merge of the tip tree got a conflict in 
> > > arch/x86/kernel/i8253.c between commit 3490f584b9ba ("clocksource: convert 
> > > x86 to generic i8253 clocksource") from the arm tree and commit b01cc1b0eae0 
> > > ("x86: Convert remaining x86 clocksources to clocksource_register_hz/khz") 
> > > from the tip tree.
> > > 
> > > The former seems to supercede the latter, so I used the former.
> > 
> > Russell, how the heck did this commit:
> > 
> >  commit 3490f584b9ba5a0b6f63832fbc9c5ec72506697b
> >  Author:     Russell King <rmk+kernel@arm.linux.org.uk>
> >  AuthorDate: Sun May 8 18:55:19 2011 +0100
> >  Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
> >  CommitDate: Tue May 10 08:20:54 2011 +0100
> > 
> >     clocksource: convert x86 to generic i8253 clocksource
> > 
> > which has such a clearly x86 diffstat:
> > 
> >  arch/x86/Kconfig             |    1 +
> >  arch/x86/include/asm/i8253.h |    2 +
> >  arch/x86/kernel/i8253.c      |   79 +-----------------------------------------
> >  3 files changed, 4 insertions(+), 78 deletions(-)
> > 
> > end up in the ARM tree without an ack from an x86 maintainer??
> 
> The "no response" means two things: either that people are busy, [...]

Had you asked us before committing it one day after it was posted, or had you 
*noticed* that those files are not in your tree and are already modified in 
linux-next, you'd have gotten a response like:

--------------->

Yes, the change looks good to me as well in principle. Thomas is busy this 
week, he is on a conference.

Guys if you want to do this outside of the x86 tree please test this series
thoroughly on x86 as well before pushing it out anywhere permanent or pushing
it into linux-next.

Also note that there's also some pending changes in the x86 tree modifying
arch/x86/kernel/i8253.c:

  b01cc1b0eae0: x86: Convert remaining x86 clocksources to clocksource_register_hz/khz

If you want to do any further change to this file you need to pull in this 
change first or need to resolve the conflict in some other way.

Thanks,

	Ingo
