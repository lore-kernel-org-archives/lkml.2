Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab1FAIgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161762Ab1FAIfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:35:54 -0400
Date: Wed, 1 Jun 2011 10:35:51 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: linux-kernel@vger.kernel.org
cc: Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: NULL pointer dereference in inode_has_perm() while setquota
Message-ID: <alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was running xfstests on ext4 filesystem and I have run into NULL
pointer dereference in inode_has_perm() while running test no. 234. This
is on kernel 3.0.0-rc1.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
 IP: [<ffffffff811ed05c>] inode_has_perm+0x3c/0xa0
 PGD 0
 Oops: 0000 [#1] SMP
 CPU 20
 Modules linked in: ext4 jbd2 autofs4 sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_mod dcdbas microcode serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support i7core_edac edac_core ses enclosure sg bnx2 ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas [last unloaded: speedstep_lib]

 Pid: 18062, comm: setquota Not tainted 3.0.0-rc1+ #1 Dell Inc. PowerEdge R710/0MD99X
 RIP: 0010:[<ffffffff811ed05c>]  [<ffffffff811ed05c>] inode_has_perm+0x3c/0xa0
 RSP: 0018:ffff8801a9d13af8  EFLAGS: 00010282
 RAX: ffff8801a9d13b98 RBX: 0000000000000000 RCX: ffff88031c1c86a0
 RDX: 0000000000800000 RSI: ffff88012ee99d58 RDI: ffff880259898c80
 RBP: ffff8801a9d13b88 R08: 0000000000000001 R09: ffff88012ee99d58
 R10: 0000000000000678 R11: 0000000000000000 R12: ffff8801a9d13dd8
 R13: ffff88012ee99d58 R14: ffff88013829eb00 R15: 0000000000000000
 FS:  00007f5ff34c3700(0000) GS:ffff88032fd40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000020 CR3: 00000002e6a0b000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process setquota (pid: 18062, threadinfo ffff8801a9d12000, task ffff88013829eb00)
 Stack:
 ffff88032ffd7e00 0000000000000030 ffffea00066bb5b0 0000000000000000
 ffff8801a9d13c08 ffffffff81108a0a ffffffff00000000 ffff88013829f370
 00000002a9d13bb8 ffff8801a9d13fd8 000000002ffd7e00 ffff88032ffd7e60
 Call Trace:
 [<ffffffff81108a0a>] ? get_page_from_freelist+0x25a/0x570
 [<ffffffff811ed421>] selinux_inode_permission+0xd1/0x130
 [<ffffffff811ea593>] security_inode_exec_permission+0x23/0x30
 [<ffffffff8116b654>] link_path_walk+0xc4/0x920
 [<ffffffff8116c515>] path_lookupat+0x55/0x680
 [<ffffffff8116cb71>] do_path_lookup+0x31/0xc0
 [<ffffffff81168fd8>] ? getname_flags+0x1f8/0x280
 [<ffffffff8116d839>] user_path_at+0x59/0xa0
 [<ffffffff81128ae5>] ? handle_mm_fault+0x1d5/0x350
 [<ffffffff814d7948>] ? do_page_fault+0x1e8/0x470
 [<ffffffff811495c5>] ? kmem_cache_alloc+0x155/0x190
 [<ffffffff8116270c>] vfs_fstatat+0x4c/0x90
 [<ffffffff81074a51>] ? do_sigaction+0x91/0x1d0
 [<ffffffff8116282b>] vfs_stat+0x1b/0x20
 [<ffffffff81162854>] sys_newstat+0x24/0x50
 [<ffffffff810c1c1f>] ? audit_syscall_entry+0x1bf/0x1f0
 [<ffffffff814dc0c2>] system_call_fastpath+0x16/0x1b
 Code: 89 c8 65 48 8b 0c 25 28 00 00 00 48 89 4d f8 31 c9 f6 46 25 02 75 6f 48 8b 4f 68 48 85 c0 4c 8b 9e 30 02 00 00 44 8b 51 04 74 34
 RIP  [<ffffffff811ed05c>] inode_has_perm+0x3c/0xa0
 RSP <ffff8801a9d13af8>
 CR2: 0000000000000020
 ---[ end trace 26cf9362f1661921 ]---

Disassembly on inode_has_perm() did not help me very much, but here it
is for convenience.

Dump of assembler code for function inode_has_perm:
   0xffffffff811ed020 <+0>:     push   %rbp
   0xffffffff811ed021 <+1>:     mov    %rsp,%rbp
   0xffffffff811ed024 <+4>:     sub    $0x90,%rsp
   0xffffffff811ed02b <+11>:    callq  0xffffffff814dbe00
   0xffffffff811ed030 <+16>:    mov    %rcx,%rax
   0xffffffff811ed033 <+19>:    mov    %gs:0x28,%rcx
   0xffffffff811ed03c <+28>:    mov    %rcx,-0x8(%rbp)
   0xffffffff811ed040 <+32>:    xor    %ecx,%ecx
   0xffffffff811ed042 <+34>:    testb  $0x2,0x25(%rsi)
   0xffffffff811ed046 <+38>:    jne    0xffffffff811ed0b7 <inode_has_perm+151>
   0xffffffff811ed048 <+40>:    mov    0x68(%rdi),%rcx
   0xffffffff811ed04c <+44>:    test   %rax,%rax
   0xffffffff811ed04f <+47>:    mov    0x230(%rsi),%r11
   0xffffffff811ed056 <+54>:    mov    0x4(%rcx),%r10d
   0xffffffff811ed05a <+58>:    je     0xffffffff811ed090 <inode_has_perm+112>
   0xffffffff811ed05c <+60>:    movzwl 0x20(%r11),%edi
   0xffffffff811ed061 <+65>:    mov    0x1c(%r11),%esi
   0xffffffff811ed065 <+69>:    mov    %r8d,%r9d
   0xffffffff811ed068 <+72>:    mov    %edx,%ecx
   0xffffffff811ed06a <+74>:    mov    %rax,%r8
   0xffffffff811ed06d <+77>:    mov    %edi,%edx
   0xffffffff811ed06f <+79>:    mov    %r10d,%edi
   0xffffffff811ed072 <+82>:    callq  0xffffffff811ec760 <avc_has_perm_flags>
   0xffffffff811ed077 <+87>:    mov    -0x8(%rbp),%rdx
   0xffffffff811ed07b <+91>:    xor    %gs:0x28,%rdx
   0xffffffff811ed084 <+100>:   jne    0xffffffff811ed0b2 <inode_has_perm+146>
   0xffffffff811ed086 <+102>:   leaveq
   0xffffffff811ed087 <+103>:   retq
   0xffffffff811ed088 <+104>:   nopl   0x0(%rax,%rax,1)
   0xffffffff811ed090 <+112>:   lea    -0x90(%rbp),%r9
   0xffffffff811ed097 <+119>:   mov    $0x11,%ecx
   0xffffffff811ed09c <+124>:   mov    %r9,%rdi
   0xffffffff811ed09f <+127>:   rep stos %rax,%es:(%rdi)
   0xffffffff811ed0a2 <+130>:   movb   $0x9,-0x90(%rbp)
   0xffffffff811ed0a9 <+137>:   mov    %rsi,-0x80(%rbp)
   0xffffffff811ed0ad <+141>:   mov    %r9,%rax
   0xffffffff811ed0b0 <+144>:   jmp    0xffffffff811ed05c <inode_has_perm+60>
   0xffffffff811ed0b2 <+146>:   callq  0xffffffff810628e0 <__stack_chk_fail>
   0xffffffff811ed0b7 <+151>:   xor    %eax,%eax
   0xffffffff811ed0b9 <+153>:   jmp    0xffffffff811ed077 <inode_has_perm+87>
End of assembler dump.


from the hooks.lst:


static int inode_has_perm(const struct cred *cred,
                          struct inode *inode,
                          u32 perms,
                          struct common_audit_data *adp,
                          unsigned flags)
{

----snip----

        sid = cred_sid(cred);
        isec = inode->i_security;

        if (!adp) {
ffffffff811ed05a:       74 34                   je     ffffffff811ed090 <inode_has_perm+0x70>
                adp = &ad;
                COMMON_AUDIT_DATA_INIT(&ad, INODE);
                ad.u.inode = inode;
        }

        return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
ffffffff811ed05c:       41 0f b7 7b 20          movzwl 0x20(%r11),%edi
ffffffff811ed061:       41 8b 73 1c             mov    0x1c(%r11),%esi
ffffffff811ed065:       45 89 c1                mov    %r8d,%r9d
ffffffff811ed068:       89 d1                   mov    %edx,%ecx
ffffffff811ed06a:       49 89 c0                mov    %rax,%r8
ffffffff811ed06d:       89 fa                   mov    %edi,%edx
ffffffff811ed06f:       44 89 d7                mov    %r10d,%edi
ffffffff811ed072:       e8 00 00 00 00          callq  ffffffff811ed077 <inode_has_perm+0x57>
                        ffffffff811ed073: R_X86_64_PC32 avc_has_perm_flags-0x4
}

It looks like the problem is while calling avc_has_perm_flags(), more
specifically while dereferencing isec to pass the arguments. So it looks
like the inode->i_security is null for some reason. I do not understand
the code good enough to tell where the actual problem lies, but if you
need more info, just let me know.

Thanks!
-Lukas
