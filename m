Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1FOQPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:15:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1FOQPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:15:21 -0400
Date: Wed, 15 Jun 2011 18:15:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable region
Message-ID: <20110615161518.GA24948@elte.hu>
References: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com>
 <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com>
 <20110615135213.GA29493@sgi.com>
 <20110615155445.GC4096@elte.hu>
 <20110615160743.GA32008@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615160743.GA32008@sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> Hi Ingo,
> 
> On Wed, Jun 15, 2011 at 05:54:45PM +0200, Ingo Molnar wrote:
> > 
> > * Cliff Wickman <cpw@sgi.com> wrote:
> > 
> > > On Wed, Jun 15, 2011 at 12:05:17PM +0600, Rakib Mullick wrote:
> > > > On Wed, Jun 15, 2011 at 5:06 AM, Cliff Wickman <cpw@sgi.com> wrote:
> > > > > From: Cliff Wickman <cpw@sgi.com>
> > > > >
> > > > > Calling smp_processor_id() from within a preemptable region will issue
> > > > > a warning if DEBUG_PREEMPT is set.
> > > > >
> > > > > Diffed against 3.0.0-rc3
> > > > >
> > > > > Signed-off-by: Cliff Wickman <cpw@sgi.com>
> > > > > ---
> > > > > ?arch/x86/platform/uv/tlb_uv.c | ? ?2 ++
> > > > > ?1 file changed, 2 insertions(+)
> > > > >
> > > > > Index: linux/arch/x86/platform/uv/tlb_uv.c
> > > > > ===================================================================
> > > > > --- linux.orig/arch/x86/platform/uv/tlb_uv.c
> > > > > +++ linux/arch/x86/platform/uv/tlb_uv.c
> > > > > @@ -1334,7 +1334,9 @@ static ssize_t tunables_write(struct fil
> > > > >
> > > > > ? ? ? ?instr[count] = '\0';
> > > > >
> > > > > + ? ? ? preempt_disable(); /* avoid DEBUG_PREEMPT warning */
> > > > 
> > > > I think above code comment, "avoid DEBUG_PREEMPT warning" should be to
> > > > something more meaningful. It's a BUG, if smp_processor_id() is called
> > > > within preemptible context. So, we don't want to hit that BUG.
> > > 
> > > I agree that calling smp_processor_id() within a preemptible context is
> > > going to produce unpredictable results.  In this particular case we just
> > > need a valid cpu number so that we can find a per-cpu structure.
> > > That structure contains a reasonable (sanity-checking) limit to the value
> > > of the tunable that is being written.
> > 
> > So what happens if the code gets preempted away and this CPU is 
> > hotplugged away? You'll reference a CPU ID that does not exist 
> > anymore.
> 
> You're right of course. But we don't support CPU hotplug on the UV 
> hardware. There are enhancements needed in both the BIOS and Linux 
> (BAU and GRU among them). They are on our work queue.

But here you put in yet another roadblock.

Thanks,

	Ingo
