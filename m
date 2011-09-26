Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1IZIF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:05:59 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:55994 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1IZIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:05:54 -0400
Subject: Re: NULL pointer dereference in inode_has_perm() while setquota
From: Paul Bolle <pebolle@tiscali.nl>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1106090946550.4138@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com>
	 <20110608134014.43ac448b.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1106090815020.4138@dhcp-27-109.brq.redhat.com>
	 <alpine.LFD.2.00.1106090946550.4138@dhcp-27-109.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 10:05:43 +0200
Message-ID: <1317024343.3536.18.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 09:47 +0200, Lukas Czerner wrote:
> I am not able to reproduce it on 3.0.0-rc2, so I guess it got fixed
> already.

0) This might not be correct, as I just ran into something very similar
on v3.0.4 (this is copied by hand from a manual screenshot, so there's a
chance of typo's):

[23760.116272] CPU 1 
[23760.116286] Modules linked in: tcp_lp fuse vfat fat usb_storage uas nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc kvm_intel kvm uinput snd_hda_codec_analog arc4 snd_hda_intel snd_hda_codec snd_hwdep iwl4965 snd_seq iwl_legacy snd_seq_device btusb snd_pcm e1000e mac80211 bluetooth cfg80211 iTCO_wdt snd_timer i2c_i801 iTCO_vendor_support snd_page_alloc thinkpad_acpi rfkill snd microcode soundcore pcspkr sdhci_pci yenta_socket sdhci firewire_ohci firewire_core mmc_core crc_itu_t i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[23760.116761] 
[23760.116773] Pid: 861, comm: irqbalance Not tainted 3.0.4-local0.fc14.x86_64 #1 LENOVO 76735GG/76735GG
[23760.116830] RIP: 0010:[<ffffffff81206de5>]  [<ffffffff81206de5>] inode_has_perm+0x5a/0x7a
[23760.116871] RSP: 0018:ffff880133767bb8  EFLAGS: 00010246
[23760.116900] RAX: 0000000000000000 RBX: ffff88013327a900 RCX: 0000000000800000
[23760.116933] RDX: ffff880105a88006 RSI: ffff880131ed9a08 RDI: ffff88013327a900
[23760.116966] RBP: ffff880133767be8 R08: ffff880133767c08 R09: 0000000000000001
[23760.116998] R10: 00000000000000f6 R11: 0000000000800000 R12: ffff880131ed9a08
[23760.117008] R13: ffff880133767c08 R14: 0000000000800000 R15: 0000000000000001
[23760.117008] FS:  00007fa86f36f740(0000) GS:ffff88013bc00000(0000) knlGS:0000000000000000
[23760.117008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[23760.117008] CR2: 0000000000000020 CR3: 00000001320d3000 CR4: 00000000000006e0
[23760.117008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[23760.117008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[23760.117008] Process irqbalance (pid: 861, threadinfo ffff880133766000, task ffff88013357a3d0)
[23760.117008] Stack:
[23760.117008]  ffffffff81154252 ffff880131ed9a08 ffff88013327a900 0000000000000000
[23760.117008]  ffff88013357a3d0 0000000000000000 ffff880133767ca8 ffffffff81207302
[23760.117008]  ffff880100000000 ffffffff00000001 0000000000000009 0000000000000000
[23760.117008] Call Trace:
[23760.117008]  [<ffffffff81154252>] ? dentry_cmp+0x21/0x31
[23760.117008]  [<ffffffff81207302>] selinux_inode_permission+0x9c/0xbc
[23760.117008]  [<ffffffff81201727>] security_inode_exec_permission+0x25/0x27
[23760.117008]  [<ffffffff8114c3db>] exec_permission+0x81/0x8f
[23760.117008]  [<ffffffff8114ec89>] link_path_walk+0x71/0x477
[23760.117008]  [<ffffffff8114cec4>] ? handle_dots+0x218/0x218
[23760.117008]  [<ffffffff8114d619>] ? path_init+0x11c/0x2fc
[23760.117008]  [<ffffffff8114fa71>] path_openat+0xae/0x35b
[23760.117008]  [<ffffffff8114fd5b>] do_filp_open+0x3d/0x89
[23760.117008]  [<ffffffff814ef7df>] ? _raw_spin_unlock+0x2b/0x2f
[23760.117008]  [<ffffffff8115aa28>] ? alloc_fd+0x181/0x193
[23760.117008]  [<ffffffff811427bc>] do_sys_open+0x74/0x106
[23760.117008]  [<ffffffff811162d7>] ? remove_vma+0x7f/0x87
[23760.117008]  [<ffffffff8114286e>] sys_open+0x20/0x22
[23760.117008]  [<ffffffff814f62c2>] system_call_fastpath+0x16/0x1b
[23760.117008] Code: c9 05 00 00 48 c7 c6 98 68 7e 81 48 89 df e8 51 97 e7 ff 31 c0 41 f6 44 24 69 02 75 21 49 8b 44 24 78 45 89 f9 4d 89 e8 44 89 f1 <0f> b7 50 20 8b 70 1c 48 8b 43 78 8b 78 04 e8 aa ca ff ff 41 58
[23760.117008] RIP  [<ffffffff81206de5>] inode_has_perm+0x5a/0x7a
[23760.117008]  RSP <ffff880133767bb8>
[23760.117008] CR2: 0000000000000020

1) Poking with gdb into vmlinux gives:

(gdb) info line 1489
Line 1489 of "security/selinux/hooks.c" starts at address 0xffffffff81206ddc <inode_has_perm+81>
   and ends at 0xffffffff81206dec <inode_has_perm+97>.
(gdb) disass /m inode_has_perm+81,+16
Dump of assembler code from 0xffffffff81206ddc to 0xffffffff81206dec:
1489		return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
   0xffffffff81206ddc <inode_has_perm+81>:	mov    %r15d,%r9d
   0xffffffff81206ddf <inode_has_perm+84>:	mov    %r13,%r8
   0xffffffff81206de2 <inode_has_perm+87>:	mov    %r14d,%ecx
   0xffffffff81206de5 <inode_has_perm+90>:	movzwl 0x20(%rax),%edx
   0xffffffff81206de9 <inode_has_perm+94>:	mov    0x1c(%rax),%esi

End of assembler dump.
(gdb) disass /r inode_has_perm+81,+16
Dump of assembler code from 0xffffffff81206ddc to 0xffffffff81206dec:
   0xffffffff81206ddc <inode_has_perm+81>:	 45 89 f9	mov    %r15d,%r9d
   0xffffffff81206ddf <inode_has_perm+84>:	 4d 89 e8	mov    %r13,%r8
   0xffffffff81206de2 <inode_has_perm+87>:	 44 89 f1	mov    %r14d,%ecx
   0xffffffff81206de5 <inode_has_perm+90>:	 0f b7 50 20	movzwl 0x20(%rax),%edx
   0xffffffff81206de9 <inode_has_perm+94>:	 8b 70 1c	mov    0x1c(%rax),%esi
End of assembler dump.

(Note that gdb prints addresses in hexadecimal and offsets in decimal,
while the kernel prints both in hexadecimal. This means one has to do
some dec/hex translations to match their output.)

2) So the problematic instruction is "movzwl 0x20(%rax),%edx". I know
next to nothing about x86_64 assembler, but it seems this corresponds to
looking up isec->sclass for the avc_has_perm_flags() call, as the offset
of sclass in struct inode_security_struct should be 0x20. Apparently
isec (ie, inode->i_security) was NULL. This echoes Lukas' analysis.

3) I have no idea what triggered this. Nor do I know under what
circumstances inode->i_security can be NULL.


Paul Bolle

