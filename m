Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab0CaNpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:45:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349Ab0CaNpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:45:21 -0400
Date: Wed, 31 Mar 2010 15:45:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2,
 stepping 3
In-Reply-To: <4BB33C0D.9090808@amd.com>
Message-ID: <alpine.LNX.2.00.1003311531000.24576@pobox.suse.cz>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <4BB33C0D.9090808@amd.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Andre Przywara wrote:

> But the far better solution is to instruct QEMU/KVM to inject a better CPU
> model (as it was suggested by some people two weeks ago). I am about to test
> various guests with respect to their behavior regarding different
> family/model/stepping settings (one issue is already fixed). If this goes
> well, I will send out the patch to inject the host's CPUID F/M/S into the
> guest by default (which has other advantages, but denies migration mostly).
> 
> BTW.: I encourage people to test their KVM guests with "-cpu host" (on newer
> QEMUs) and send me any crash logs.

I just quickly checked ...

[    0.048001] Pid: 0, comm: swapper Not tainted (2.6.32.9-0.5-pae #1) Bochs
[    0.048001] EIP: 0060:[<c0528a80>] EFLAGS: 00010246 CPU: 0
[    0.048001] EIP is at init_amd+0x249/0x279
[    0.048001] EAX: 00000000 EBX: 00000000 ECX: 00a21000 EDX: 00000000
[    0.048001] ESI: c077de80 EDI: c077de98 EBP: c07e1a14 ESP: c0749f8c
[    0.048001]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.048001] Process swapper (pid: 0, ti=c0748000 task=c074fca0 task.ti=c0748000)
[    0.048001] Stack:
[    0.048001]  000000e8 00000000 00000000 c07b9720 c077de80 c077debc c077de98 c0527d74
[    0.048001] <0> de816448 de816440 00000000 00000000 de840580 000080d0 c07b9720 00099d00
[    0.048001] <0> c074c000 00bfc003 c078822d c07882c8 c028e762 c07b9720 c0781a05 00000062
[    0.048001] Call Trace:
[    0.048001]  [<c0527d74>] identify_cpu+0xc2/0x223
[    0.048001]  [<c078822d>] identify_boot_cpu+0xa/0x22
[    0.048001]  [<c07882c8>] check_bugs+0x8/0xd2
[    0.048001]  [<c0781a05>] start_kernel+0x32e/0x3a9
[    0.048001] Code: 00 00 39 44 24 08 0f 96 c0 0f b6 d0 0f b7 86 b6 00 00 00 8b 0c 9d 80 e4 77 c0 8d 04 42 31 d2 66 89 44 0d 00 0f b7 86 b8 00 00 00 <f7> 74 24 08 66 89 96 b8 00 00 00 e9 77 fe ff ff 66 c7 05 00 1d 
[    0.048001] EIP: [<c0528a80>] init_amd+0x249/0x279 SS:ESP 0068:c0749f8c
[    0.116025] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.117661] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.120008] Pid: 0, comm: swapper Tainted: G      D      2.6.32.9-0.5-pae #1
[    0.122115] Call Trace:
[    0.124032]  [<c02069a1>] try_stack_unwind+0x1b1/0x1f0
[    0.125821]  [<c020596f>] dump_trace+0x3f/0xe0
[    0.132019]  [<c02065ab>] show_trace_log_lvl+0x4b/0x60
[    0.136012]  [<c02065d8>] show_trace+0x18/0x20
[    0.137572]  [<c052dc19>] dump_stack+0x6d/0x74
[    0.139120]  [<c052dc62>] panic+0x42/0x145
[    0.140018]  [<c0242936>] do_exit+0x236/0x310
[    0.141550]  [<c0531063>] oops_end+0xc3/0xd0
[    0.144012]  [<c020455c>] do_divide_error+0x7c/0x90
[    0.145643]  [<c05304ee>] error_code+0x66/0x6c
[    0.147235]  [<c0528a80>] init_amd+0x249/0x279
[    0.148011]  [<c0527d74>] identify_cpu+0xc2/0x223
[    0.149649]  [<c078822d>] identify_boot_cpu+0xa/0x22
[    0.152010]  [<c07882c8>] check_bugs+0x8/0xd2
[    0.153573]  [<c0781a05>] start_kernel+0x32e/0x3a9

But I admit that this isn't the most up-to-date version, so perhaps it's 
already fixed ...

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
