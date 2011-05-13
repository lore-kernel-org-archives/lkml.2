Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab1EMKEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:04:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:54418 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab1EMKEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:04:33 -0400
Date: Fri, 13 May 2011 12:04:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
In-Reply-To: <20110513092646.GK13647@elte.hu>
Message-ID: <alpine.LFD.2.02.1105131203090.2831@ionos>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au> <20110513080634.GA13647@elte.hu> <20110513083738.GA19733@n2100.arm.linux.org.uk> <20110513092646.GK13647@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Ingo Molnar wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Fri, May 13, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
> > > 
> > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Today's linux-next merge of the tip tree got a conflict in 
> > > > arch/x86/kernel/i8253.c between commit 3490f584b9ba ("clocksource: convert 
> > > > x86 to generic i8253 clocksource") from the arm tree and commit b01cc1b0eae0 
> > > > ("x86: Convert remaining x86 clocksources to clocksource_register_hz/khz") 
> > > > from the tip tree.
> > > > 
> > > > The former seems to supercede the latter, so I used the former.
> > > 
> > > Russell, how the heck did this commit:
> > > 
> > >  commit 3490f584b9ba5a0b6f63832fbc9c5ec72506697b
> > >  Author:     Russell King <rmk+kernel@arm.linux.org.uk>
> > >  AuthorDate: Sun May 8 18:55:19 2011 +0100
> > >  Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
> > >  CommitDate: Tue May 10 08:20:54 2011 +0100
> > > 
> > >     clocksource: convert x86 to generic i8253 clocksource
> > > 
> > > which has such a clearly x86 diffstat:
> > > 
> > >  arch/x86/Kconfig             |    1 +
> > >  arch/x86/include/asm/i8253.h |    2 +
> > >  arch/x86/kernel/i8253.c      |   79 +-----------------------------------------
> > >  3 files changed, 4 insertions(+), 78 deletions(-)
> > > 
> > > end up in the ARM tree without an ack from an x86 maintainer??
> > 
> > The "no response" means two things: either that people are busy, [...]
> 
> Had you asked us before committing it one day after it was posted, or had you 
> *noticed* that those files are not in your tree and are already modified in 
> linux-next, you'd have gotten a response like:
> 
> --------------->
> 
> Yes, the change looks good to me as well in principle. Thomas is busy this 
> week, he is on a conference.

I saw it and missed it to reply, sorry.
 
> Guys if you want to do this outside of the x86 tree please test this series
> thoroughly on x86 as well before pushing it out anywhere permanent or pushing
> it into linux-next.
> 
> Also note that there's also some pending changes in the x86 tree modifying
> arch/x86/kernel/i8253.c:
> 
>   b01cc1b0eae0: x86: Convert remaining x86 clocksources to clocksource_register_hz/khz
> 
> If you want to do any further change to this file you need to pull in this 
> change first or need to resolve the conflict in some other way.

If it makes things easier I can pull it through the tip/timers/.... as
well. Just let me know.

Thanks,

	tglx
