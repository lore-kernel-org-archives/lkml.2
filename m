Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1CZMe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 08:34:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39049 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1CZMez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=TbtE4f9sYDgq4fW1aqaWzPH1l/LKYnnJuLRdSgJ0VWj0GId+107dyH0LZmvtXoMz/d
         MOrpoft6rfZOb4XXKkEKrut9Zno7JHlkDR/8uWWPx5qA9v8elGjWEX+9PWmphiW2E4wW
         xp8m2csTWFoLgblkvLESaWeL8RwS/p+7je5n0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110326034210.GX2322@linux.vnet.ibm.com>
References: <AANLkTimg-DVXUOrrRZCggZiaajSJWi=onWUxUrnnGXQB@mail.gmail.com>
	<AANLkTima-bYDkHDfSSAGJFmeRedBQ-VyaAdE7gfhHb3J@mail.gmail.com>
	<20110325155516.GA27484@feather>
	<20110325164236.GP2322@linux.vnet.ibm.com>
	<AANLkTim08Ff==7mY9fuU8tUJrTmEhZ+PrsJSQO5PKOH6@mail.gmail.com>
	<AANLkTi=N6Z0bDg1YXVFkUbv7phM8XvQ5U3=vS6Ej8Af5@mail.gmail.com>
	<20110325174855.GR2322@linux.vnet.ibm.com>
	<AANLkTin9HxOTwavbtbsMd0quYsEvhDNmuO5kOpquqoF=@mail.gmail.com>
	<20110326034210.GX2322@linux.vnet.ibm.com>
Date: Sat, 26 Mar 2011 13:34:53 +0100
Message-ID: <AANLkTi=zJZ26i14D-kyWQ1uqUPifrv+DN4So4+fC5V=d@mail.gmail.com>
Subject: Re: linux-next: Tree for March 25 (Call trace: RCU|workqueues|block|VFS|ext4
 related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 4:42 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Mar 25, 2011 at 08:42:14PM +0100, Sedat Dilek wrote:
>> On Fri, Mar 25, 2011 at 6:48 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Fri, Mar 25, 2011 at 06:40:38PM +0100, Sedat Dilek wrote:
>> >> On Fri, Mar 25, 2011 at 5:51 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> >> > On Fri, Mar 25, 2011 at 5:42 PM, Paul E. McKenney
>> >> > <paulmck@linux.vnet.ibm.com> wrote:
>> >> >> On Fri, Mar 25, 2011 at 08:55:16AM -0700, Josh Triplett wrote:
>> >> >>> On Fri, Mar 25, 2011 at 02:05:33PM +0100, Sedat Dilek wrote:
>> >> >>> > On Fri, Mar 25, 2011 at 11:16 AM, Sedat Dilek
>> >> >>> > <sedat.dilek@googlemail.com> wrote:
>> >> >>> > > right after I have finished building a new linux-next kernel, booting
>> >> >>> > > into desktop and archiving my build-tree (ext4) as tarball to an
>> >> >>> > > external USB harddisk (partition there is ext3).
>> >> >>> > > ( Yesterday, I have seen similiar call-traces in my logs, but it was
>> >> >>> > > hard to reproduce [1]. )
>> >> >>> > > I am unsure from where the problem aroses, if you have a hint, let me know.
>> >> >>> > >
>> >> >>> > > Regards,
>> >> >>> > > - Sedat -
>> >> >>> > >
>> >> >>> > > [1] http://lkml.org/lkml/2011/3/24/268
>> >> >>> > >
>> >> >>> > > P.S.: Attached are the dmesg outputs and my kernel-config
>> >> >>> > >
>> >> >>> >
>> >> >>> > I turned off the notebook for about 2hrs to avoid thermal problems and
>> >> >>> > hoax reports.
>> >> >>> > Jumped into desktop and started an archive job as 1st job while doing daily job.
>> >> >>> > Yeah, it is reproducible.
>> >> >>> [...]
>> >> >>> > [  212.453822] EXT3-fs (sdb5): mounted filesystem with ordered data mode
>> >> >>> > [  273.224044] INFO: rcu_sched_state detected stall on CPU 0 (t=15000 jiffies)
>> >> >>>
>> >> >>> 15000 jiffies matches this 60-second gap, assuming you use HZ=250.
>> >> >>>
>> >> >>> > [  273.224059] sending NMI to all CPUs:
>> >> >>> > [  273.224074] NMI backtrace for cpu 0
>> >> >>> > [  273.224081] Modules linked in: ext3 jbd bnep rfcomm bluetooth aes_i586 aes_generic binfmt_misc ppdev acpi_cpufreq mperf cpufreq_powersave cpufreq_userspace lp cpufreq_stats cpufreq_conservative fuse snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm radeon thinkpad_acpi snd_seq_midi pcmcia ttm snd_rawmidi snd_seq_midi_event drm_kms_helper yenta_socket snd_seq pcmcia_rsrc drm pcmcia_core joydev snd_timer snd_seq_device snd i2c_algo_bit tpm_tis shpchp i2c_i801 tpm nsc_ircc irda snd_page_alloc soundcore pci_hotplug rng_core i2c_core tpm_bios psmouse crc_ccitt nvram parport_pc pcspkr parport evdev battery video ac processor power_supply serio_raw button arc4 ecb ath5k ath mac80211 cfg80211 rfkill autofs4 ext4 mbcache jbd2 crc16 dm_mod usbhid hid usb_storage uas sg sd_mod sr_mod crc_t10dif cdrom ata_generic ata_piix libata uhci_hcd ehci_hcd usbcore scsi_mod thermal e1000 thermal_sys floppy [last unloaded: scsi_wait_scan]
>> >> >>> > [  273.224367]
>> >> >>> > [  273.224377] Pid: 0, comm: swapper Not tainted 2.6.38-next20110325-2-686-iniza #1 IBM 2374SG6/2374SG6
>> >> >>> > [  273.224397] EIP: 0060:[<c11514f0>] EFLAGS: 00000807 CPU: 0
>> >> >>> > [  273.224414] EIP is at delay_tsc+0x16/0x5e
>> >> >>> > [  273.224424] EAX: 00090d42 EBX: 00002710 ECX: c133faf5 EDX: 00090d41
>> >> >>> > [  273.224435] ESI: 00000000 EDI: 00090d42 EBP: f5819e9c ESP: f5819e8c
>> >> >>> > [  273.224445]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> >> >>> > [  273.224458] Process swapper (pid: 0, ti=f5818000 task=c13e3fa0 task.ti=c13b6000)
>> >> >>> > [  273.224466] Stack:
>> >> >>> > [  273.224472]  00090d41 00002710 c13ee580 c13ee600 f5819ea4 c115149f f5819eac c11514bb
>> >> >>> > [  273.224497]  f5819eb8 c1016532 c13ee580 f5819ed4 c1078dc1 c134e61e c134e6c2 00000000
>> >> >>> > [  273.224520]  00003a98 f5c03488 f5819ee8 c1078e36 00000000 00000000 c13e3fa0 f5819ef4
>> >> >>> > [  273.224544] Call Trace:
>> >> >>> > [  273.224559]  [<c115149f>] __delay+0x9/0xb
>> >> >>> > [  273.224571]  [<c11514bb>] __const_udelay+0x1a/0x1c
>> >> >>> > [  273.224590]  [<c1016532>] arch_trigger_all_cpu_backtrace+0x50/0x62
>> >> >>> > [  273.224608]  [<c1078dc1>] check_cpu_stall+0x58/0xb8
>> >> >>> > [  273.224622]  [<c1078e36>] __rcu_pending+0x15/0xc4
>> >> >>> > [  273.224637]  [<c10791df>] rcu_check_callbacks+0x6d/0x93
>> >> >>> > [  273.224652]  [<c1039c6c>] update_process_times+0x2d/0x58
>> >> >>> > [  273.224666]  [<c10509e9>] tick_sched_timer+0x6b/0x9a
>> >> >>> > [  273.224682]  [<c1047196>] __run_hrtimer+0x9c/0x111
>> >> >>> > [  273.224694]  [<c105097e>] ? tick_sched_timer+0x0/0x9a
>> >> >>> > [  273.224708]  [<c1047b38>] hrtimer_interrupt+0xd6/0x1bb
>> >> >>> > [  273.224727]  [<c104fca1>] tick_do_broadcast.constprop.4+0x38/0x6a
>> >> >>> > [  273.224741]  [<c104fd80>] tick_handle_oneshot_broadcast+0xad/0xe1
>> >> >>> > [  273.224757]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.224772]  [<c1004215>] timer_interrupt+0x15/0x1c
>> >> >>> > [  273.224785]  [<c107536d>] handle_irq_event_percpu+0x4e/0x164
>> >> >>> > [  273.224799]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.224811]  [<c10754b9>] handle_irq_event+0x36/0x51
>> >> >>> > [  273.224824]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.224837]  [<c1076d0f>] handle_level_irq+0x4d/0x63
>> >> >>> > [  273.224845]  <IRQ>
>> >> >>> > [  273.224857]  [<c1003b8d>] ? do_IRQ+0x35/0x80
>> >> >>> > [  273.224871]  [<c12ac0f0>] ? common_interrupt+0x30/0x38
>> >> >>> > [  273.224886]  [<c10400d8>] ? destroy_worker+0x52/0x6c
>> >> >>> > [  273.224922]  [<f87b730f>] ? arch_local_irq_enable+0x5/0xb [processor]
>> >> >>> > [  273.224947]  [<f87b7ef5>] ? acpi_idle_enter_simple+0x100/0x138 [processor]
>> >> >>> > [  273.224964]  [<c11ebd92>] ? cpuidle_idle_call+0xc2/0x137
>> >> >>> > [  273.224978]  [<c1001da3>] ? cpu_idle+0x89/0xa3
>> >> >>> > [  273.224995]  [<c128c26c>] ? rest_init+0x58/0x5a
>> >> >>> > [  273.225008]  [<c1418722>] ? start_kernel+0x315/0x31a
>> >> >>> > [  273.225022]  [<c14180a2>] ? i386_start_kernel+0xa2/0xaa
>> >> >>> > [  273.225029] Code: e5 e8 d6 ff ff ff 5d c3 55 89 e5 8d 04 80 e8 c9 ff ff ff 5d c3 55 89 e5 57 89 c7 56 53 52 64 8b 35 04 20 47 c1 8d 76 00 0f ae e8 <e8> 6b ff ff ff 89 c3 8d 76 00 0f ae e8 e8 5e ff ff ff 89 c2 29
>> >> >>> > [  273.225154] Call Trace:
>> >> >>> > [  273.225166]  [<c115149f>] __delay+0x9/0xb
>> >> >>> > [  273.225178]  [<c11514bb>] __const_udelay+0x1a/0x1c
>> >> >>> > [  273.225192]  [<c1016532>] arch_trigger_all_cpu_backtrace+0x50/0x62
>> >> >>> > [  273.225207]  [<c1078dc1>] check_cpu_stall+0x58/0xb8
>> >> >>> > [  273.225220]  [<c1078e36>] __rcu_pending+0x15/0xc4
>> >> >>> > [  273.225234]  [<c10791df>] rcu_check_callbacks+0x6d/0x93
>> >> >>> > [  273.225247]  [<c1039c6c>] update_process_times+0x2d/0x58
>> >> >>> > [  273.225260]  [<c10509e9>] tick_sched_timer+0x6b/0x9a
>> >> >>> > [  273.225274]  [<c1047196>] __run_hrtimer+0x9c/0x111
>> >> >>> > [  273.225286]  [<c105097e>] ? tick_sched_timer+0x0/0x9a
>> >> >>> > [  273.225300]  [<c1047b38>] hrtimer_interrupt+0xd6/0x1bb
>> >> >>> > [  273.225316]  [<c104fca1>] tick_do_broadcast.constprop.4+0x38/0x6a
>> >> >>> > [  273.225330]  [<c104fd80>] tick_handle_oneshot_broadcast+0xad/0xe1
>> >> >>> > [  273.225345]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.225358]  [<c1004215>] timer_interrupt+0x15/0x1c
>> >> >>> > [  273.225370]  [<c107536d>] handle_irq_event_percpu+0x4e/0x164
>> >> >>> > [  273.225384]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.225396]  [<c10754b9>] handle_irq_event+0x36/0x51
>> >> >>> > [  273.225409]  [<c1076cc2>] ? handle_level_irq+0x0/0x63
>> >> >>> > [  273.225421]  [<c1076d0f>] handle_level_irq+0x4d/0x63
>> >> >>> > [  273.225429]  <IRQ>  [<c1003b8d>] ? do_IRQ+0x35/0x80
>> >> >>> > [  273.225450]  [<c12ac0f0>] ? common_interrupt+0x30/0x38
>> >> >>> > [  273.225464]  [<c10400d8>] ? destroy_worker+0x52/0x6c
>> >> >>> > [  273.225493]  [<f87b730f>] ? arch_local_irq_enable+0x5/0xb [processor]
>> >> >>> > [  273.225517]  [<f87b7ef5>] ? acpi_idle_enter_simple+0x100/0x138 [processor]
>> >> >>> > [  273.225532]  [<c11ebd92>] ? cpuidle_idle_call+0xc2/0x137
>> >> >>> > [  273.225545]  [<c1001da3>] ? cpu_idle+0x89/0xa3
>> >> >>> > [  273.225559]  [<c128c26c>] ? rest_init+0x58/0x5a
>> >> >>> > [  273.225571]  [<c1418722>] ? start_kernel+0x315/0x31a
>> >> >>> > [  273.225584]  [<c14180a2>] ? i386_start_kernel+0xa2/0xaa
>> >> >>>
>> >> >>> Interesting.  Looks like RCU detected a stall while the CPU sits in
>> >> >>> cpu_idle.  That *shouldn't* happen...
>> >> >>
>> >> >> There have been a few of these things recently that turned out to
>> >> >> be BIOS misconfigurations, though that would not be the first thing
>> >> >> I would suspect if the system had run other versions successfully.
>> >> >> Another possibility is that the CPU spent the full time in interrupt.
>> >> >> Get an interrupt from the idle loop, stay in interrupt for 60 seconds,
>> >> >> get an RCU CPU stall warning.
>> >> >>
>> >> >> Or I could have somehow inserted a bug in RCU.  But I am not seeing
>> >> >> this in my testing.
>> >> >>
>> >> >>                                                        Thanx, Paul
>> >> >>
>> >> >
>> >> > The problems started when I first saw CONFIG_RCU_CPU_STALL_TIMEOUT=60
>> >> > in my configs.
>> >> >
>> >> > This an old IBM T40p notebook with Pentium-M (Banias) UP processor.
>> >> > IIRC I have flashed the latest BIOS available for this notebook.
>> >> >
>> >> > [   11.786073] thinkpad_acpi: ThinkPad BIOS 1RETDRWW (3.23 ), EC 1RHT71WW-3.04
>> >> > [   11.786111] thinkpad_acpi: IBM ThinkPad T40p, model 2374SG6
>> >> >
>> >> > As I am still sitting in the dark, it would be very helpful to know if
>> >> > I can play with HZ or RCU kernel-config parameters.
>> >> > Can I change RCU behaviour from user-space?
>> >> >
>> >> > - Sedat -
>> >> >
>> >> > P.S.: Note to myself: Read Documentation/RCU/stallwarn.txt & check
>> >> > possible values in lib/Kconfig.debug
>> >> >
>> >>
>> >> OK, I had a deeper look at the RCU (STALL) kernel-configs.
>> >>
>> >> $ grep RCU /boot/config-2.6.38-next20110323-3-686-iniza | grep STALL
>> >> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
>> >>
>> >> $ grep RCU /boot/config-2.6.38-next20110324-2-686-iniza | grep STALL
>> >> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
>> >>
>> >> $ grep RCU /boot/config-2.6.38-next20110325-2-686-iniza | grep STALL
>> >> CONFIG_RCU_CPU_STALL_TIMEOUT=60
>> >
>> > Yep, you moved from a kernel version that had the stall detected disabled
>> > by default to one that enables it by default.
>> >
>> > But -next has had stall detection enabled by default for a good
>> > long time now.
>> >
>> >> With my todays (next-20110325) linux-next kernel I cannot work!
>> >> The yesterday call-traces could be indeed a different issue (I am
>> >> currently testing with the 2 patches from block-tree [1]).
>> >>
>> >> Now, I am building a new linux-next kernel with CONFIG_TREE_RCU=y as
>> >> recommended in Documentation/RCU/stallwarn.txt file.
>> >
>> > You had CONFIG_TREE_PREEMPT_RCU=y earlier?  Tiny RCU does not have
>> > a stall detector.
>> >
>> >                                                        Thanx, Paul
>> >
>> >> - Sedat -
>> >>
>> >> [1] http://lkml.org/lkml/2011/3/25/326
>> >
>>
>> No, and I have here SMP configured.
>> Yesterday's RCU and SMP kernel config settings:
>>
>> # egrep '_RCU|RCU_|_SMP' /boot/config-2.6.38-next20110324-2-686-iniza
>> CONFIG_X86_32_SMP=y
>> CONFIG_TREE_RCU=y
>> # CONFIG_PREEMPT_RCU is not set
>> # CONFIG_RCU_TRACE is not set
>> CONFIG_RCU_FANOUT=32
>> # CONFIG_RCU_FANOUT_EXACT is not set
>> CONFIG_RCU_FAST_NO_HZ=y
>> # CONFIG_TREE_RCU_TRACE is not set
>> CONFIG_USE_GENERIC_SMP_HELPERS=y
>> CONFIG_SMP=y
>> CONFIG_PM_SLEEP_SMP=y
>> CONFIG_HAVE_TEXT_POKE_SMP=y
>> CONFIG_SCSI_SAS_HOST_SMP=y
>> # CONFIG_SPARSE_RCU_POINTER is not set
>> # CONFIG_RCU_TORTURE_TEST is not set
>> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
>>
>> IIRC Tiny RCU and SMP bite each other?
>> So, what do you recommend for an UP processor machine?
>
> If you want RCU stall warnings, or if you are building an SMP kernel, it
> has to be either TREE_RCU or TREE_PREEMPT_RCU.  If you are on UP and don't
> care about RCU stall warnings, then either TINY_RCU or TINY_PREEMPT_RCU
> will work fine.
>
> I just saw your "Now, I am building a new linux-next kernel with
> CONFIG_TREE_RCU=y" and thought that you were hinting that you had
> been running with something other than TREE_RCU.
>
>> - Sedat -
>>

Just FYI: Changed to the following settings:

- Enable Preemptible Kernel (Low-Latency Desktop)
- Enable Preemptible tree-based hierarchical RCU
- Enable RCU priority boosting
- Reset RCU CPU stall timeout to default (60 seconds)

So far I see no RCU stalls in the logs and my system runs as expected.
( I have noticed here some "stalling" in the webbrowser, but I can do
my daily business. )

I am not sure what the change to PREEMPT exactly mean in the end.
( Let's work with this new kernel and carefully check for possible
side-effects. )
For example CONFIG_RCU_FAST_NO_HZ=y is now dropped, where the Kconfig
descriptive text says some words on better energy saving. For a
notebook this is no good.
I have also questions to some Kconfig dependencies, for example why I
can't select TREE_PREEMPT_RCU if CONFIG_PREEMPT_VOLUNTARY=y, etc.
Intended?
Maybe I collect all my askings in a separate email to RCU folks and ML
and do not disturb further people from other sub-trees.

I enjoyed to read the numerous docs in Documentation/RCU/ (and noticed
some typos as well).
The RCU folk gave the word "FAQ" a new meaning: Frequenty Asked
Questions & Q*uiz* :-).

Thanks for the helpful hints and explanations from the RCU folks!

- Sedat -

P.S.: Current RCU and HZ kernel-config settings

# grep RCU /boot/config-$(uname -r)
# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y

# grep _HZ /boot/config-$(uname -r)
CONFIG_NO_HZ=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250

- Sedat -
