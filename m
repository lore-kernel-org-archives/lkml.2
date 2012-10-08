Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab2JHExk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 00:53:40 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47829 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2JHExg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 00:53:36 -0400
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c ) 
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c ) 
Thread-Index: Ac2XtaKjAY9xmLl5SKWHS2eo1CR+VwNWYvVA
Date: Mon, 8 Oct 2012 04:53:00 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.217.50.26]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q984rhta029546

Hi Suresh, 
Could you please update current status about these 2 files and patch?
I am not sure if I have answered your questions , if not ,feel free to let me know. 
This is my first time to submit patch to LKML, so what should I do next step ? 
About this patch , where needs to be enhanced ? 

Thanks very much!

-- Bob(LinBao Zhang)
HP linux kernel enginner

> -----Original Message-----
> From: Zhang, Lin-Bao (Linux Kernel R&D)
> Sent: 2012å¹´9æœˆ21æ—¥ 1:16
> To: 'Suresh Siddha'
> Cc: linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
> mingo@redhat.com; Croxon, Nigel; 'tglx@linutronix.de'; 'hpa@zytor.com';
> 'x86@kernel.org'; 'a.p.zijlstra@chello.nl'; 'jarkko.sakkinen@intel.com';
> 'joerg.roedel@amd.com'; 'agordeev@redhat.com'; 'yinghai@kernel.org';
> 'stable@kernel.org'
> Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
> interrupt during the time window between changing VT-d table base address
> and initializing these VT-d entries(smpboot.c and apic.c )
> 
> Hi suresh,
> 
> Thanks for your reply and review this patch.
> I also cc other maintainers of arch/x86/kernel/smpboot.c and
> arch/x86/kernel/apic/apic.c(getting them by get_maintainer.pl script,
> hopefully I have not disturbed many people , if yes ,sorry first)
> 
> 
> > -----Original Message-----
> > From: Suresh Siddha [mailto:suresh.b.siddha@intel.com]
> > Sent: 2012å¹´9æœˆ21æ—¥ 6:23
> > To: Zhang, Lin-Bao (Linux Kernel R&D)
> > Cc: linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
> > mingo@redhat.com; Croxon, Nigel
> > Subject: Re: [PATCH] fix x2apic defect that Linux kernel doesn't mask
> > 8259A interrupt during the time window between changing VT-d table
> > base address and initializing these VT-d entries
> >
> > On Wed, 2012-09-12 at 07:02 +0000, Zhang, Lin-Bao (ESSN-MCXS-Linux
> > Kernel
> > R&D) wrote:
> > > Hi all,
> > > This defect can be observed when the x2apic setting in BIOS is set
> > > to "auto" and the BIOS has virtual wire mode enabled on a power up.
> > > This defect was found on a 2.6.32 based kernel.
> >
> > I assume you are able to reproduce the issue with the latest kernel aswell?
> >
> In fact , this is what I want to further discussion. Thanks for your comments
> about 3.x on x2apic.
> We can only reproduce this issue on 2.6.x kernel, including RHEL6.1/6.2/6.3
> and sles11sp1, they are all of 2.6.xx series.
> In 3.x upstream series , we didn't reproduce this problem, I ever tested
> upstream version : 3.0.0 , 3.0.38 , 3.1.10 ,3.3.8,3.4.4, we can't reproduce it.
> But I don't think this can prove that 3.x.x doesn't have potential problem
> similar with 2.6.x .
> By reviewing the 3.x kernel source , I found that 3.xx source have the same
> design defect ,but we don't know why it doesn't trigger this problem as 2.6 ,
> maybe other part work around this issue , so welcome comments ,we need to
> know the real reason.
> Anyway , from 3.x.x kernel source , it still first change VT-d table base address ,
> after some time, linux kernel then initialize RTEs. So during the window ,
> present bit must 0.
> During this window slot , if a interrupt is coming , platform will check VT-d
> entry 's present bit is 0 , cause non-fatal error and send NMI to OS. By intel's
> ITP we can clearly watch this error is caused :
> 0x8000_0022_0000_00F1_0000_0000_0000_0000  -> [22] Bit 103:96: FR
> Fault Reason is 22h The Present (P) field in the IRTE entry corresponding to the
> interrupt_index of the interrupt request is Clear. (Appendix A Fault Reason
> Encodings)
> 
> In fact, this error is just non-fatal , if firmware designed well, it should depress
> this error , I think after some time, VT-d entry has been initialized successfully ,
> this error won't exist again.
> I think the direction for kernel source to avoid this problem regardless
> firmware is :
> a) mask all 8259A interrupt  -> b) create a new VT-d table ,and initialize all
> entries (RTEs)  -> c) take over BIOS's simple VT-d table by kernel's VT-d table
> base address --> d) unmask 8259A
> thus linux kernel can correctly handle interrupt. I think this should be safe.
> How do you think about it ?
> 
> 
> > What virtual wire mode is it?
> > Virtual wire mode-A (where the PIC output is connected to LINT0 of the
> > Local
> > APIC) doesn't go through interrupt-remapping and virtual wire mode-B
> > (where the PIC output is routed through the IO-APIC RTE) will be
> > completely disabled as all the BIOS setup IO-APIC RTE's are masked by
> > the Linux kernel from the time we enable interrupt-remapping to the
> > time IO-APIC RTE's are properly re-configured by the Linux kernel again.
> >
> > So I am at a loss to understand what is causing this.
> >
> Yeah , Virtual wire mob B need to use io-apic .
> If no io-apic , this issue will never occur.
> 
> 
> > >
> > > The kernel code (smpboot.c, apic.c) does not mask 8259A interrupts
> > > before changing and initializing the new VT-d table when x2apic
> > > virtual wire mode is enable on power up. The Linux Kernel expects
> > > virtual wire mode to be disabled when booting and enables it when
> > > interrupts are masked.
> > >
> > > The BIOS code builds a simple VT-d table on power up. While the
> > > Linux Kernel boots, it first builds an empty VT-d table and use it.
> > > After some time, the Linux Kernel then initializes the IO-APIC
> > > redirect table, and then initializes the VT-d entries. The window
> > > between initializing the redirect table and the VT-d entries, the
> > > 8259A interrupts are not masked. If an interrupt occurs in this
> > > window, the Linux Kernel will not find a valid entry for this
> > > interrupt. The kernel treats it to be a fatal error and panics. If
> > > the error never gets cleared, the Linux kernel continuously print this error:
> > > "NMI: IOCK error (debug interrupt?) for reason"
> >
> > Not sure why we get a NMI instead of a vt-d fault? Perhaps the vt-d
> > fault is also getting reported via NMI in this platform?
> >
> Yes, you are right.
> When VT-d entry is Present bit is 0 , it will cause platform non-fatal error , and
> platform will send NMI(NMI reason is IOCHK,you know NMI can have many
> reasons) .
> Because this non-fatal err exists forever , so platform will send NMI looply to
> OS , so OS will receive many NMI , so linux kernel will print looply
> "NMI: IOCK error (debug interrupt?)" , linux kernel can't do any other things.
> 
> Following is error messages : in 2.6.32 kernel , we always reproduce it every
> time( adding x2apic_phys is reasonable)
> 
> 
> ------------error logs: -------------------------------------------
> IOAPIC id 10 under DRHD base 0xace00000
> IOAPIC id 8 under DRHD base 0xa8000000
> IOAPIC id 0 under DRHD base 0xa8000000
> Enabled IRQ remapping in x2apic mode
> NMI: IOCK error (debug interrupt?)
> CPU 0
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted 2.6.32rhel6.2-Bob #1 HP ProLiant DL980
> G7
> RIP: 0010:[<ffffffff810de39e>]  [<ffffffff810de39e>]
> check_for_new_grace_period+0x2e/0xd0
> RSP: 0018:ffff880046003e40  EFLAGS: 00000082
> RAX: 0000000000000282 RBX: 0000000000000282 RCX: 0000000000000000
> RDX: fffffffffffffed4 RSI: ffff880046011400 RDI: ffffffff81aaf640
> RBP: ffff880046003e60 R08: 0000000000989680 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81aaf640
> R13: ffff880046011400 R14: 0000000000000100 R15: 0000000000000009
> FS:  0000000000000000(0000) GS:ffff880046000000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001a85000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88c7ebe4e000, task ffff88086b4694c0)
> Stack:
>  ffff880046011400 ffffffff81aaf640 0000000000000048 0000000000000100
> <0> ffff880046003eb0 ffffffff810dedb4 ffffffff81a8ebe0 ffffffff81ea2120 <0>
> ffff880046003e80 0000000000000001 ffffffff81a830c8 0000000000000048
> Call Trace:
>  <IRQ>
>  [<ffffffff810dedb4>] __rcu_process_callbacks+0x54/0x330
>  [<ffffffff810df0da>] rcu_process_callbacks+0x4a/0x50  [<ffffffff81072161>]
> __do_softirq+0xc1/0x1d0  [<ffffff100e75e>] ? timer_interrupt+0x1e/0x30
> [<ffffffff8100c24c>] call_softirq+0x1c/0x30  [<ffffffff8100de85>]
> do_softirq+0x65/0xa0  [<ffffffff81071f45>] irq_exit+0x85/0x90
> [<ffffffff814f4cf5>] do_IRQ+0x75/0xf0  [<ffffffff8100ba53>]
> ret_from_intr+0x0/0x11  <EOI>  [<ffffffff81c303ec>] ?
> enable_IR_x2apic+0x18a/0x221  [<ffffffff81c2e189>]
> native_smp_prepare_cpus+0x143/0x389
>  [<ffffffff81c1f740>] kernel_init+0x112/0x2f9  [<ffffffff8100c14a>]
> child_rip+0xa/0x20  [<ffffffff81c1f62e>] ? kernel_init+0x0/0x2f9
> [<ffffffff8100c140>] ? child_rip+0x0/0x20
> Code: e5 48 83 ec 20 48 89 1c 24 4c 89 64 24 08 4c 89 6c 24 10 4c 89 74 24
> 18 0f 1f 44 00 00 49 89 f5 9c 58 0f 1f 44 00 00 48 89 c3 fa <66> 0f 1f 44 00 00
> 31 d2 48 8b 87 c8 a0 00 00 48 39 46 08 74 6c
> NMI: IOCK error (debug interrupt?)
> 
> 
> 
> > Does your tested kernel has this fix?
> > commit 254e42006c893f45bca48f313536fcba12206418
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Mon Dec 6 12:26:30 2010 -0800
> >
> >     x86, vt-d: Quirk for masking vtd spec errors to platform error
> > handling logic
> >
> Let me take some time to research it, I think it seems that you would
> mask/depress VT-d spec errors( for example , The Present (P) field in the IRTE
> entry corresponding to the interrupt_index of the interrupt request is Clear.)
> But I think ,this is just disable error reporting or disable error handling. But in
> our machine , if we found this error , platform will send NMI to OS.
> Maybe other platform don't send NMI to OS.
> But for linux kernel , we need to assure no this error occur , not depress
> error(certainly, if error is non-fatal , we can depress it ; if fatal error , we must
> stop machine and restart).
> For OS , how to differ fatal and non-fatal error ?
> 
> > Will you be able to provide the failing kernel log so that I can
> > better understand the issue?
> >
> I have pasted error logs above , if you need all booting log , I can send it to
> public location ,and give you a link. I don't want to paste it all here, too long. :)
> Or need I submit a bug in bugzilla.kernel.org ?
> 
> 
> > thanks,
> > suresh
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
