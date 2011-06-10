Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1FJKOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:14:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1FJKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Tufoezh+kPStQ6jzb5z1ElUl0F0ZTOTcIAkgZl0enlrA3BzAadO44WIfe841mMcLeX
         xt9ZFc/c1vbYYEM3RteRfph1vmmiC0S202BjBpQEMStYiemTFnMiJdRsFZjsG+lB1h0X
         77Nb2YNecNgHnOnPVgWwkjo7RqNeA0+SgVk+g=
Message-ID: <4DF1EE76.6070001@gmail.com>
Date: Fri, 10 Jun 2011 12:14:14 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: alsa-devel@alsa-project.org
Subject: Regression in 3.0: oops with module RO/NX in snd_printk when loading
 snd-hda-intel (gold linker bug?)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since 3.0.0rc1 I get an oops in alc_auto_parse_customize_define, when it's calling snd_printk, I have module NX/RO enabled, and linked the kernel with gold. the only command I do is 'modprobe snd debug=8; modprobe snd-hda-intel' after init=/bin/bash

ld --version: GNU gold (GNU Binutils for Ubuntu 2.21.0.20110327) 1.11

[   43.327003] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[   43.327012] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   43.327063] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   43.327090] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   43.327097] BUG: unable to handle kernel paging request at ffffffffa003c80a
[   43.327253] IP: [<ffffffffa002f791>] __snd_printk+0x71/0x110 [snd]
[   43.327392] PGD 1a25067 PUD 1a29063 PMD 231bce067 PTE 0
[   43.327523] Oops: 0000 [#1] PREEMPT SMP
[   43.327620] CPU 1
[   43.327660] Modules linked in: snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device
snd_timer snd soundcore
[   43.328104]
[   43.328134] Pid: 149, comm: modprobe Not tainted 3.0.0-rc2-patser+ #34 To Be Filled By O.E.M. To Be Filled By O.E.M./P67 Pro3
[   43.328393] RIP: 0010:[<ffffffffa002f791>]  [<ffffffffa002f791>] __snd_printk+0x71/0x110 [snd]
[   43.328581] RSP: 0018:ffff8802310a9c38  EFLAGS: 00010216
[   43.328696] RAX: ffff8802310a9c78 RBX: 0000000000000002 RCX: ffffffffa00bea30
[   43.328851] RDX: 0000000000000a1a RSI: ffffffffa00be00a RDI: ffffffffa00be00a
[   43.329006] RBP: ffff8802310a9cb8 R08: 0000000000004401 R09: 0000000000000040
[   43.329161] R10: 00000000000000d8 R11: 0000000000000002 R12: ffffffffa00bea30
[   43.329316] R13: ffff88023110e800 R14: ffff88023110e800 R15: 0000000000004401
[   43.329472] FS:  00007fc62e05c720(0000) GS:ffff88023f480000(0000) knlGS:0000000000000000
[   43.329647] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   43.329772] CR2: ffffffffa003c80a CR3: 00000002310b6000 CR4: 00000000000406e0
[   43.329927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   43.330082] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   43.330237] Process modprobe (pid: 149, threadinfo ffff8802310a8000, task ffff8802311216f0)
[   43.330418] Stack:
[   43.330462]  ffff8802310a9c58 ffffffff81a05080 ffff880200000020 ffff8802310a9cc8
[   43.330640]  ffff8802310a9c78 ffffffff810bab78 ffff8802310a9c98 0000000005411735
[   43.330815]  ffff88023110e800 40ff880232ad3000 ffff880232ad3000 ffff880232ad3000
[   43.330991] Call Trace:
[   43.331044]  [<ffffffff810bab78>] ? synchronize_irq+0x58/0xf0
[   43.336434]  [<ffffffffa00bd191>] azx_probe+0x48b/0x9fb [snd_hda_intel]
[   43.341867]  [<ffffffff81317e8f>] local_pci_probe+0x5f/0xd0
[   43.347300]  [<ffffffff813185f9>] pci_device_probe+0x119/0x120
[   43.352744]  [<ffffffff813b27aa>] ? driver_sysfs_add+0x7a/0xb0
[   43.358193]  [<ffffffff813b2b23>] driver_probe_device+0xa3/0x2a0
[   43.363649]  [<ffffffff813b2dcb>] __driver_attach+0xab/0xb0
[   43.369038]  [<ffffffff813b2d20>] ? driver_probe_device+0x2a0/0x2a0
[   43.374387]  [<ffffffff813b193e>] bus_for_each_dev+0x5e/0x90
[   43.379725]  [<ffffffff813b272e>] driver_attach+0x1e/0x20
[   43.385029]  [<ffffffff813b22d0>] bus_add_driver+0x160/0x2b0
[   43.390172]  [<ffffffffa0021000>] ? 0xffffffffa0020fff
[   43.395151]  [<ffffffff813b3394>] driver_register+0x74/0x130
[   43.400133]  [<ffffffffa0021000>] ? 0xffffffffa0020fff
[   43.405010]  [<ffffffff81318876>] __pci_register_driver+0x56/0xd0
[   43.409827]  [<ffffffff8102b653>] ? set_memory_nx+0x43/0x50
[   43.414645]  [<ffffffffa002101e>] alsa_card_azx_init+0x1e/0x1000 [snd_hda_intel]
[   43.419550]  [<ffffffff810002d5>] do_one_initcall+0x45/0x170
[   43.424489]  [<ffffffff8109505a>] sys_init_module+0xfa/0x250
[   43.429420]  [<ffffffff8157c52b>] system_call_fastpath+0x16/0x1b
[   43.434403] Code: 00 00 00 75 6b 48 8b 5d f0 4c 8b 65 f8 c9 c3 48 8d 45 10 c7 45 90 20 00 00 00 48 89 45 98 48 8d 45 c0 48 89 45 a0 80 3e 2f 74 78 <8b> 05 73 d0 00 00 85 db 89 45 b0 48 c7 c6 b3 23 03 a0 48 c7 c0
[   43.444891] RIP  [<ffffffffa002f791>] __snd_printk+0x71/0x110 [snd]
[   43.450012]  RSP <ffff8802310a9c38>
[   43.450013] CR2: ffffffffa003c80a
[   43.450014] ---[ end trace 890ffb2c861edf22 ]---

everything sound loaded modular, all hda codecs too.

CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y

module RO/NX is set, which I assume is causing the problem.

I don't understand the oops, but disassembly of the specific offset is below, from objdump -S:

7de1 is the location of the crash

#ifdef CONFIG_SND_VERBOSE_PRINTK
/* strip the leading path if the given path is absolute */
static const char *sanity_file_name(const char *path)
{
        if (*path == '/')
    7ddc:       80 3e 2f                cmpb   $0x2f,(%rsi)
    7ddf:       74 78                   je     7e59 <__snd_printk+0xe9>
/* print file and line with a certain printk prefix */
static int print_snd_pfx(unsigned int level, const char *path, int line,
                         const char *format)
{
        const char *file = sanity_file_name(path);
        char tmp[] = "<0>";
    7de1:       8b 05 00 00 00 00       mov    0x0(%rip),%eax        # 7de7 <__snd_printk+0x77>
        const char *pfx = level ? KERN_DEBUG : KERN_DEFAULT;
    7de7:       85 db                   test   %ebx,%ebx
/* print file and line with a certain printk prefix */
static int print_snd_pfx(unsigned int level, const char *path, int line,
                         const char *format)
{
        const char *file = sanity_file_name(path);
        char tmp[] = "<0>";
    7de9:       89 45 b0                mov    %eax,-0x50(%rbp)
        const char *pfx = level ? KERN_DEBUG : KERN_DEFAULT;
    7dec:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi
    7df3:       48 c7 c0 00 00 00 00    mov    $0x0,%rax
    7dfa:       48 0f 44 f0             cmove  %rax,%rsi

---
Seems to me like it's segfaulting when loading <0>\0 (4 bytes, so fits in an integer) to %eax. building all modules with the normal binutils works fine, and makes this crash disappear.

Is this bug interesting enough that I'll see if I can find the commit which caused this regression?

~Maarten
