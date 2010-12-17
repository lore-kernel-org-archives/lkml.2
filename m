Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LQQYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:24:48 -0500
Received: from www.tglx.de ([62.245.132.106]:53569 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0LQQYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:24:47 -0500
Date: Fri, 17 Dec 2010 17:22:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: huang ying <huang.ying.caritas@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        "Brown,Len" <len.brown@intel.com>, "Luck,Tony" <tony.luck@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH -mm -v8 0/3] Lockless memory allocator and list
In-Reply-To: <AANLkTi=6z1bw9iNi2hhDJaSnZVhBDOr_JDD2dAFYKqC_@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1012171649510.12146@localhost6.localdomain6>
References: <AANLkTi=6z1bw9iNi2hhDJaSnZVhBDOr_JDD2dAFYKqC_@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Fri, 17 Dec 2010, huang ying wrote:
> On Fri, Dec 17, 2010 at 8:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > I don't want to see a single line of code from you until you've talked
> > with other RAS folks and they agree that your bits make sense.
> >
> > So let me put it in simple words: unless there's a non-Intel RAS guy
> > signing off on your patches I'm objecting to them.
> 
> Please take a look at the patchset, this patchset is not RAS specific,
> it is not hardware error reporting infrastructure or hardware error
> reporting interface. This is just lock-less data structure. So this is
> not a RAS patchset. Why I must get non-Intel RAS guys' signing off for
> a non-RAS patchset?
>
> I will not post my original hardware error reporting infrastructure or
> interface after this patchset. Although I may use some part of this

There are _NO_ users of that new infrastructure. And we do _NOT_ merge
code which has no users and therefor no purpose just for fun. Period.

> patchset in APEI code, that is just driver internal data structure
> usage, not general hardware error reporting infrastructure or
> interface.

So you want to use it in APEI code, then post it when your APEI code
is ready, reviewed and mergeable, which requires the ack from the RAS
folks.

And stop reposting it _BEFORE_ you have at least tried to address
Peters other request:

>> > ... and no attempt to unify the existing lockless list implementations.

That's a reasonable request as we have already lockless list
implementations and adding another one is not of interest at all.

If you think your lockless list is superior, then replace the existing
implementations and convert the users or at least one of them. Then we
have a technical ground to discuss your new lockless list.

Thanks,

	tglx
