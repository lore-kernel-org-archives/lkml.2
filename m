Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1BHT6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:58:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46368 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1BHT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:58:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110131225939.GH11974@redhat.com>
	<20110203094715.939C.A69D9226@jp.fujitsu.com>
	<20110203020528.GA21603@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
	<m14o8klt3w.fsf@fess.ebiederm.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
	<20110208164656.GA29081@redhat.com> <m1ei7i8m5o.fsf@fess.ebiederm.org>
	<20110208192756.GB29081@redhat.com>
Date: Tue, 08 Feb 2011 11:58:05 -0800
In-Reply-To: <20110208192756.GB29081@redhat.com> (Vivek Goyal's message of
	"Tue, 8 Feb 2011 14:27:56 -0500")
Message-ID: <m1r5bi5meq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bBsibC+UCpay2KjEJjWBoCAt7LkQ/ipM=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Query about kdump_msg hook into crash_kexec()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Feb 08, 2011 at 09:35:15AM -0800, Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
>> >> Hi Eric,
>> >> 
>> >> Thank you for your prompt reply.
>> >> 
>> >> I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
>> >> 
>> >> (1) Needs in enterprise area
>> >>   In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
>> >>   for detecting root cause of kernel crash.
>> >> 
>> >> (2) Implementation of kmsg_dump 
>> >>   You suggest to review/test cording of kmsg_dump() more.
>> >> 
>> >> What do you think about (1)?
>> >> Is it acceptable for you?
>> >
>> > Ok, I am just trying to think loud about this problem and see if something
>> > fruitful comes out which paves the way forward.
>> >
>> > - So ideally we would like kdump_msg() to be called after crash_kexec() so
>> >   that any unaudited (third party modules), unreliable calls do not 
>> >   compromise the realiability of kdump operation.
>> >
>> >   But hitachi folks seems to be wanting to save atleast kernel buffers
>> >   somwhere in the NVRAM etc because they think that kdump can be
>> >   unreliable and we might not capture any information after the crash. So
>> >   they kind of want two mechanisms in place. One is light weight which
>> >   tries to save kernel buffers in NVRAM and then one heavy weight one
>> >   which tries to save the entire/filtered kernel core.
>> >
>> >   Personally I am not too excited about the idea but I guess I can live
>> >   with it. We can try to audit atleast in kernel module and for external
>> >   modules we don't have much control and live with the fact that if
>> >   modules screw up, we don't capture the dump.
>> >
>> >  Those who don't want this behavior can do three things.
>> >
>> > 	- Disable kdump_msg() at compile time.
>> > 	- Do not load any module which registers for kdump_msg()
>> > 	- Implement a /proc tunable which allows controlling this
>> > 	  behavior.
>> >
>> > - Ok, having said why do we want it, comes the question of how to  
>> >   do it so that it works reasonably well.
>> >
>> >   - There seems to be on common requirement of kmsg_dump() and kdump()
>> >     and that is stop other cpus reliably (use nmi if possible). Can
>> >     we try to share this code between kmsg_dump and crash_kexec(). So
>> >     something like as follows.
>> >
>> > 	- panic happens
>> > 	- Do all the activities related to printing panic string and
>> > 	  stack dump.
>> > 	- Stop other cpus.
>> > 		- This can be probably be done with the equivalent of
>> > 		  machine_crash_shutdown() function. In fact this function
>> > 		  can probably be broken down in two parts. First part
>> > 	  	  does shutdown_prepare() where all other cpus are shot
>> > 		  down and second part can do the actual disabling of
>> > 		  LAPIC/IOAPIC and saving cpu registers etc.
>> >
>> > 		if (mutex_trylock(some_shutdown_mutex)) {
>> > 			/* setp regs, fix vmcoreinfo etc */
>> > 			crash_kexec_prepare();
>> > 			machine_shutdown_prepare();
>> > 			kdump_msg();	
>> > 			crash_kexec_execute()
>> > 			/* Also call panic_notifier_list here ? */
>> > 		}
>> >
>> > crash_kexec_prepare () {
>> > 		crash_setup_regs(&fixed_regs, regs);
>> > 		crash_save_vmcoreinfo();
>> > }
>> >
>> > crash_kexec_execute() {
>> > 			/* Shutdown lapic/ioapic, save this cpu register etc */
>> > 			machine_shutdown();
>> > 			machine_kexec()
>> > }
>> >
>> > So basically we break down machine_shutdown() function in two parts
>> > and start sharing common part between kdump_msg(), crash_kexec and
>> > possibly panic_notifiers. 
>> >
>> > If kdump is not configured, then after executing kdump_msg() and panic
>> > notifiers, we should either be sitting in tight loop with interrupt
>> > enabled for somebody to press Ctrl-boot or reboot system upon lapse
>> > of panic_timeout().
>> >
>> > Eric, does it make sense to you?
>> 
>> kexec on panic doesn't strictly require that we stop other cpus.
>
> Yes but it is desirable.
>
> - We don't want cpus to be scribbling on old memory and possibly on
>   new kernel's memory also in case of corrupted pointer and crash
>   the freshly booted kernel (New kerenl's memory is mapped in old
>   kernel)
>
> - We don't want other cpus to complete panic() and jump to BIOS or
>   lead to some kind of triple fault and reset the system etc.
>
> So that would suggest to be robust, stopping other cpus is required.
>
> On a side note, kdump_msg() hook is present in emergency_reboot() too.
> So if these paths are not properly designed, then system might not
> even reboot automatically even if panic_timeout() has been specified.

Ouch! Ouch! Ouch!

emergency_restart is just supposed to be the restart bits, so
that it always works!  We wouldn't need to use emergency restart
if we could trust the normal hardware shutdown code.  Sigh.

I guess this is another issue I have with the design of kmsg_dump.
Instead of being a good citizen like everyone else and placing their
hooks explicitly where they can be seen.  The kmsg_dump hooks were
buried in other routines changing the semantics of those routines.

What makes this scary is the modified routines are deliberately simple
so they are robust and can be audited and now on those code paths we
have the hooks that are so big everyone gives up before reading and
understanding all of the code involved.

>> What makes sense to me at this point is for someone on the kmsg_dump
>> side to make a strong case that the code actually works in a crash dump
>> scenario.  We have lots of experience over the years that says a design
>> like kmsg_dump is attractive but turns out to be a unreliable piece of
>> junk that fails just when you need it.  Because developers only test
>> the case when the kernel is happy and because people share code with
>> the regular path drivers, and that code assumes things are happy.
>> 
>> I forget exactly why but last I looked.
>> local_irq_disable()
>> kmsg_dump()
>> local_irq_enalbe()
>
> I agree that kdump_msg() code should be able to work with interrupts
> disabled, atleast. 
>
> There seem to be two pieces to it. One is generic call which calls
> all the dumpers and then respective dumpers.
>
> Looking at generic dumping call, I can't think why does it need interrupts
> to be enabled. There is one spin_lock() and then rcu_read_lock(). That's
> it.
>
> Regarding mtdoops, it is hard to tell. There is lot of code. But the good
> thing is that they have introduced a separate write path for panic context.
> That way atleast one can do special casing in panic path to avoid
> taking locks and not be dependent on interrupts.

I think that is part of my problem.   There is a lot of code so it is
really hard to audit, and really hard to trust.  I'm still leary with
the amount of code on the kexec on panic code path.

> ramoops seems to be simple. It seems to be just memcpy() except
> do_gettimeofday(). I noticed that in the past you raised concern about usage
> of do_gettimeofday(), but I am not sure what is the concern here (silly
> question i guess).
>
> So to me, ramoops seems to be simple memcpy (atleast in principle) and
> mtdoops has a dedicated path for handling panic context. So atleast
> it is fixable for possible issues. Generic code seems harmless to me
> at this point of time.
>  
>> 
>> Was a recipe for disaster, and you have be at least that good to even
>> have a chance of working in a crash dump scenario.
>> 
>> In part I am puzzled why the kmsg dump doesn't just use the printk
>> interface.  Strangely enough printk works in the event of a crash and
>> has been shown to be reliable over the years.
>
> Are you suggesting implementing these things as console driver and
> register with printk as console? Sounds interesting. I think one of
> the issues they probably will find that they don't want to log everything.
> They want to do selective logging. Not sure how would they get this
> info.
>
> In some cases like emergency_restart(), there are no printk() and they
> just consider it one of the events to dump the kernel buffer contents.

Sorry.  I am tired and I'm really not ready to deal with yet another
mechanism like this, that is over designed and was flaky the first time
I looked at it.  That flakiness combined with the authors not stepping
forward and rushing off to fix things or telling me they have fixed
things, means that I don't have any confidence in the mechanism.

Vivek if you want to step forward and be one of the people taking care
of kmsg_dump, then this conversation might have a point.

What I know for certain is that kmsg_dump and kexec on panic are
used in pretty exclusive ways, so getting the kmsg_dump code out
of crash_kexec does not hurt anyone today.

Right now I can't even get 2.6.38-rc4 to compile a reasonably sized
program, so I see a lot worse regressions to deal with than something
I can just avoid for now.

Eric
