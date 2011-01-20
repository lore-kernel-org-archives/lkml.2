Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1ATONg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:13:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab1ATONe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:13:34 -0500
Date: Thu, 20 Jan 2011 15:11:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110120141143.GA17272@elte.hu>
References: <1295484358.15213.25.camel@yhuang-dev>
 <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
 <20110120121455.GA7680@elte.hu>
 <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
 <20110120130625.GA14436@elte.hu>
 <20110120133621.GA314@a1.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110120133621.GA314@a1.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> + Tony.
> 
> On Thu, Jan 20, 2011 at 02:06:25PM +0100, Ingo Molnar wrote:
> > 
> > * huang ying <huang.ying.caritas@gmail.com> wrote:
> > 
> > > On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > >
> > > > * huang ying <huang.ying.caritas@gmail.com> wrote:
> > > >
> > > >> > But will all that stuff be accepted? Please stop sending infrastructure bits and
> > > >> > focus on your larger RAS picture, once you have consensus on that from all
> > > >> > parties involved, then, and only then, does it make sense to submit everything,
> > > >> > including infrastructure.
> > > >>
> > > >> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
> > > >> and Andrew suggest to use printk for hardware error reporting.  And now, I just
> > > >> try to write APEI driver and reporting hardware error with printk.  Is it
> > > >> acceptable?  Do you have some other idea about hardware error reporting?
> > > >
> > > > Erm, how could you possible have missed the perf based RAS daemon work of Boris,
> > > > which we've pointed out about half a dozen times already?
> > > 
> > > Even if there is some other hardware error reporting infrastructure
> > > such as perf based, I think we still need printk too. After all, as
> > > Linus pointed out, printk is the most popular error reporting
> > > mechanism so far. Do you think so?
> > 
> > Of course, that's why the upstream EDAC code uses printk too. In fact it does all 
> > sorts of in-kernel decoding to make the printk output more useful - the /dev/mcelog 
> > method of pushing all decoding to user-space is fundamentally flawed.
> 
> True story. And yet google folk still do that, unfortunately:
> https://lkml.org/lkml/2011/1/10/419

I wouldnt worry about that too much - such uses are extremely isolated.

If we give RAS functionality that gives the limited capabilities of /dev/mcelog and 
much more then the migration path is clear towards the superior solution.

Thanks,

	Ingo
