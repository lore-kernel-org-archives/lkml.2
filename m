Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1JYWoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:44:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36438 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1JYWoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:44:54 -0400
Message-ID: <1319582670.17505.31.camel@work-vm>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Ruben Kerkhof <ruben@rubenkerkhof.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Faidon Liambotis <paravoid@debian.org>
Date: Tue, 25 Oct 2011 15:44:30 -0700
In-Reply-To: <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
References: <1310690138.3367.61.camel@work-vm>
	 <1310724097.2586.296.camel@twins> <1310752795.2945.4.camel@work-vm>
	 <20110721072256.GE9216@elte.hu> <1311251098.29152.130.camel@twins>
	 <20110721125008.GF11246@pcnci.linuxbox.cz>
	 <1311252799.29152.147.camel@twins> <20110721184524.GB381@elte.hu>
	 <20110825185616.GA17078@faidon.noc.grnet.gr>
	 <20110830223829.GB17450@kroah.com> <20110904232657.GC6749@tty.gr>
	 <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11102522-5930-0000-0000-00000092F520
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 20:31 +0200, Ruben Kerkhof wrote:
> On Mon, Sep 5, 2011 at 01:26, Faidon Liambotis <paravoid@debian.org> wrote:
> > On Tue, Aug 30, 2011 at 03:38:29PM -0700, Greg KH wrote:
> >> On Thu, Aug 25, 2011 at 09:56:16PM +0300, Faidon Liambotis wrote:
> >> > On Thu, Jul 21, 2011 at 08:45:25PM +0200, Ingo Molnar wrote:
> >> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> >> > >
> >> > > > On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> >> > > > > thanks for the patch! I'll put this on our testing boxes...
> >> > > >
> >> > > > With a patch that frobs the starting value close to overflowing I hope,
> >> > > > otherwise we'll not hear from you in like 7 months ;-)
> >> > > >
> >> > > > > Are You going to push this upstream so we can ask Greg to push this to
> >> > > > > -stable?
> >> > > >
> >> > > > Yeah, I think we want to commit this with a -stable tag, Ingo?
> >> > >
> >> > > yeah - and we also want a Reported-by tag and an explanation of how
> >> > > it can crash and why it matters in practice. I can then stick it into
> >> > > the urgent branch for Linus. (probably will only hit upstream in the
> >> > > merge window though.)
> >> >
> >> > Has this been pushed or has the problem been solved somehow? Time is
> >> > against us on this bug as more boxes will crash as they reach 200 days
> >> > of uptime...
> >> >
> >> > In any case, feel free to use me as a Reported-by, my full report of the
> >> > problem being <20110430173905.GA25641@tty.gr>.
> >> >
> >> > FWIW and if I understand correctly, my symptoms were caused by *two*
> >> > different bugs:
> >> > a) the 54 bits wraparound at 208 days that Peter fixed above,
> >> > b) a kernel crash at ~215 days related to RT tasks, fixed by
> >> > 305e6835e05513406fa12820e40e4a8ecb63743c (already in -stable).
> >>
> >> So, what do I do here as part of the .32-longterm kernel?  Is there a
> >> fix that is in Linus's tree that I need to apply here?
> >>
> >> confused,
> >
> > Is this even pushed upstream? I checked Linus' tree and the proposed
> > patch is *not* merged there. I'm not really sure if it was fixed some
> > other way, though. I thought this was intended to be an "urgent" fix or
> > something?
> >
> > Regards,
> > Faidon
> 
> I just had two crashes on two different machines, both with an uptime
> of 208 days.
> Both were 5520's running 2.6.34.8, but with a CONFIG_HZ of 1000
> 
> 2011-10-23T16:49:18.618029+02:00 phy001 kernel: BUG: soft lockup -
> CPU#0 stuck for 17163091968s! [qemu-kvm:16949]

So were these actual crashes, or just softlockup false positives?

I had thought the earlier crash issue (div by zero) fix from PeterZ had
been already pushed upstream, but maybe that was just against 2.6.32 and
not 2.6.33?

The softlockup false positive issue should have been fixed by Peter's
"x86, intel: Don't mark sched_clock() as stable" below. But I'm not
seeing it upstream.  Peter, is this still the right fix?

thanks
-john


From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: x86, intel: Don't mark sched_clock() as stable

Because the x86 sched_clock() implementation wraps at 54 bits and the
scheduler code assumes it wraps at the full 64bits we can get into
trouble after 208 days (~7 months) of uptime. 

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..c8dc48b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -91,8 +91,15 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
        if (c->x86_power & (1 << 8)) {
                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+               /*
+                * Unfortunately our __cycles_2_ns() implementation makes
+                * the raw sched_clock() interface wrap at 54-bits, which
+                * makes it unsuitable for direct use, so disable this
+                * for now.
+                *
                if (!check_tsc_unstable())
                        sched_clock_stable = 1;
+                */
        }
 
        /*



