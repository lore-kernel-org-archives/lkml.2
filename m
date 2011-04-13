Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1DMVgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:36:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48400 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab1DMVgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik8nOXJb3J9=m4-2Ugw4P7AFzCQoA@mail.gmail.com>
References: <BANLkTik8nOXJb3J9=m4-2Ugw4P7AFzCQoA@mail.gmail.com>
Date: Wed, 13 Apr 2011 23:36:00 +0200
Message-ID: <BANLkTi=0iV175B3rkfM6QcxcHOdwtpvCXg@mail.gmail.com>
Subject: Re: Kernel panic (NULL ptr deref?) in find_ge_pid()/next_pidmap()
 (via sys_getdents or sys_readdir)
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 11:12 PM, Robert Święcki <robert@swiecki.net> wrote:
> Oops: (kdb's dumpall attached)
>
> [18608.476700] general protection fault: 0000 [#1] PREEMPT SMP
> [18608.476704] last sysfs file:
> /sys/devices/platform/microcode/power/runtime_status
> [18608.477002] CPU 0
> [18608.477002] Pid: 31157, comm: iknowthis Not tainted 2.6.39-rc3 #4
> Dell Inc.                 Precision WorkStation 390    /0GH911
> [18608.477002] RIP: 0010:[<ffffffff810ac3cc>]  [<ffffffff810ac3cc>]
> next_pidmap+0x38/0x7f
> [18608.477002] RSP: 0000:ffff88007b40fd48  EFLAGS: 00010203
> [18608.477002] RAX: 0000000000000000 RBX: 001fffff82753988 RCX: 0000000000000034
> [18608.477002] RDX: 0000000000003b6e RSI: 001ffffffff2c980 RDI: ffffffff82827000
> [18608.477002] RBP: ffff88007b40fd68 R08: a000000000000000 R09: 5b68000000000000
> [18608.477002] R10: ffff88007b40e000 R11: ffff88007b40fdb8 R12: ffffffff82827000
> [18608.477002] R13: ffffffff82827808 R14: ffffffff81199146 R15: ffffffff81199146
> [18608.477002] FS:  0000000000000000(0000) GS:ffff88012bc00000(0063)
> knlGS:00000000f75406c0
> [18608.477002] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [18608.477002] CR2: 000000000809601c CR3: 0000000118457000 CR4: 00000000000006f0
> [18608.477002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [18608.477002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [18608.477002] Process iknowthis (pid: 31157, threadinfo
> ffff88007b40e000, task ffff880124f6c560)
> [18608.477002] Stack:
> [18608.477002]  ffff88011e2e5c80 00000000964c3b6d 0000000000000000
> ffffffff82827000
> [18608.477002]  ffff88007b40fd98 ffffffff810ac446 ffff88011e2e5c80
> ffffffff82827000
> [18608.477002]  00000000964c3b6d ffff880124f68000 ffff88007b40fdf8
> ffffffff811aedbb
> [18608.477002] Call Trace:
> [18608.477002]  [<ffffffff810ac446>] find_ge_pid+0x33/0x45
> [18608.477002]  [<ffffffff811aedbb>] next_tgid+0x3c/0x93
> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
> [18608.477002]  [<ffffffff810abf69>] ? get_pid_task+0x49/0x51
> [18608.477002]  [<ffffffff811aef6f>] proc_pid_readdir+0x15d/0x1b0
> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
> [18608.477002]  [<ffffffff811ab262>] proc_root_readdir+0x43/0x4b
> [18608.477002]  [<ffffffff8116bd57>] vfs_readdir+0x71/0xae
> [18608.477002]  [<ffffffff81197d18>] compat_sys_getdents+0x81/0xcc
> [18608.477002]  [<ffffffff81f26703>] ia32_do_call+0x13/0x13
> [18608.477002] Code: 0f 1f 44 00 00 ff c6 49 89 fc 89 f2 4c 8d af 08
> 08 00 00 48 63 f6 81 e2 ff 7f 00 00 48 c1 ee 0f 48 c1 e6 04 48 8d 5c
> 37 08 eb 36
> [18608.477002]  8b 7b 08 48 85 ff 74 27 48 63 d2 be 00 80 00 00 e8 66 ab 3e
> [18608.477002] RIP  [<ffffffff810ac3cc>] next_pidmap+0x38/0x7f
> [18608.477002]  RSP <ffff88007b40fd48>
> [18626.313012] ---[ end trace 947a53151707da51 ]---
>
> $ ./decodecode </tmp/ooops
> Code: 0f 1f 44 00 00 ff c6 49 89 fc 89 f2 4c 8d af 08 08 00 00 48 63
> f6 81 e2 ff 7f 00 00 48 c1 ee 0f 48 c1 e6 04 48 8d 5c 37 08 eb 36
>
> Code starting with the faulting instruction
> ===========================================
>   0:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>   5:   ff c6                   inc    %esi
>   7:   49 89 fc                mov    %rdi,%r12
>   a:   89 f2                   mov    %esi,%edx
>   c:   4c 8d af 08 08 00 00    lea    0x808(%rdi),%r13
>  13:   48 63 f6                movslq %esi,%rsi
>  16:   81 e2 ff 7f 00 00       and    $0x7fff,%edx
>  1c:   48 c1 ee 0f             shr    $0xf,%rsi
>  20:   48 c1 e6 04             shl    $0x4,%rsi
>  24:   48 8d 5c 37 08          lea    0x8(%rdi,%rsi,1),%rbx
>  29:   eb 36                   jmp    0x61

Src dump of the RIP address

./vmlinux:     file format elf64-x86-64

Disassembly of section .text:

ffffffff810ac394 <next_pidmap>:
        }
        return -1;
}

int next_pidmap(struct pid_namespace *pid_ns, int last)
{
ffffffff810ac394:       55                      push   %rbp
ffffffff810ac395:       48 89 e5                mov    %rsp,%rbp
ffffffff810ac398:       41 55                   push   %r13
ffffffff810ac39a:       41 54                   push   %r12
ffffffff810ac39c:       53                      push   %rbx
ffffffff810ac39d:       48 83 ec 08             sub    $0x8,%rsp
ffffffff810ac3a1:       e8 1a 88 e7 00          callq  ffffffff81f24bc0 <mcount>
        int offset;
        struct pidmap *map, *end;

        offset = (last + 1) & BITS_PER_PAGE_MASK;
ffffffff810ac3a6:       ff c6                   inc    %esi
        }
        return -1;
}

int next_pidmap(struct pid_namespace *pid_ns, int last)
{
ffffffff810ac3a8:       49 89 fc                mov    %rdi,%r12
        int offset;
        struct pidmap *map, *end;

        offset = (last + 1) & BITS_PER_PAGE_MASK;
ffffffff810ac3ab:       89 f2                   mov    %esi,%edx
        map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
        end = &pid_ns->pidmap[PIDMAP_ENTRIES];
ffffffff810ac3ad:       4c 8d af 08 08 00 00    lea    0x808(%rdi),%r13
{
        int offset;
        struct pidmap *map, *end;

        offset = (last + 1) & BITS_PER_PAGE_MASK;
        map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
ffffffff810ac3b4:       48 63 f6                movslq %esi,%rsi
int next_pidmap(struct pid_namespace *pid_ns, int last)
{
        int offset;
        struct pidmap *map, *end;

        offset = (last + 1) & BITS_PER_PAGE_MASK;
ffffffff810ac3b7:       81 e2 ff 7f 00 00       and    $0x7fff,%edx
        map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
ffffffff810ac3bd:       48 c1 ee 0f             shr    $0xf,%rsi
ffffffff810ac3c1:       48 c1 e6 04             shl    $0x4,%rsi
ffffffff810ac3c5:       48 8d 5c 37 08          lea    0x8(%rdi,%rsi,1),%rbx
        end = &pid_ns->pidmap[PIDMAP_ENTRIES];
        for (; map < end; map++, offset = 0) {
ffffffff810ac3ca:       eb 36                   jmp
ffffffff810ac402 <next_pidmap+0x6e>
                if (unlikely(!map->page))
ffffffff810ac3cc:       48 8b 7b 08             mov    0x8(%rbx),%rdi
ffffffff810ac3d0:       48 85 ff                test   %rdi,%rdi
ffffffff810ac3d3:       74 27                   je
ffffffff810ac3fc <next_pidmap+0x68>
                        continue;
                offset = find_next_bit((map)->page, BITS_PER_PAGE, offset);
ffffffff810ac3d5:       48 63 d2                movslq %edx,%rdx
ffffffff810ac3d8:       be 00 80 00 00          mov    $0x8000,%esi
ffffffff810ac3dd:       e8 66 ab 3e 00          callq
ffffffff81496f48 <find_next_bit>
                if (offset < BITS_PER_PAGE)
ffffffff810ac3e2:       3d ff 7f 00 00          cmp    $0x7fff,%eax
ffffffff810ac3e7:       77 13                   ja
ffffffff810ac3fc <next_pidmap+0x68>
#define BITS_PER_PAGE_MASK      (BITS_PER_PAGE-1)

static inline int mk_pid(struct pid_namespace *pid_ns,
                struct pidmap *map, int off)
{
        return (map - pid_ns->pidmap)*BITS_PER_PAGE + off;
ffffffff810ac3e9:       49 83 c4 08             add    $0x8,%r12
ffffffff810ac3ed:       4c 29 e3                sub    %r12,%rbx
ffffffff810ac3f0:       48 c1 fb 04             sar    $0x4,%rbx
ffffffff810ac3f4:       c1 e3 0f                shl    $0xf,%ebx
ffffffff810ac3f7:       8d 04 03                lea    (%rbx,%rax,1),%eax
        for (; map < end; map++, offset = 0) {
                if (unlikely(!map->page))
                        continue;
                offset = find_next_bit((map)->page, BITS_PER_PAGE, offset);
                if (offset < BITS_PER_PAGE)
                        return mk_pid(pid_ns, map, offset);
ffffffff810ac3fa:       eb 0e                   jmp
ffffffff810ac40a <next_pidmap+0x76>
        struct pidmap *map, *end;

        offset = (last + 1) & BITS_PER_PAGE_MASK;
        map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
        end = &pid_ns->pidmap[PIDMAP_ENTRIES];
        for (; map < end; map++, offset = 0) {
ffffffff810ac3fc:       48 83 c3 10             add    $0x10,%rbx
ffffffff810ac400:       31 d2                   xor    %edx,%edx
ffffffff810ac402:       4c 39 eb                cmp    %r13,%rbx
ffffffff810ac405:       72 c5                   jb
ffffffff810ac3cc <next_pidmap+0x38>
ffffffff810ac407:       83 c8 ff                or     $0xffffffffffffffff,%eax
                offset = find_next_bit((map)->page, BITS_PER_PAGE, offset);
                if (offset < BITS_PER_PAGE)
                        return mk_pid(pid_ns, map, offset);
        }
        return -1;
}
ffffffff810ac40a:       41 5b                   pop    %r11
ffffffff810ac40c:       5b                      pop    %rbx
ffffffff810ac40d:       41 5c                   pop    %r12
ffffffff810ac40f:       41 5d                   pop    %r13
ffffffff810ac411:       c9                      leaveq



-- 
Robert Święcki
