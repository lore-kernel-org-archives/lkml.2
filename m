Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2BBMQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:16:04 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7405 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab2BBMP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:15:58 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz1433M1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYRM2G-02-6FU-02
X-M-MSG: 
Date: Thu, 2 Feb 2012 13:15:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: Dyweni - KVM <n2CpHSJnr4MP@dyweni.com>
CC: KVM <kvm@vger.kernel.org>, Qemu Devel <qemu-devel@nongnu.org>,
        Oprofile-List <oprofile-list@lists.sourceforge.net>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] general protection fault
Message-ID: <20120202121550.GT16322@erda.amd.com>
References: <3c9160646ba439b51b505543c0ac8275@pl1.haspere.com>
 <d3fcc9d3c5765250d0fcb6e9ee45d672@pl1.haspere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d3fcc9d3c5765250d0fcb6e9ee45d672@pl1.haspere.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dyweni,

On 17.01.12 23:22:29, Dyweni - KVM wrote:
>  I'm getting a very similar error when running oprofile on the 
>  host...same version of oprofile...
> 
> 
> 
>  general protection fault: 0000 [#1] PREEMPT SMP
>  CPU 5
>  Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 
>  vboxnetadp vboxnetflt vboxdrv nvidia(P)
> 
>  Pid: 1498, comm: oprofiled Tainted: P            
>  3.1.6-gentoo-20120114-0749 #1 MSI MS-7578/NF750-G55 (MS-7578)
>  RIP: 0010:[<ffffffff81093758>]  [<ffffffff81093758>] 
>  raw_notifier_chain_register+0x18/0x40
>  RSP: 0018:ffff88022ed4dbb8  EFLAGS: 00010206
>  RAX: 65526d6562574955 RBX: ffffffff8172b4b0 RCX: ffffffff81733ff8
>  RDX: 0000000000000000 RSI: ffffffff8172b4b0 RDI: ffffffff817ae968
>  RBP: ffff88022ed4dbb8 R08: ffffffff81734ef0 R09: 0000000000000000
>  R10: 00003ffffffff000 R11: 0000160000000000 R12: ffffffff81734ef0
>  R13: 000000000000e160 R14: ffffffff8172b520 R15: 0000000000000005
>  FS:  00007f7179020700(0000) GS:ffff88033fd40000(0000) 
>  knlGS:00000000f75a36c0
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000000000062a000 CR3: 0000000327cd8000 CR4: 00000000000006e0
>  DR0: 0000000000000001 DR1: 0000000000000002 DR2: 0000000000000001
>  DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process oprofiled (pid: 1498, threadinfo ffff88022ed4c000, task 
>  ffff880331635eb0)
>  Stack:
>   ffff88022ed4dbe8 ffffffff814fa020 ffff88022ed4dbe8 ffffffff81093dc0
>   000000000000e160 0000000000000000 ffff88022ed4dc48 ffffffff81470325
>   ffff88032a5724a8 0000000000000005 ffff88033fd40000 00000008810f95d0
>  Call Trace:
>   [<ffffffff814fa020>] register_cpu_notifier+0x20/0x40
>   [<ffffffff81093dc0>] ? register_die_notifier+0x20/0x30
>   [<ffffffff81470325>] nmi_setup+0x1d5/0x200
>   [<ffffffff8146e830>] ? event_buffer_release+0x50/0x50
>   [<ffffffff8146d109>] oprofile_setup+0x39/0xd0
>   [<ffffffff8146e890>] event_buffer_open+0x60/0xa0
>   [<ffffffff81119de0>] ? file_sb_list_add+0x50/0x60
>   [<ffffffff8111685e>] __dentry_open.clone.17+0x12e/0x330
>   [<ffffffff81117a2e>] nameidata_to_filp+0x4e/0x60
>   [<ffffffff81126ac2>] do_last+0x1b2/0x8f0
>   [<ffffffff81127313>] path_openat+0xd3/0x3c0
>   [<ffffffff81127714>] do_filp_open+0x44/0xa0
>   [<ffffffff81133724>] ? alloc_fd+0xe4/0x130
>   [<ffffffff81117b3c>] do_sys_open+0xfc/0x1d0
>   [<ffffffff81117c2b>] sys_open+0x1b/0x20
>   [<ffffffff8150763b>] system_call_fastpath+0x16/0x1b
>  Code: 5b 41 5c 41 5d 41 5e 41 5f c9 c3 31 c0 eb ed 0f 1f 40 00 55 48 8b 
>  07 48 89 e5 48 85 c0 74 1e 8b 56 10 3b 50 10 7e 09 eb 14 66 90
>   50 10 7c 0d 48 8d 78 08 48 8b 40 08 48 85 c0 75 ee 48 89 46
>  RIP  [<ffffffff81093758>] raw_notifier_chain_register+0x18/0x40
>   RSP <ffff88022ed4dbb8>
>  ---[ end trace 8dcb6b8322e14541 ]---

I tried to create a similar setup but can't see which instruction
could trigger the gp. If you have the object files available, could
you send me the obj dump of raw_notifier_chain_register() of the host
setup with something like:

 objdump -Sdl kernel/notifier.o

Is there any special in your oprofile setup?

>  On Tue, 17 Jan 2012 22:40:58 -0600, Dyweni - KVM wrote:
> > I'm getting the following error from my guest kernel when running
> > oprofile within qemu-kvm:
> >
> > general protection fault: 0000 [#1]
> > Modules linked in:
> >
> > Pid: 896, comm: oprofiled Not tainted 3.2.0-rc7-20120117-0605 #1 
> > Bochs
> > Bochs
> > EIP: 0060:[] EFLAGS: 00010086 CPU: 0
> > EIP is at nmi_cpu_setup.clone.6+0x2e/0xb0
> > EAX: 00000000 EBX: df89894c ECX: c0010005 EDX: 00000000
> > ESI: 00000001 EDI: c168e5c0 EBP: df8addf4 ESP: df8adde4
> > DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process oprofiled (pid: 896, ti=df8ac000 task=df82f780
> > task.ti=df8ac000)
> > Stack:
> > df898980 00000004 fffffff0 d4520880 df8ade08 c1406d4b c1618dfa
> > 00000000
> > 00000000 df8ade14 c140464f dc792de0 df8ade28 c1405963 d4520880
> > dc792de0
> > 00000000 df8ade4c c1111bfa c111c7fe df84c000 df8ade44 dc77ef80
> > df8adeec
> > Call Trace:
> > [] nmi_setup+0xab/0xd0
> > [] oprofile_setup+0x2f/0xb0
> > [] event_buffer_open+0x63/0x90
> > [] __dentry_open.clone.17+0x1aa/0x2d0
> > [] ? do_lookup+0x3e/0x370
> > [] nameidata_to_filp+0x52/0x70
> > [] ? event_buffer_release+0x40/0x40
> > [] do_last+0x1e6/0x740
> > [] path_openat+0x9a/0x320
> > [] ? page_add_new_anon_rmap+0x74/0x80
> > [] do_filp_open+0x30/0x80
> > [] ? alloc_fd+0x2c/0xd0
> > [] do_sys_open+0xeb/0x1c0
> > [] sys_open+0x29/0x40
> > [] sysenter_do_call+0x12/0x22
> > Code: 57 56 53 83 ec 04 a1 90 e5 68 c1 8b 3d 44 a5 78 c1 8b 1d 8c e5 
> > 68
> > c1 89 45 f0 8b 07 85 c0 74 1d 31 f6 8d 76 00 8b 0b 85 c9 74 08 32
> > 89 43 04 89 53 08 83 c6 01 83 c3 0c 3b 37 72 e8 8b 77 04
> > EIP: [] nmi_cpu_setup.clone.6+0x2e/0xb0 SS:ESP 0068:df8adde4
> > ---[ end trace e22f1adcb9f592c1 ]---

Running oprofile in qemu-kvm guests is not supported, though an gp
should not be triggered by the oprofile driver. Do you see anything in
dmesg of the host when the guest gp triggers?

Same here, could you send me the objdump of nmi_cpu_setup() and
nmi_setup() (guest kernel)?

 objdump -Sdl arch/x86/oprofile/nmi_int.o

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

