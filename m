Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2AaRBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:01:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62313 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2AaRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:01:30 -0500
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 22:31:29 +0530
Message-ID: <CABJk5kmfGFOzdeTZ+Fkn7KigNYLEPVe+e9wyAa0ifXPoZk26GA@mail.gmail.com>
Subject: Linux kernel hangs
From: radiatejava <radiatejava@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Resending this query as the list seems to allow only 100k chars in the post>
I am kind of new to linux kernel (not totally new). The issue I am
facing on my linux is that the machine hangs. I get to see these
messages in my /var/log/messages file and I need some pointers on
where the issue could be and because of what ? Linnux kernel is
2.6.18-128. Thanks in adv.

Jan 27 11:37:25 ECDCCAM1 kernel:
Jan 27 11:37:25 ECDCCAM1 kernel:
         sibling
Jan 27 11:37:25 ECDCCAM1 kernel:   task             PC      pid father
child younger older
Jan 27 11:37:25 ECDCCAM1 kernel: init          S 003CB211   768     1
    0     2               (NOTLB)
Jan 27 11:37:25 ECDCCAM1 kernel:        cb70ab68 00000082 6bccccd7
003cb211 cb70ab1c f7e3e000 cb70ab70 0000000a
Jan 27 11:37:26 ECDCCAM1 kernel:        cb70baa0 6bcd1a39 003cb211
00004d62 00000002 cb70bbac cb6202a8 f7df8040
Jan 27 11:37:26 ECDCCAM1 kernel:        cb70ab4c 00000000 00000286
c042c2e0 f7e3e000 cb70ab70 00000286 ffffffff
Jan 27 11:37:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f8886302>]
ext3_get_blocks_handle+0x899/0x8cc [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04730c1>] __find_get_block+0x15c/0x166
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04730fb>] __getblk+0x30/0x27a
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0488b5a>] __lookup_mnt+0x4a/0x53
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0485637>] __d_lookup+0x98/0xdb
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c047cce4>] do_lookup+0x53/0x174
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047ee89>] __link_path_walk+0xbfa/0xd33
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047f3d8>] do_path_lookup+0x20e/0x25e
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0479080>] cp_new_stat64+0xfc/0x10e
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:37:27 ECDCCAM1 kernel:  =======================
Jan 27 11:37:27 ECDCCAM1 kernel: migration/0   S 003CB1B7  3636     2
    1             3       (L-TLB)
Jan 27 11:37:27 ECDCCAM1 kernel:        f7e1dfac 00000046 ddf46253
003cb1b7 f7e1df98 c041ef1d 00933494 00000001
Jan 27 11:37:27 ECDCCAM1 kernel:        cb703550 ddf469f5 003cb1b7
000007a2 00000000 cb70365c cb6126e0 f72bdac0
Jan 27 11:37:27 ECDCCAM1 kernel:        00000003 00000000 cb6270d0
f4c3ef68 f4c3ef6c 00000293 f7e1dfac ffffffff
Jan 27 11:37:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c041ef1d>] move_tasks+0x26b/0x30f
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0421509>] migration_thread+0x151/0x1d3
Jan 27 11:42:37 ECDCCAM1 kernel: ut+0x13/0x8c
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:42:37 ECDCCAM1 xinetd[2261]: START: shell pid=12681 from=192.168.0.253
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:09 ECDCCAM1 send_arp[12773]: info: Killed old send_arp
process [12741]
Jan 27 11:48:09 ECDCCAM1 kernel:  =======================
Jan 27 11:48:09 ECDCCAM1 ipfail[3190]: info: Ping node count is balanced.
Jan 27 11:48:09 ECDCCAM1 send_arp[12773]: info: Killed old send_arp
process [12813]
Jan 27 11:48:09 ECDCCAM1 kernel: java          R running  2360 27916
   1         28138 27915 (NOTLB)
Jan 27 11:48:09 ECDCCAM1 rshd[12934]: root@192.168.0.253 as root:
cmd='/perfigo/common/bin/syslogconf 10.13.19.121'
Jan 27 11:48:09 ECDCCAM1 kernel: java          S 003CB1D3  2656 28138
    1         28139 27916 (NOTLB)
Jan 27 11:48:10 ECDCCAM1 ipfail[3190]: info: Link Status update: Link
10.13.230.94/10.13.230.94 now has status dead
Jan 27 11:48:10 ECDCCAM1 kernel:        e77c6d34 00000086 fee5dda6
003cb1d3 c05b56ff f770dc54 f770dc68 0000000a
Jan 27 11:48:10 ECDCCAM1 kernel:        e6b85000 feeb3186 003cb1d3
000553e0 00000000 e6b8510c cb6126e0 d5103900
Jan 27 11:48:10 ECDCCAM1 ipfail[3190]: info: Status update: Node
10.13.230.94 now has status dead
Jan 27 11:48:10 ECDCCAM1 kernel:        c06100a9 00000000 00000000
e77c6f60 00000001 ddfe584c ddfe584c ffffffff
Jan 27 11:48:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:10 ECDCCAM1 kernel:  =======================
Jan 27 11:48:10 ECDCCAM1 kernel: java          S 003CB1D8  2948 28139
    1          3825 28138 (NOTLB)
Jan 27 11:48:10 ECDCCAM1 kernel:        d5b29e94 00000086 a52a0296
003cb1d8 c0458d9b 00000202 d5103900 0000000a
Jan 27 11:48:10 ECDCCAM1 kernel:        e6b85550 a52a2d36 003cb1d8
00002aa0 00000003 e6b8565c cb62708c d5103900
Jan 27 11:48:10 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
00000286 c042c2e0 d5b29e9c cb6270d0 00000000
Jan 27 11:48:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c33e>] try_to_del_timer_sync+0x44/0x4a
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB201  2528  3825
    1         27184 28139 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        e5574e94 00000086 1a4a133e
003cb201 00000000 00000202 d5103900 00000008
Jan 27 11:48:11 ECDCCAM1 kernel:        f798a550 1a4cc5d6 003cb201
0002b298 00000000 f798a65c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 e5574e9c 00000286 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB211  2660 27184
    1         27185  3825 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        f4d92d34 00000086 e3927488
003cb211 00000003 2e04f20e 003cb1ff 0000000a
Jan 27 11:48:11 ECDCCAM1 kernel:        cc149000 e392c858 003cb211
000053d0 00000000 cc14910c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000000
003cb20f 0000000a 00000100 cb612724 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041deec>] enqueue_task+0x29/0x39
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7x37b
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB1FA  2216 31176
    1         11434 31175 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        dbe4de94 00000086 0a7271fe
003cb1fa 00000000 00000001 00000070 0000000a
Jan 27 11:48:11 ECDCCAM1 kernel:        d1bd9550 0a7338c8 003cb1fa
0000c6ca 00000000 d1bd965c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 dbe4de9c 00000286 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB092  3396 11434
    1         11486 31176 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        e74fde94 00000086 c28847fa
003cb092 00000180 00000202 d5103900 0000000a
Jan 27 11:48:12 ECDCCAM1 kernel:        d9c11550 c28909b9 003cb092
0000c1bf 00000000 d9c1165c cb6126e0 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 e74fde88 00000000
00000000 00000003 cfda9f0c cb612b9c cfda9f0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB0A7  3396 11486
    1         12400 11434 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        d9367e94 00000086 ec8dc956
003cb0a7 00000000 00000202 d5103900 00000006
Jan 27 11:48:12 ECDCCAM1 kernel:        cfd8d000 ec8e8abd 003cb0a7
0000c167 00000002 cfd8d10c cb6202a8 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 d9367e88 00000000
00000000 00000003 e61dbf0c cb6202ec e61dbf0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB1EF  3396 12400
    1         12475 11486 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        dbd1ee94 00000086 bb1b7579
003cb1ef 00000000 00000206 d5103900 00000006
Jan 27 11:48:12 ECDCCAM1 kernel:        cfc7aaa0 bb1c402d 003cb1ef
0000cab4 00000001 cfc7abac cb6194c4 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 dbd1ee88 00000000
00000000 00000003 dcf44f0c cb619980 dcf44f0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB204  3396 12475
    1         12505 12400 (NOTLB)
Jan 27 11:48:13 ECDCCAM1 kernel:        e5c8be94 00000086 e445a097
003cb204 00000000 00000000 00000000 00000006
Jan 27 11:48:13 ECDCCAM1 kernel:        cff92000 e446641a 003cb204
0000c383 00000002 cff9210c cb6202a8 d5103900
Jan 27 11:48:13 ECDCCAM1 kernel:        00000000 e5c8be88 00000000
00000000 00000003 d9d4df0c cb620764 d9d4df0c
Jan 27 11:48:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB1CB  3004 12505
    1         12558 12475 (NOTLB)
Jan 27 11:48:13 ECDCCAM1 kernel:        d4a2fd0c 00000086 91ccdd35
003cb1cb 00000006 5352bc27 00000000 00000008
Jan 27 11:48:13 ECDCCAM1 kernel:        d51c7aa0 91cce8e1 003cb1cb
00000bac 00000000 d51c7bac cb6126e0 d5103900
Jan 27 11:48:13 ECDCCAM1 kernel:        00000002 00000000 00000000
d7ce2940 f7669180 00000000 c05decfa ffffffff
Jan 27 11:48:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB1E1  2904 12558
    1         12571 12505 (NOTLB)
Jan 27 11:48:14 ECDCCAM1 kernel:        e2ae1d0c 00000086 3fbebdda
003cb1e1 00000006 59454211 00000000 00000006
Jan 27 11:48:14 ECDCCAM1 kernel:        f3d71000 3fbed5b9 003cb1e1
000017df 00000000 f3d7110c cb6126e0 d5103900
Jan 27 11:48:14 ECDCCAM1 kernel:        00000102 00000000 00000000
d751cdc0 f71e7480 00000000 c05df338 ffffffff
Jan 27 11:48:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:14 ECDCCAM1 kernel:  =======================
Jan 27 11:48:14 ECDCCAM1 kernel: java          S 003CB1E6  3004 12571
    1         12595 12558 (NOTLB)
Jan 27 11:48:14 ECDCCAM1 kernel:        eae66d0c 00000086 5684e0bb
003cb1e6 00000007 5a1da0aa 00000000 00000007
Jan 27 11:48:14 ECDCCAM1 kernel:        d202b550 56850c4e 003cb1e6
00002b93 00000000 d202b65c cb6126e0 d5103900
Jan 27 11:48:14 ECDCCAM1 kernel:        00000286 00000000 f300a800
00000246 00000000 d93e36c0 f300a800 ffffffff
Jan 27 11:48:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:15 ECDCCAM1 kernel: java          S 003CB1EF  3396 12595
    1         12598 12571 (NOTLB)
Jan 27 11:48:15 ECDCCAM1 kernel:        dcf44e94 00000086 bb1dc79c
003cb1ef 00000000 00000000 00000000 00000006
Jan 27 11:48:15 ECDCCAM1 kernel:        cfc87aa0 bb1e3d62 003cb1ef
000075c6 00000001 cfc87bac cb6194c4 d5103900
Jan 27 11:48:15 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 f7e3c000 dcf44e9c 00000286 ffffffff
Jan 27 11:48:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:15 ECDCCAM1 kernel: java          S 003CB1F0  2904 12598
    1         12608 12595 (NOTLB)
Jan 27 11:48:15 ECDCCAM1 kernel:        d16e1d0c 00000086 67e95731
003cb1f0 00000006 5d62ca6b 00000000 0000000a
Jan 27 11:48:15 ECDCCAM1 kernel:        f744e000 67e9727f 003cb1f0
00001b4e 00000000 f744e10c cb6126e0 d5103900
Jan 27 11:48:15 ECDCCAM1 kernel:        00000102 00000000 00000000
e33ce040 d203de00 00000000 c05df338 ffffffff
Jan 27 11:48:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:16 ECDCCAM1 kernel: java          S 003CB1F4  2904 12608
    1         12647 12598 (NOTLB)
Jan 27 11:48:16 ECDCCAM1 kernel:        db857d0c 00000086 c9bed819
003cb1f4 00000006 5e1d08bc 00000000 0000000a
Jan 27 11:48:16 ECDCCAM1 kernel:        cf99f000 c9bef609 003cb1f4
00001df0 00000000 cf99f10c cb6126e0 d5103900
Jan 27 11:48:16 ECDCCAM1 kernel:        00000102 00000000 00000000
e2a76040 d7a55a40 00000000 c05df338 ffffffff
Jan 27 11:48:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05acc46>] lock_sock+0x8e/0x96
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c048115d>] sys_ioctl+0x58/0x5f
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:16 ECDCCAM1 kernel:  =======================
Jan 27 11:48:16 ECDCCAM1 kernel: java          S 003CB204  3396 12647
    1         12772 12608 (NOTLB)
Jan 27 11:48:16 ECDCCAM1 kernel:        d9d4de94 00000086 e446641a
003cb204 00000000 00000000 00000000 00000006
Jan 27 11:48:16 ECDCCAM1 kernel:        d202b000 e447082b 003cb204
0000a411 00000002 d202b10c cb6202a8 d5103900
Jan 27 11:48:16 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
c042c2e0 f7e3e000 d9d4de9c 00000286 ffffffff
Jan 27 11:48:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:17 ECDCCAM1 kernel:  =======================
Jan 27 11:48:17 ECDCCAM1 kernel: httpd.worker  S 003CB25A  1752  2567
    1 25167    2653  2566 (NOTLB)
Jan 27 11:48:17 ECDCCAM1 kernel:        d39e1b68 00200086 35623c16
003cb25a c04074d6 d39e1b20 d39e1b70 00000001
Jan 27 11:48:17 ECDCCAM1 kernel:        cfe05aa0 3562c7be 003cb25a
00008ba8 00000001 cfe05bac cb6194c4 f7df8200
Jan 27 11:48:17 ECDCCAM1 kernel:        000003e8 00000000 00000000
c042c2e0 f7e3c000 d39e1b70 cb619508 c042c3f1
Jan 27 11:48:17 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885778>]
ext3_mark_inode_dirty+0x29/0x30 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0472d7d>] __find_get_block_slow+0xfb/0x105
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04730c1>] __find_get_block+0x15c/0x166
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04730fb>] __getblk+0x30/0x27a
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f88875a3>]
ext3_ordered_commit_write+0xae/0xcc [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c041e807>] try_to_wake_up+0x3e6/0x3f0
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434c0b>] remove_wait_queue+0x16/0x23
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: perl          S 003CB2A7  2508  2570
    1 12909    2571  3467 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        f721df00 00000086 85fe15e4
003cb2a7 f711cb08 f711caf8 00000001 00000009
Jan 27 11:48:18 ECDCCAM1 kernel:        d06ca000 85fec78a 003cb2a7
0000b1a6 00000002 d06ca10c cb6202a8 f711cac0
Jan 27 11:48:18 ECDCCAM1 kernel:        f711cac0 00000000 f701b284
f711cac0 00000000 00000000 f721df08 ffffffff
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04805d0>] fasync_helper+0x3c/0xae
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: tee           S 0000001A  2640  2571
    1          3566  2570 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        d3174f00 00000082 0a308454
0000001a f7f4517c f7f98648 f7f450d4 00000007
Jan 27 11:48:18 ECDCCAM1 kernel:        d2161000 0a36a414 0000001a
00061fc0 00000000 d216110c cb6126e0 f7f48580
Jan 27 11:48:18 ECDCCAM1 kernel:        d2173698 00000000 d11c4b74
f7f48580 00000000 fffac000 d3174f08 ffffffff
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04628b9>] unmap_region+0xb8/0xf0
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: diskwatchmana S 003CB25A  2668  2653
    1 12685    2722  2567 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        d0a13f00 00000082 35e50527
003cb25a f7f48e88 f7f48e78 00000001 00000007
Jan 27 11:48:18 ECDCCAM1 kernel:        d19e6000 35e5bd43 003cb25a
0000b81c 00000000 d19e610c cb6126e0 f7f48e40
Jan 27 11:48:18 ECDCCAM1 kernel:        f7f48e40 082dd100 d41efb74
f7f48e40 00000000 00000000 cb612b9c ef0f6200
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:19 ECDCCAM1 kernel:  =======================
Jan 27 11:48:19 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2476  2722
    1  2725    2732  2653 (NOTLB)
Jan 27 11:48:19 ECDCCAM1 kernel:        d195fc08 00000082 7fe56291
003cb2a7 00000000 f79d0400 f768e4c0 00000001
Jan 27 11:48:19 ECDCCAM1 kernel:        f75bb550 7fe6b7ea 003cb2a7
00015559 00000003 f75bb65c cb62708c f72bde40
Jan 27 11:48:19 ECDCCAM1 kernel:        f8885396 00000000 00000000
c042c2e0 cb740000 d195fc10 00000286 c042c3f1
Jan 27 11:48:19 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:19 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:19 ECDCCAM1 last message repeated 7 times
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0403d29>] copy_thread+0x2f/0x1e6
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c043272c>] attach_pid+0x6c/0x98
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04307fd>] sys_times+0x182/0x1c8
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:19 ECDCCAM1 kernel:  =======================
Jan 27 11:48:19 ECDCCAM1 kernel: heartbeat     S 003CB2A7  3044  2725
 2722          2726       (NOTLB)
Jan 27 11:48:19 ECDCCAM1 kernel:        cffa5f00 00000082 7e70037c
003cb2a7 00000001 0000000f 00000000 00000007
Jan 27 11:48:19 ECDCCAM1 kernel:        d294d000 7e70085e 003cb2a7
000004e2 00000003 d294d10c cb62708c f72bdc80
Jan 27 11:48:19 ECDCCAM1 kernel:        00000246 00000000 00000000
f79d0400 f884e67c 00000001 cffa5f08 ffffffff
Jan 27 11:48:19 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:19 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:20 ECDCCAM1 kernel:  =======================
Jan 27 11:48:20 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2164  2726
 2722          2727  2725 (NOTLB)
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b30c08 00000082 7fe16089
003cb2a7 d2918bd4 00000000 a0020000 00000001
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b2faa0 7fe24c64 003cb2a7
0000ebdb 00000002 d4b2fbac cb6202a8 d06c9740
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b30c18 f8cf2dea 0000000c
0000000c f8cf2eeb 0000000c d4b30c18 d2918bd4
Jan 27 11:48:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:20 ECDCCAM1 kernel:  [<f8cf2dea>]
nscatterwalk_map+0x32/0x40 [crypto_algapi]
Jan 27 11:48:20 ECDCCAM1 kernel:  [<f8cf2eeb>]
nscatterwalk_copychunks+0x9f/0xd1 [crypto_algapi]
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b9cd4>] neigh_resolve_output+0x1a6/0x1d0
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05fcda1>] xfrm4_output_finish2+0xaa/0x281
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05d064c>]
ip_push_pending_frames+0x33d/0x396
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e8f6c>]
udp_push_pending_frames+0x1ce/0x1ef
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e9b15>] udp_sendmsg+0x44e/0x514
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04059d7>] apic_timer_interrupt+0x1f/0x24
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aa412>] sock_recvmsg+0xfc/0x100
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:20 ECDCCAM1 kernel:  =======================
Jan 27 11:48:20 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2740  2727
 2722          2728  2726 (NOTLB)
Jan 27 11:48:20 ECDCCAM1 kernel:        d4914d34 00000086 75bf1217
003cb2a7 00000246 00000007 e9e41780 00000001
Jan 27 11:48:20 ECDCCAM1 kernel:        d415c000 75bf6fff 003cb2a7
00005de8 00000000 d415c10c cb6126e0 f7ba9200
Jan 27 11:48:20 ECDCCAM1 kernel:        000000a9 00000000 c05b0fec
e2532864 bfb2e4f8 000000a9 cb760ea7 ffffffff
Jan 27 11:48:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b0fec>]
skb_copy_and_csum_datagram+0x94/0x31b
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041f0e0>] rebalance_tick+0x11f/0x2e4
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:21 ECDCCAM1 kernel:  =======================
Jan 27 11:48:21 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2192  2728
 2722          2729  2727 (NOTLB)
Jan 27 11:48:21 ECDCCAM1 kernel:        d4b2dc08 00000086 7fe24c64
003cb2a7 00000002 00000003 2dfb8a40 00000001
Jan 27 11:48:21 ECDCCAM1 kernel:        d41f1000 7fe35d14 003cb2a7
000110b0 00000002 d41f110c cb6202a8 d06c9900
Jan 27 11:48:21 ECDCCAM1 kernel:        d4b2dc00 00000000 00000000
d4b2dc00 00000000 d4b2dca0 cb6202ec ffffffff
Jan 27 11:48:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041e807>] try_to_wake_up+0x3e6/0x3f0
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0607fc8>] unix_write_space+0xf/0x69
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:21 ECDCCAM1 kernel:  =======================
Jan 27 11:48:21 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2744  2729
 2722          3190  2728 (NOTLB)
Jan 27 11:48:21 ECDCCAM1 kernel:        d5872d34 00000082 774abb71
003cb2a7 00000000 0aee8500 00000000 00000001
Jan 27 11:48:21 ECDCCAM1 kernel:        f76c0aa0 774bbdb5 003cb2a7
00010244 00000000 f76c0bac cb6126e0 d5103580
Jan 27 11:48:21 ECDCCAM1 kernel:        0aeef2e4 00000000 00000000
cb619f44 d5872d68 00000082 d195fcf8 ffffffff
Jan 27 11:48:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05e83d7>] raw_recvmsg+0x6e/0x176
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:22 ECDCCAM1 kernel:  =======================
Jan 27 11:48:22 ECDCCAM1 kernel: ipfail        S 003CB2A7  2360  3190
 2722         12872  2729 (NOTLB)
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc76d34 00000086 86711c30
003cb2a7 0032bdad 2269eeaa 002cc28e 0000000a
Jan 27 11:48:22 ECDCCAM1 kernel:        f7645aa0 8671d93d 003cb2a7
0000bd0d 00000000 f7645bac cb6126e0 cfd8c3c0
Jan 27 11:48:22 ECDCCAM1 kernel:        d546cce0 00000000 00000000
c04074d6 cfc76d28 d546ce04 cb6202ec d546cce0
Jan 27 11:48:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0458ccb>]
get_page_from_freelist+0x2ba/0x333
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:22 ECDCCAM1 kernel:  =======================
Jan 27 11:48:22 ECDCCAM1 kernel: postmaster    S 003CACEC  1572  3447
 2304          3450  2313 (NOTLB)
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc9bd0c 00200086 42ba2286
003cacec 00000002 cb620e08 00000001 00000007
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc7a550 42ba2b81 003cacec
000008fb 00000001 cfc7a65c cb6194c4 f74a8ac0
Jan 27 11:48:22 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b136c0 f70615c0 00000001 c05decfa ffffffff
Jan 27 11:48:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:23 ECDCCAM1 kernel:  =======================
Jan 27 11:48:23 ECDCCAM1 kernel: postmaster    S 003CB209  1548  3450
 2304          3451  3447 (NOTLB)
Jan 27 11:48:23 ECDCCAM1 kernel:        e21a0d0c 00200082 7163fcb2
003cb209 00000006 252532a6 00000001 0000000a
Jan 27 11:48:23 ECDCCAM1 kernel:        d294d550 71640e2a 003cb209
00001178 00000002 d294d65c cb6202a8 d5103c80
Jan 27 11:48:23 ECDCCAM1 kernel:        00000002 00000000 00000001
d0b12dc0 f7061380 00000001 c05decfa ffffffff
Jan 27 11:48:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:23 ECDCCAM1 kernel:  =======================
Jan 27 11:48:23 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3451
 2304          3452  3450 (NOTLB)
Jan 27 11:48:23 ECDCCAM1 kernel:        d0b15d0c 00200086 87981f32
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:48:23 ECDCCAM1 kernel:        f770b000 879828ab 003cadc1
00000979 00000001 f770b10c cb6194c4 f7df8ac0
Jan 27 11:48:23 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcabb40 e37c0480 00000001 c05decfa ffffffff
Jan 27 11:48:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:24 ECDCCAM1 kernel:  =======================
Jan 27 11:48:24 ECDCCAM1 kernel: postmaster    S 003CAD5D  1548  3452
 2304          3453  3451 (NOTLB)
Jan 27 11:48:24 ECDCCAM1 kernel:        d0b1ad0c 00200082 43a700db
003cad5d 00000006 c81d1a1a 00000001 00000007
Jan 27 11:48:24 ECDCCAM1 kernel:        d51c7000 43a70b44 003cad5d
00000a69 00000001 d51c710c cb6194c4 f7df8c80
Jan 27 11:48:24 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca9b40 d62d49c0 00000001 c05decfa ffffffff
Jan 27 11:48:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:24 ECDCCAM1 kernel:  =======================
Jan 27 11:48:24 ECDCCAM1 kernel: postmaster    S 003CAD4E  1548  3453
 2304          3454  3452 (NOTLB)
Jan 27 11:48:24 ECDCCAM1 kernel:        d0b38d0c 00200082 b363f426
003cad4e 00000006 17960523 00000001 0000000a
Jan 27 11:48:24 ECDCCAM1 kernel:        f7140550 b363fe5e 003cad4e
00000a38 00000000 f714065c cb6126e0 f72bd040
Jan 27 11:48:24 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcab6c0 dffe7600 00000001 c05decfa ffffffff
Jan 27 11:48:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:25 ECDCCAM1 kernel:  =======================
Jan 27 11:48:25 ECDCCAM1 kernel: postmaster    S 003CAD3D  1572  3454
 2304          3455  3453 (NOTLB)
Jan 27 11:48:25 ECDCCAM1 kernel:        d0b40d0c 00200086 33513659
003cad3d 00000006 652bbf06 00000001 00000008
Jan 27 11:48:25 ECDCCAM1 kernel:        f75fbaa0 33514de7 003cad3d
0000178e 00000001 f75fbbac cb6194c4 f72bd200
Jan 27 11:48:25 ECDCCAM1 kernel:        00000002 00000000 00000001
d0b124c0 e8c628c0 00000001 c05decfa ffffffff
Jan 27 11:48:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:25 ECDCCAM1 kernel:  =======================
Jan 27 11:48:25 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3455
 2304          3456  3454 (NOTLB)
Jan 27 11:48:25 ECDCCAM1 kernel:        d0b29d0c 00200082 3f525fdb
003cae22 00000006 c6c46a92 00000001 00000007
Jan 27 11:48:25 ECDCCAM1 kernel:        f7619550 3f52799d 003cae22
000019c2 00000003 f761965c cb62708c f711cc80
Jan 27 11:48:25 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53b40 d831c800 00000001 c05decfa ffffffff
Jan 27 11:48:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:26 ECDCCAM1 kernel:  =======================
Jan 27 11:48:26 ECDCCAM1 kernel: postmaster    S 003CAD56  1548  3456
 2304          3457  3455 (NOTLB)
Jan 27 11:48:26 ECDCCAM1 kernel:        d0b57d0c 00200082 c9e7f1cd
003cad56 00000003 cb627bec 00000001 00000007
Jan 27 11:48:26 ECDCCAM1 kernel:        cfdc6550 c9e7fa44 003cad56
00000877 00000001 cfdc665c cb6194c4 cfd8c040
Jan 27 11:48:26 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53240 d39afc80 00000001 c05decfa ffffffff
Jan 27 11:48:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:27 ECDCCAM1 kernel:  =======================
Jan 27 11:48:27 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3457
 2304          3458  3456 (NOTLB)
Jan 27 11:48:27 ECDCCAM1 kernel:        d0b60d0c 00200082 3f52604d
003cae22 00000006 af747b08 00000001 00000007
Jan 27 11:48:27 ECDCCAM1 kernel:        d51fdaa0 3f526b72 003cae22
00000b25 00000001 d51fdbac cb6194c4 f72bd580
Jan 27 11:48:27 ECDCCAM1 kernel:        00000000 00000000 00000001
cf91e4c0 cfdcf680 00000001 c05decfa ffffffff
Jan 27 11:48:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:27 ECDCCAM1 kernel:  =======================
Jan 27 11:48:27 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3458
 2304          3459  3457 (NOTLB)
Jan 27 11:48:27 ECDCCAM1 kernel:        d0b50d0c 00200082 8788e6e0
003cadc1 00000100 0038a24d 00000001 00000007
Jan 27 11:48:27 ECDCCAM1 kernel:        f7469aa0 8788ee7f 003cadc1
0000079f 00000000 f7469bac cb6126e0 f74a8580
Jan 27 11:48:27 ECDCCAM1 kernel:        00000000 00000000 00000001
cfccb6c0 cfdcf380 00000001 c05decfa ffffffff
Jan 27 11:48:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:28 ECDCCAM1 kernel:  =======================
Jan 27 11:48:28 ECDCCAM1 kernel: postmaster    S 003CB2A7  1548  3459
 2304          3460  3458 (NOTLB)
Jan 27 11:48:28 ECDCCAM1 kernel:        d0b79d0c 00200082 85299456
003cb2a7 cfe05000 c0458d9b 00000044 0000000a
Jan 27 11:48:28 ECDCCAM1 kernel:        cfe05000 852cec00 003cb2a7
000357aa 00000000 cfe0510c cb6126e0 cfc67580
Jan 27 11:48:28 ECDCCAM1 kernel:        00200286 c042c3f1 00000000
00200286 d0b52940 d0b52940 cb612724 bd4ead0f
Jan 27 11:48:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05acc73>] sk_reset_timer+0xc/0x16
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060daf6>] schedule+0x9e2/0xa55
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:28 ECDCCAM1 kernel:  =======================
Jan 27 11:48:28 ECDCCAM1 kernel: postmaster    S 003CB094  1572  3460
 2304          3461  3459 (NOTLB)
Jan 27 11:48:28 ECDCCAM1 kernel:        d0b70d0c 00200082 28da522f
003cb094 00000003 cb627bec 00000001 00000007
Jan 27 11:48:28 ECDCCAM1 kernel:        f774caa0 28da683a 003cb094
0000160b 00000001 f774cbac cb6194c4 f711c580
Jan 27 11:48:28 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b52040 e0e85080 00000001 c05decfa ffffffff
Jan 27 11:48:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:29 ECDCCAM1 kernel:  =======================
Jan 27 11:48:29 ECDCCAM1 kernel: postmaster    S 003CB00A  1548  3461
 2304          3462  3460 (NOTLB)
Jan 27 11:48:29 ECDCCAM1 kernel:        d0b97d0c 00200082 74347c0f
003cb00a 00000006 488ecf9e 00000001 00000007
Jan 27 11:48:29 ECDCCAM1 kernel:        cfdcc550 743493c1 003cb00a
000017b2 00000003 cfdcc65c cb62708c f74a8040
Jan 27 11:48:29 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb16c0 f7061080 00000001 c05decfa ffffffff
Jan 27 11:48:29 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:30 ECDCCAM1 kernel:  =======================
Jan 27 11:48:30 ECDCCAM1 kernel: postmaster    S 003CB0B6  1572  3462
 2304          3463  3461 (NOTLB)
Jan 27 11:48:30 ECDCCAM1 kernel:        d0ba0d0c 00200082 cad156e7
003cb0b6 00000006 f20cd69b 00000001 0000000a
Jan 27 11:48:30 ECDCCAM1 kernel:        d4b67550 cad162ff 003cb0b6
00000c18 00000001 d4b6765c cb6194c4 f7f48040
Jan 27 11:48:30 ECDCCAM1 kernel:        00000002 00000000 00000001
d0bb36c0 f408c3c0 00000001 c05decfa ffffffff
Jan 27 11:48:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:30 ECDCCAM1 kernel:  =======================
Jan 27 11:48:30 ECDCCAM1 kernel: postmaster    S 003CB131  1548  3463
 2304          3464  3462 (NOTLB)
Jan 27 11:48:30 ECDCCAM1 kernel:        d0bacd0c 00200086 c4e4424b
003cb131 00000006 98e32794 00000001 0000000a
Jan 27 11:48:30 ECDCCAM1 kernel:        f774c550 c4e454c8 003cb131
0000127d 00000001 f774c65c cb6194c4 f7f24900
Jan 27 11:48:30 ECDCCAM1 kernel:        00000002 00200286 00000000
d0bb2dc0 e444ee00 00000001 cb619980 00000001
Jan 27 11:48:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:31 ECDCCAM1 kernel:  =======================
Jan 27 11:48:31 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3464
 2304         13412  3463 (NOTLB)
Jan 27 11:48:31 ECDCCAM1 kernel:        d0bbbd0c 00200086 8788e58a
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:48:31 ECDCCAM1 kernel:        d2914550 8788fcc8 003cadc1
0000173e 00000003 d291465c cb62708c f7771ac0
Jan 27 11:48:31 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb0dc0 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:48:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:31 ECDCCAM1 kernel:  =======================
Jan 27 11:48:31 ECDCCAM1 kernel: mingetty      S 00000031  3020  3566
    1          3567  2571 (NOTLB)
Jan 27 11:48:31 ECDCCAM1 kernel:        d20a3ee4 00000086 e8c868e2
00000031 00000020 d2808600 d280c29e 00000007
Jan 27 11:48:31 ECDCCAM1 kernel:        cfc7a000 e8c92780 00000031
0000be9e 00000001 cfc7a10c cb6194c4 d4b63900
Jan 27 11:48:31 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  3072  3567
    1          3568  3566 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        cfda7ee4 00000082 e8c7d541
00000031 00000020 d2814600 d280e29e 00000007
Jan 27 11:48:32 ECDCCAM1 kernel:        d41f1aa0 e8c868e2 00000031
000093a1 00000001 d41f1bac cb6194c4 f7f62e40
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  2660  3568
    1          3569  3567 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        d2028ee4 00000082 e8ca15cb
00000031 00000020 d2826a00 d282b29e 00000006
Jan 27 11:48:32 ECDCCAM1 kernel:        d41d0550 e8cab32c 00000031
00009d61 00000001 d41d065c cb6194c4 f7ba9e40
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  3072  3569
    1          3570  3568 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        d0be8ee4 00000086 e8c92780
00000031 00000020 d2826c00 d611629e 00000007
Jan 27 11:48:32 ECDCCAM1 kernel:        f7d22550 e8c9e75c 00000031
0000bfdc 00000001 f7d2265c cb6194c4 f77713c0
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:33 ECDCCAM1 kernel:  =======================
Jan 27 11:48:33 ECDCCAM1 kernel: mingetty      S 00000031  3016  3570
    1          3571  3569 (NOTLB)
Jan 27 11:48:33 ECDCCAM1 kernel:        cfdcaee4 00000086 e8cab32c
00000031 00000020 d2031e00 d282c29e 00000004
Jan 27 11:48:33 ECDCCAM1 kernel:        d41d0000 e8cb65fd 00000031
0000b2d1 00000001 d41d010c cb6194c4 cfc673c0
Jan 27 11:48:33 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:33 ECDCCAM1 kernel:  =======================
Jan 27 11:48:33 ECDCCAM1 kernel: agetty        S 00000032  2412  3571
    1          3646  3570 (NOTLB)
Jan 27 11:48:33 ECDCCAM1 kernel:        d51b7ee4 00000082 290b7071
00000032 000000ca c04546b7 00000000 00000008
Jan 27 11:48:33 ECDCCAM1 kernel:        d51c7550 290c069f 00000032
0000962e 00000002 d51c765c cb6202a8 cfd84580
Jan 27 11:48:33 ECDCCAM1 kernel:        cb5f8e20 00000000 00000000
00000000 c07ce7e0 c07ce7e0 c07ce7e0 ffffffff
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:34 ECDCCAM1 kernel:  =======================
Jan 27 11:48:34 ECDCCAM1 kernel: snmpd         S 003CB25A  1604  3646
    1          3651  3571 (NOTLB)
Jan 27 11:48:34 ECDCCAM1 kernel:        d283db68 00200086 36bd040f
003cb25a cfdccaa0 d283db7c c060dae0 00000009
Jan 27 11:48:34 ECDCCAM1 kernel:        cfdccaa0 36c41e1f 003cb25a
00071a10 00000002 cfdccbac cb6202a8 f7771200
Jan 27 11:48:34 ECDCCAM1 kernel:        000402af 00000002 00200286
c042c2e0 f7e3e000 d283db70 cb620764 c042c3f1
Jan 27 11:48:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:34 ECDCCAM1 last message repeated 4 times
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041f0e0>] rebalance_tick+0x11f/0x2e4
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0458ccb>]
get_page_from_freelist+0x2ba/0x333
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e8888>] scnprintf+0x1f/0x2b
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0487c1f>] touch_atime+0x60/0x91
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c047c654>] pipe_readv+0x315/0x321
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:34 ECDCCAM1 kernel:  =======================
Jan 27 11:48:34 ECDCCAM1 kernel: snmpd         S 00000031  2868  3651
    1          4053  3646 (NOTLB)
Jan 27 11:48:34 ECDCCAM1 kernel:        d2863d18 00200086 f944dcf2
00000031 c05ba88b 00000e3e 00000000 00000001
Jan 27 11:48:34 ECDCCAM1 kernel:        cfdc6000 f946068e 00000031
0001299c 00000001 cfdc610c cb6194c4 f7771200
Jan 27 11:48:34 ECDCCAM1 kernel:        c06100a9 00000000 c0405a89
d2863f4c 0000010f d587a000 d587a0a0 ffffffff
Jan 27 11:48:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c05ba88b>] rtnetlink_dump_ifinfo+0x4a/0x6c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0405a89>] error_code+0x39/0x40
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05c73d6>] netlink_recvmsg+0x46/0x281
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05c7223>] netlink_sendmsg+0x277/0x284
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c048595f>] d_alloc+0x14f/0x17d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0484f20>] d_rehash+0x1c/0x2b
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:35 ECDCCAM1 kernel:  =======================
Jan 27 11:48:35 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 13412
 2304         12049  3464 (NOTLB)
Jan 27 11:48:35 ECDCCAM1 kernel:        f3bf3d0c 00200086 8779a572
003cadc1 00000000 cb613240 00000001 00000007
Jan 27 11:48:35 ECDCCAM1 kernel:        f59b5aa0 8779b14e 003cadc1
00000bdc 00000000 f59b5bac cb6126e0 f7f623c0
Jan 27 11:48:35 ECDCCAM1 kernel:        00000000 00000000 00000001
d105d240 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:48:35 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:36 ECDCCAM1 kernel:  =======================
Jan 27 11:48:36 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 12049
 2304               13412 (NOTLB)
Jan 27 11:48:36 ECDCCAM1 kernel:        e4e88d0c 00200086 8772ad4a
003cadc1 cb6202ec cfdc6550 00000001 00000007
Jan 27 11:48:36 ECDCCAM1 kernel:        dbe24000 8772b8d5 003cadc1
00000b8b 00000002 dbe2410c cb6202a8 f7f48ac0
Jan 27 11:48:36 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca96c0 d667dd80 00000001 c05decfa ffffffff
Jan 27 11:48:36 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
