Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0KFOFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:05:08 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:53596 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0KFOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:05:06 -0400
Message-ID: <4CD56087.9000009@xs4all.nl>
Date: Sat, 06 Nov 2010 15:04:55 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Karsten Keil <isdn@linux-pingi.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
References: <4C864143.5090803@xs4all.nl> <201009072145.10946.arnd@arndb.de>
In-Reply-To: <201009072145.10946.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-07 21:45, Arnd Bergmann wrote:
> Can you send the output of "head -n 20 /proc/*/stack"? If
> CONFIG_LOCKDEP gives you more data, that would be even better.

My most recent post about this issue, occurring on 2.6.35.7, had a
kernel with this:
# gzip -dc /proc/config.gz |grep LOCKDEP
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set

Stacks below, after occurring on 2.6.35.7:

# head -n 20 /proc/*/stack
==> /proc/1077/stack <==
[<c10fe6a5>] kjournald+0x171/0x1e2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/113/stack <==
[<c1066639>] bdi_sync_supers+0x20/0x33
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/11418/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/115/stack <==
[<c1066ed6>] bdi_forker_task+0x155/0x25f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1179/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/117/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/118/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/119/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/11/stack <==
[<c1034242>] async_manager_thread+0x92/0xb2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/120/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1386/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1451/stack <==
[<c109269a>] bdi_writeback_task+0x77/0xd9
[<c1067037>] bdi_start_fn+0x57/0xad
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1485/stack <==
[<c10fe6a5>] kjournald+0x171/0x1e2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1486/stack <==
[<c10fe6a5>] kjournald+0x171/0x1e2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1487/stack <==
[<c10fe6a5>] kjournald+0x171/0x1e2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1488/stack <==
[<c10fe6a5>] kjournald+0x171/0x1e2
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1489/stack <==
[<c1104e1d>] kjournald2+0x15b/0x1cf
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1490/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1491/stack <==
[<c1104e1d>] kjournald2+0x15b/0x1cf
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1492/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1493/stack <==
[<c1104e1d>] kjournald2+0x15b/0x1cf
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1494/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1495/stack <==
[<c1104e1d>] kjournald2+0x15b/0x1cf
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1496/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1497/stack <==
[<c1104e1d>] kjournald2+0x15b/0x1cf
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1498/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1508/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086b55>] sys_ppoll+0x87/0xf6
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/1509/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086b55>] sys_ppoll+0x87/0xf6
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/1510/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1516/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/1517/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/16758/stack <==
[<c118731a>] tty_unthrottle+0x13/0x3a
[<c1185f4e>] reset_buffer_flags+0xd4/0xd9
[<c1185f60>] n_tty_flush_buffer+0xd/0x63
[<c11888a7>] tty_ldisc_flush+0x1f/0x34
[<c120797c>] isdn_tty_modem_result+0x342/0x37c
[<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
[<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
[<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
[<c118789b>] set_termios+0x318/0x397
[<c1187b41>] tty_mode_ioctl+0x178/0x2db
[<c1187de8>] n_tty_ioctl_helper+0x144/0x154
[<c11854d9>] n_tty_ioctl+0x97/0xa0
[<c1183ccd>] tty_ioctl+0x699/0x6d3
[<c108557c>] vfs_ioctl+0x27/0x91
[<c1085ade>] do_vfs_ioctl+0x44b/0x47f
[<c1085b53>] sys_ioctl+0x41/0x61
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/1692/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/19110/stack <==
[<c11096d0>] sys_semtimedop+0x6ee/0x828
[<c110b6b9>] sys_ipc+0x49/0x130
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/19748/stack <==
[<c10a1516>] sys_epoll_wait+0x145/0x1e3
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/19773/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/1/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2002/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2005/stack <==
[<c101feb5>] do_syslog+0xd3/0x340
[<c10b7ed3>] kmsg_read+0x3b/0x44
[<c10b0ea1>] proc_reg_read+0x6a/0x84
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2047/stack <==
[<c1027e71>] sys_rt_sigsuspend+0x98/0xb1
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20615/stack <==
[<c1021703>] do_wait+0x14d/0x1aa
[<c10217e7>] sys_wait4+0x87/0xa0
[<c1021813>] sys_waitpid+0x13/0x15
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20617/stack <==
[<c10a1516>] sys_epoll_wait+0x145/0x1e3
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20619/stack <==
[<c1080856>] pipe_wait+0x4a/0x62
[<c1080f09>] pipe_read+0x279/0x2dc
[<c107a465>] do_sync_read+0x89/0xc4
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2061/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20792/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20794/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20802/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2082/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20902/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2090/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/20947/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/209/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/2103/stack <==
[<c10a1516>] sys_epoll_wait+0x145/0x1e3
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2106/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/210/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/2131/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/214/stack <==
[<c11df5b1>] hub_thread+0xb32/0xbb9
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/2161/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2164/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2167/stack <==
[<c1080856>] pipe_wait+0x4a/0x62
[<c1080f09>] pipe_read+0x279/0x2dc
[<c107a465>] do_sync_read+0x89/0xc4
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2170/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/217/stack <==
[<c11eb28a>] serio_thread+0x259/0x27f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/2198/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/219/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/2220/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2250/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2258/stack <==
[<c1027c85>] sys_pause+0x13/0x1a
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2270/stack <==
[<c1268454>] inet_csk_accept+0x9d/0x197
[<c1283bc9>] inet_accept+0x20/0x9b
[<c1231721>] sys_accept4+0xfb/0x1d2
[<c1231c83>] sys_socketcall+0x194/0x1a5
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2295/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2317/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2398/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2406/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2414/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2415/stack <==
[<c1298bab>] unix_stream_recvmsg+0x1f8/0x4bd
[<c122fe06>] sock_aio_read+0x10b/0x115
[<c107a465>] do_sync_read+0x89/0xc4
[<c107adb8>] vfs_read+0x98/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2423/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2431/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2432/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2477/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2497/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2510/stack <==
[<c1032a38>] hrtimer_nanosleep+0x82/0xda
[<c1032ad4>] sys_nanosleep+0x44/0x51
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2517/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2519/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2521/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2523/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2525/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2527/stack <==
[<c1185c1c>] n_tty_read+0x395/0x5f3
[<c118203f>] tty_read+0x67/0x9e
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2545/stack <==
[<c1027c85>] sys_pause+0x13/0x1a
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/26042/stack <==
[<c1298bab>] unix_stream_recvmsg+0x1f8/0x4bd
[<c122fe06>] sock_aio_read+0x10b/0x115
[<c107a465>] do_sync_read+0x89/0xc4
[<c107adb8>] vfs_read+0x98/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/26050/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/26055/stack <==
[<c1021703>] do_wait+0x14d/0x1aa
[<c10217e7>] sys_wait4+0x87/0xa0
[<c1021813>] sys_waitpid+0x13/0x15
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/29184/stack <==
[<c10a1516>] sys_epoll_wait+0x145/0x1e3
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/29193/stack <==
[<c11096d0>] sys_semtimedop+0x6ee/0x828
[<c110b6b9>] sys_ipc+0x49/0x130
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/29376/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1086a4f>] do_sys_poll+0x350/0x3cf
[<c1086c03>] sys_poll+0x3f/0x88
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/29574/stack <==
[<c11096d0>] sys_semtimedop+0x6ee/0x828
[<c110b6b9>] sys_ipc+0x49/0x130
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/29615/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/2/stack <==
[<c102f6f6>] kthreadd+0x4d/0xbd
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/30863/stack <==
[<c1021703>] do_wait+0x14d/0x1aa
[<c10217e7>] sys_wait4+0x87/0xa0
[<c1021813>] sys_waitpid+0x13/0x15
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/30872/stack <==
[<c1021703>] do_wait+0x14d/0x1aa
[<c10217e7>] sys_wait4+0x87/0xa0
[<c1021813>] sys_waitpid+0x13/0x15
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/336/stack <==
[<c104daf1>] watchdog+0x30/0x1fe
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/337/stack <==
[<c1062c25>] kswapd+0x604/0x614
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/3580/stack <==
[<c1080856>] pipe_wait+0x4a/0x62
[<c1080f09>] pipe_read+0x279/0x2dc
[<c107a465>] do_sync_read+0x89/0xc4
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/3581/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/388/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/3/stack <==
[<c10230ec>] run_ksoftirqd+0x3d/0xf4
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/402/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/4454/stack <==
[<c108667e>] poll_schedule_timeout+0x27/0x3e
[<c1087183>] do_select+0x4f8/0x533
[<c1087375>] core_sys_select+0x1b7/0x252
[<c10875b8>] sys_select+0x68/0x84
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff

==> /proc/4/stack <==
[<c104d939>] watchdog+0x50/0x79
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/516/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/524/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/5/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/6/stack <==
[<c102cd03>] worker_thread+0x97/0x22f
[<c102f6a4>] kthread+0x69/0x6e
[<c1002d7e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

==> /proc/self/stack <==
[<c1009ae6>] save_stack_trace_tsk+0x17/0x33
[<c10b1af4>] proc_pid_stack+0x4a/0x76
[<c10b2cc8>] proc_single_show+0x48/0x6c
[<c108f539>] seq_read+0x160/0x315
[<c107ada8>] vfs_read+0x88/0x110
[<c107aec7>] sys_read+0x3b/0x60
[<c10027d3>] sysenter_do_call+0x12/0x2d
[<ffffffff>] 0xffffffff


Udo
