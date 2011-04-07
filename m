Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1DGPan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:30:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:28760 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1DGPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:30:41 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1b0bM1432N98dKzz1202hzzz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAGEY-01-148-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 17:30:29 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "brgerst@gmail.com" <brgerst@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110407153029.GU13@escobedo.osrc.amd.com>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110407072305.GA20291@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 03:23:05AM -0400, Ingo Molnar wrote:
> 
> FYI, the bits in tip:x86/xsave crash on boot on an AMD X2 testbox:
> 
> [   10.823492] Freeing unused kernel memory: 616k freed
> [   11.087787] ------------[ cut here ]------------
> [   11.088312] Kernel BUG at ffffffff8100a140 [verbose debug info unavailable]
> [   11.088312] invalid opcode: 0000 [#1] SMP 
> [   11.088312] last sysfs file: 
> [   11.088312] CPU 1 
> [   11.088312] Modules linked in:
> [   11.088312] 
> [   11.088312] Pid: 41, comm: modprobe Not tainted 2.6.39-rc2-tip+ #113394  
> [   11.088312] RIP: 0010:[<ffffffff8100a140>]  [<ffffffff8100a140>] start_thread_common.constprop.1+0x100/0x110
> [   11.088312] RSP: 0018:ffff88003d7c5c40  EFLAGS: 00010246
> [   11.088312] RAX: ffff88003d7c5fd8 RBX: ffff88003d74bd40 RCX: 0000000000000033
> [   11.088312] RDX: 00007ffffffff000 RSI: 000000310f600ac0 RDI: 0000000000000000
> [   11.088312] RBP: ffff88003d7c5c60 R08: 0000000000000000 R09: 0000000000000004
> [   11.088312] R10: 00007fff4ae4dd68 R11: 0000000000000000 R12: 00007fff4ae4dd60
> [   11.088312] R13: 000000310f600ac0 R14: 0000000000000033 R15: ffff88003d74bd40
> [   11.088312] FS:  00007f48d909f780(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
> [   11.088312] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   11.088312] CR2: 00007fff4ae4def9 CR3: 000000003d7af000 CR4: 00000000000006e0
> [   11.088312] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   11.088312] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   11.088312] Process modprobe (pid: 41, threadinfo ffff88003d7c4000, task ffff88003d74bd40)
> [   11.088312] Stack:
> [   11.088312]  ffff88003d72c400 ffff88003d60a400 0000000000000000 ffff88003d7c5e80
> [   11.088312]  ffff88003d7c5c70 ffffffff8100a546 ffff88003d7c5d90 ffffffff8117c7de
> [   11.088312]  ffff88003d74bd40 0000000000000004 00007fff4ae4dda8 00007fff4ae4dd68
> [   11.088312] Call Trace:
> [   11.088312]  [<ffffffff8100a546>] start_thread+0x16/0x20
> [   11.088312]  [<ffffffff8117c7de>] load_elf_binary+0x14fe/0x1980
> [   11.088312]  [<ffffffff81138392>] search_binary_handler+0xc2/0x2a0
> [   11.088312]  [<ffffffff8117b2e0>] ? load_elf_library+0x2b0/0x2b0
> [   11.088312]  [<ffffffff8113a35c>] do_execve+0x24c/0x2d0
> [   11.088312]  [<ffffffff81014b97>] sys_execve+0x47/0x80
> [   11.088312]  [<ffffffff8145b698>] kernel_execve+0x68/0xd0
> [   11.088312]  [<ffffffff8106ca83>] ? ____call_usermodehelper+0x93/0xa0
> [   11.088312]  [<ffffffff8145b624>] kernel_thread_helper+0x4/0x10
> [   11.088312]  [<ffffffff81459f54>] ? retint_restore_args+0x13/0x13
> [   11.088312]  [<ffffffff8106c9f0>] ? call_usermodehelper_setup+0xe0/0xe0
> [   11.088312]  [<ffffffff8145b620>] ? gs_change+0x13/0x13
> [   11.088312] Code: f0 4c 8b 75 f8 c9 c3 0f 1f 40 00 48 8b 3d 19 01 64 00 48 85 ff 74 14 48 89 bb a0 04 00 00 48 c7 05 02 01 64 00 00 00 00 00 eb a1 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 
> [   11.088312] RIP  [<ffffffff8100a140>] start_thread_common.constprop.1+0x100/0x110
> [   11.088312]  RSP <ffff88003d7c5c40>

Sorry for that, it seems I made a wrong assumption about
kernel_execve() usage. Updated patches will follow shortly.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

