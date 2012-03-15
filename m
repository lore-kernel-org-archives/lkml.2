Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032351Ab2COVhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:37:41 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:53641 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032305Ab2COVhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:37:38 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 15 Mar 2012 17:37:29 -0400
Subject: RE: [PATCH] x86, kdump: No need to disable ioapic in crash path
Thread-Topic: [PATCH] x86, kdump: No need to disable ioapic in crash path
Thread-Index: Ac0C80lurNgzLeaiSAKVJLRgS4l/SwAAEGEQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E31C6F86C@USINDEVS01.corp.hds.com>
References: <1330546129-4812-1-git-send-email-dzickus@redhat.com>
 <20120315202652.GA13930@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2E31C6F859@USINDEVS01.corp.hds.com>
 <20120315213336.GB18218@redhat.com>
In-Reply-To: <20120315213336.GB18218@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=7 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203150235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

Thank you.
I understand.

Seiji

> -----Original Message-----
> From: Don Zickus [mailto:dzickus@redhat.com]
> Sent: Thursday, March 15, 2012 5:34 PM
> To: Seiji Aguchi
> Cc: x86@kernel.org; LKML; kexec-list; Eric W. Biederman; Vivek Goyal
> Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
> 
> On Thu, Mar 15, 2012 at 05:16:50PM -0400, Seiji Aguchi wrote:
> > Don,
> >
> > What do you think about following scenario?
> > Disabling I/O APIC seems to be needed before booting kdump kernel.
> 
> This patch was for *booting* the second kernel.  Kexec/kdump disables interrupts before jumping into the second kernel, so it
> doesn't matter what is done with the i/o apic as interrupts are blocked until the second kernel boots up and deals with them.
> 
> It is Suresh's patch that helps enable a patch like the one I proposed.
> 
> Cheers,
> Don
> 
> >
> > Seiji
> >
> >
> > commit 1e75b31d638d5242ca8e9771dfdcbd28a5f041df
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Thu Aug 25 12:01:11 2011 -0700
> >
> >     x86, kdump, ioapic: Reset remote-IRR in clear_IO_APIC
> >
> >     In the kdump scenario mentioned below, we can have a case where
> >     the device using level triggered interrupt will not generate any
> >     interrupts in the kdump kernel.
> >
> >     1. IO-APIC sends a level triggered interrupt to the CPU's local APIC.
> >
> >     2. Kernel crashed before the CPU services this interrupt, leaving
> >        the remote-IRR in the IO-APIC set.
> >
> >     3. kdump kernel boot sequence does clear_IO_APIC() as part of IO-APIC
> >        initialization. But this fails to reset remote-IRR bit of the
> >        IO-APIC RTE as the remote-IRR bit is read-only.
> >
> >     4. Device using that level triggered entry can't generate any
> >        more interrupts because of the remote-IRR bit.
> >
> >     In clear_IO_APIC_pin(), check if the remote-IRR bit is set and if
> >     so do an explicit attempt to clear it (by doing EOI write on
> >     modern io-apic's and changing trigger mode to edge/level on
> >     older io-apic's). Also before doing the explicit EOI to the
> >     io-apic, ensure that the trigger mode is indeed set to level.
> >     This will enable the explicit EOI to the io-apic to reset the
> >     remote-IRR bit.
> >
> >     Tested-by: Leonardo Chiquitto <lchiquitto@novell.com>
> >     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >     Fixes: https://bugzilla.novell.com/show_bug.cgi?id=701686
> >     Cc: Rafael Wysocki <rjw@novell.com>
> >     Cc: Maciej W. Rozycki <macro@linux-mips.org>
> >     Cc: Thomas Renninger <trenn@suse.de>
> >     Cc: jbeulich@novell.com
> >     Cc: yinghai@kernel.org
> >     Link: http://lkml.kernel.org/r/20110825190657.157502602@sbsiddha-desk.sc.intel.com
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > > -----Original Message-----
> > > From: linux-kernel-owner@vger.kernel.org
> > > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Don Zickus
> > > Sent: Thursday, March 15, 2012 4:27 PM
> > > To: x86@kernel.org
> > > Cc: LKML; kexec-list; Eric W. Biederman; Vivek Goyal
> > > Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash
> > > path
> > >
> > > On Wed, Feb 29, 2012 at 03:08:49PM -0500, Don Zickus wrote:
> > > > A customer of ours noticed when their machine crashed, kdump did
> > > > not work but hung instead.  Using their firmware dumping solution
> > > > they grabbed a vmcore and decoded the stacks on the cpus.  What
> > > > they noticed seemed to be a rare deadlock with the ioapic_lock.
> > >
> > > While we are discussing the NMI stuff in another thread, does anyone
> > > have any objection to committing this patch.  It fixes a real problem today.
> > >
> > > Cheers,
> > > Don
> > >
> > > >
> > > >  CPU4:
> > > >  machine_crash_shutdown
> > > >  -> machine_ops.crash_shutdown
> > > >     -> native_machine_crash_shutdown
> > > >        -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
> > > >        -> disable_IO_APIC
> > > >           -> clear_IO_APIC
> > > >              -> clear_IO_APIC_pin
> > > >                 -> ioapic_read_entry
> > > >                    -> spin_lock_irqsave(&ioapic_lock, flags)
> > > >                    ---Infinite loop here---
> > > >
> > > >  CPU0:
> > > >  do_IRQ
> > > >  -> handle_irq
> > > >     -> handle_edge_irq
> > > >         -> ack_apic_edge
> > > >            -> move_native_irq
> > > >                -> mask_IO_APIC_irq
> > > >                   -> mask_IO_APIC_irq_desc
> > > >                      -> spin_lock_irqsave(&ioapic_lock, flags)
> > > >                      ---Receive NMI here after getting spinlock---
> > > >                         -> nmi
> > > >                            -> do_nmi
> > > >                               -> crash_nmi_callback
> > > >                               ---Infinite loop here---
> > > >
> > > > The problem is that although kdump tries to shutdown minimal
> > > > hardware, it still needs to disable the IO APIC.  This requires
> > > > spinlocks which may be held by another cpu.  This other cpu is
> > > > being held infinitely in an NMI context by kdump in order to serialize the crashing path.
> > > > Instant deadlock.
> > > >
> > > > Eric, brought up a point that because the boot code was
> > > > restructured we may not need to disable the io apic any more in the crash path.
> > > > The original concern that led to the development of
> > > > disable_IO_APIC, was that the jiffies calibration on boot up
> > > > relied on the PIT timer for reference.  Access to the PIT required
> > > > 8259 interrupts to be working.  This wouldn't work if the ioapic needed to be configured.
> > > > So on panic path, the ioapic was reconfigured to use virtual wire mode to allow the 8259 to passthrough.
> > > >
> > > > Those concerns don't hold true now, thanks to the jiffies
> > > > calibration code not needing the PIT.  As a result, we can remove
> > > > this call and simplify the locking needed in the panic path.
> > > >
> > > > I tested kdump on an Ivy Bridge platform, a Pentium4 and an old
> > > > athlon that did not have an ioapic.  All three were successful.
> > > >
> > > > I also tested using lkdtm that would use jprobes to panic the
> > > > system when entering do_IRQ.  The idea was to see how the system
> > > > reacted with an interrupt pending in the second kernel.  My core2
> > > > quad successfully kdump'd
> > > > 3 times in a row with no issues.
> > > >
> > > > v2: removed the disable lapic code too
> > > > v3: re-add disabling of lapic code
> > > >
> > > > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > > > Cc: Vivek Goyal <vgoyal@redhat.com>
> > > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > > ---
> > > >
> > > > There are really two problems here.  One is the deadlock of the
> > > > ioapic_lock that I describe above.  Removing the code to disable
> > > > the ioapic seems to resolve that.
> > > >
> > > > The second issue is handling non-IRQ exceptions like NMIs.  Eric
> > > > asked me to include removing the disable lapic code too.  However,
> > > > because the nmi watchdog is stil active and kexec zeros out the
> > > > idt before it jumps to purgatory, an NMI that comes in during the
> > > > transition between the first kernel and second kernel will see an empty idt and reset the cpu.
> > > >
> > > > Leaving the code to disable the lapic in, turns off perf and
> > > > blocks those NMIs from happening (though an external NMI would
> > > > still be an issue but that is no different than right now).
> > > >
> > > > I tried playing with a stub idt and leaving it in place through
> > > > the transition to the second kernel, but I can't quite get it to
> > > > work correctly.  Spinning in the first kernel before the purgatory
> > > > jump catches the idt properly.  Spinning in purgatory before the
> > > > second kernel jump doesn't.  I even disabled the zero'ing out of the idt in the purgatory code.
> > > >
> > > > I would like to get resolution on the ioapic deadlock to fix a
> > > > customer issue while working the idt and NMI thing on the side,
> > > > hence the split of this patchset.
> > > >
> > > > Hopefully, people recognize there are two issues here and that
> > > > this patch resolves the first one and the second one needs more debugging and time.
> > > > ---
> > > >  arch/x86/kernel/crash.c |    3 ---
> > > >  1 files changed, 0 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> > > > index
> > > > 13ad899..b053cf9 100644
> > > > --- a/arch/x86/kernel/crash.c
> > > > +++ b/arch/x86/kernel/crash.c
> > > > @@ -96,9 +96,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
> > > >  	cpu_emergency_svm_disable();
> > > >
> > > >  	lapic_shutdown();
> > > > -#if defined(CONFIG_X86_IO_APIC)
> > > > -	disable_IO_APIC();
> > > > -#endif
> > > >  #ifdef CONFIG_HPET_TIMER
> > > >  	hpet_disable();
> > > >  #endif
> > > > --
> > > > 1.7.7.6
> > > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
