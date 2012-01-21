Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2AUO6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:58:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63937 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AUO6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:58:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAGAKE8_b_Omxzg4C-VMiuM9aEhnRPkPD9=5DW9retGfcfOhBuQ@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
	<CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
	<CAO+b5-pZofpN7-e8H+toE98j24fby5u8_Nzfzkz_S31u5wDmwA@mail.gmail.com>
	<CAGAKE88--L1igeZFusU=TxRD6fyfKWZYhn7az6-xkS_mtVg8CA@mail.gmail.com>
	<CAGAKE8_b_Omxzg4C-VMiuM9aEhnRPkPD9=5DW9retGfcfOhBuQ@mail.gmail.com>
Date: Sat, 21 Jan 2012 16:58:29 +0200
Message-ID: <CAGAKE8-3k0FN5B91ff2XFpYuHfwB-bmr4b7EBEe-aSWfQr1mSw@mail.gmail.com>
Subject: Re: [Scst-devel] BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: kordex <kordex@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, peterz@infradead.org,
        kvm@vger.kernel.org, avi@redhat.com,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 21:12, kordex <kordex@gmail.com> wrote:
> And due to dmesg got full, had to dig it from syslog:
>
> root@teletex:/var/log# cat messages|tail -n 4825
> Jan 19 11:01:35 teletex kernel: br0: port 4(vnet16) entering forwarding state
> Jan 19 11:25:38 teletex kernel: fffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040da702b0
> 0  3133      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da70000 0000000000000082
> 0000000000000246 ffff88040da74680
> Jan 19 11:25:38 teletex kernel: ffff880405830000 ffff880405831fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405830000 ffff880405830010
> ffff880405831fd8 ffff88040da70000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040da74930
> 0  3134      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da74680 0000000000000082
> 0000000000000246 ffff88040cad0bc0
> Jan 19 11:25:38 teletex kernel: ffff880405832000 ffff880405833fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405832000 ffff880405832010
> ffff880405833fd8 ffff88040da74680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040cad0e70
> 0  3135      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040cad0bc0 0000000000000082
> 0000000000000246 ffff88040cad0000
> Jan 19 11:25:38 teletex kernel: ffff880405834000 ffff880405835fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405834000 ffff880405834010
> ffff880405835fd8 ffff88040cad0bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff813192ca>] ? vt_ioctl+0x3a/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040cad02b0
> 0  3136      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040cad0000 0000000000000082
> 0000000000000246 ffff88040cad5e00
> Jan 19 11:25:38 teletex kernel: ffff880405836000 ffff880405837fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405836000 ffff880405836010
> ffff880405837fd8 ffff88040cad0000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040cad60b0
> 0  3137      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040cad5e00 0000000000000082
> 0000000000000246 ffff88040cad1780
> Jan 19 11:25:38 teletex kernel: ffff880405838000 ffff880405839fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405838000 ffff880405838010
> ffff880405839fd8 ffff88040cad5e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040cad1a30
> 0  3138      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040cad1780 0000000000000082
> 0000000000000246 ffff88040d8a6fa0
> Jan 19 11:25:38 teletex kernel: ffff88040583a000 ffff88040583bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040583a000 ffff88040583a010
> ffff88040583bfd8 ffff88040cad1780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040d8a7250
> 0  3139      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a6fa0 0000000000000082
> 0000000000000246 ffff88040d8a1780
> Jan 19 11:25:38 teletex kernel: ffff88040583c000 ffff88040583dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040583c000 ffff88040583c010
> ffff88040583dfd8 ffff88040d8a6fa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040d8a1a30
> 0  3140      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a1780 0000000000000082
> 0000000000000246 ffff88040d8a11a0
> Jan 19 11:25:38 teletex kernel: ffff88040583e000 ffff88040583ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040583e000 ffff88040583e010
> ffff88040583ffd8 ffff88040d8a1780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040d8a1450
> 0  3141      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a11a0 0000000000000082
> 0000000000000246 ffff88040d86e3e0
> Jan 19 11:25:38 teletex kernel: ffff880407080000 ffff880407081fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407080000 ffff880407080010
> ffff880407081fd8 ffff88040d8a11a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a0d7>] ?
> system_call_after_swapgs+0x17/0x65
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040d86e690
> 0  3142      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d86e3e0 0000000000000082
> 0000000000000246 ffff88040d86d240
> Jan 19 11:25:38 teletex kernel: ffff880407082000 ffff880407083fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407082000 ffff880407082010
> ffff880407083fd8 ffff88040d86e3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040d86d4f0
> 0  3143      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d86d240 0000000000000082
> 0000000000000246 ffff880407088000
> Jan 19 11:25:38 teletex kernel: ffff880407084000 ffff880407085fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407084000 ffff880407084010
> ffff880407085fd8 ffff88040d86d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff8804070882b0
> 0  3144      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407088000 0000000000000082
> 0000000000000246 ffff8804070885e0
> Jan 19 11:25:38 teletex kernel: ffff880407086000 ffff880407087fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407086000 ffff880407086010
> ffff880407087fd8 ffff880407088000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff880407088890
> 0  3145      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8804070885e0 0000000000000082
> 0000000000000246 ffff880407088bc0
> Jan 19 11:25:38 teletex kernel: ffff880407090000 ffff880407091fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407090000 ffff880407090010
> ffff880407091fd8 ffff8804070885e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff880407088e70
> 0  3146      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407088bc0 0000000000000082
> 0000000000000246 ffff8804070891a0
> Jan 19 11:25:38 teletex kernel: ffff880407092000 ffff880407093fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407092000 ffff880407092010
> ffff880407093fd8 ffff880407088bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff880407089450
> 0  3147      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8804070891a0 0000000000000082
> 0000000000000246 ffff880407089780
> Jan 19 11:25:38 teletex kernel: ffff880407094000 ffff880407095fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407094000 ffff880407094010
> ffff880407095fd8 ffff8804070891a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff880407089a30
> 0  3148      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407089780 0000000000000082
> 0000000000000246 ffff880407089d60
> Jan 19 11:25:38 teletex kernel: ffff880407096000 ffff880407097fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407096000 ffff880407096010
> ffff880407097fd8 ffff880407089780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549798>] ?
> _raw_spin_unlock_irqrestore+0x8/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708a010
> 0  3149      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407089d60 0000000000000082
> 0000000000000246 ffff88040708a340
> Jan 19 11:25:38 teletex kernel: ffff880407098000 ffff880407099fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407098000 ffff880407098010
> ffff880407099fd8 ffff880407089d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708a5f0
> 0  3150      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708a340 0000000000000082
> 0000000000000246 ffff88040708a920
> Jan 19 11:25:38 teletex kernel: ffff88040709a000 ffff88040709bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040709a000 ffff88040709a010
> ffff88040709bfd8 ffff88040708a340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708abd0
> 0  3151      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708a920 0000000000000082
> 0000000000000246 ffff88040708af00
> Jan 19 11:25:38 teletex kernel: ffff88040709c000 ffff88040709dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040709c000 ffff88040709c010
> ffff88040709dfd8 ffff88040708a920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708b1b0
> 0  3152      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708af00 0000000000000082
> 0000000000000246 ffff88040708b4e0
> Jan 19 11:25:38 teletex kernel: ffff88040709e000 ffff88040709ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040709e000 ffff88040709e010
> ffff88040709ffd8 ffff88040708af00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708b790
> 0  3153      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708b4e0 0000000000000082
> 0000000000000246 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880407fe0000 ffff880407fe1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fe0000 ffff880407fe0010
> ffff880407fe1fd8 ffff88040708b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708bd70
> 0  3154      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708bac0 0000000000000082
> 0000000000000246 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880407fe2000 ffff880407fe3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fe2000 ffff880407fe2010
> ffff880407fe3fd8 ffff88040708bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708c350
> 0  3155      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708c0a0 0000000000000082
> 0000000000000246 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880407fe4000 ffff880407fe5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fe4000 ffff880407fe4010
> ffff880407fe5fd8 ffff88040708c0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708c930
> 0  3156      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708c680 0000000000000082
> 0000000000000246 ffff88040708cc60
> Jan 19 11:25:38 teletex kernel: ffff880407fe6000 ffff880407fe7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fe6000 ffff880407fe6010
> ffff880407fe7fd8 ffff88040708c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708cf10
> 0  3157      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708cc60 0000000000000082
> 0000000000000246 ffff88040708d240
> Jan 19 11:25:38 teletex kernel: ffff880407fe8000 ffff880407fe9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fe8000 ffff880407fe8010
> ffff880407fe9fd8 ffff88040708cc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708d4f0
> 0  3158      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708d240 0000000000000082
> 0000000000000246 ffff88040708d820
> Jan 19 11:25:38 teletex kernel: ffff880407fea000 ffff880407febfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fea000 ffff880407fea010
> ffff880407febfd8 ffff88040708d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708dad0
> 0  3159      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708d820 0000000000000082
> 0000000000000246 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880407fec000 ffff880407fedfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fec000 ffff880407fec010
> ffff880407fedfd8 ffff88040708d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708e0b0
> 0  3160      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708de00 0000000000000082
> 0000000000000246 ffff88040708e3e0
> Jan 19 11:25:38 teletex kernel: ffff880407fee000 ffff880407feffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407fee000 ffff880407fee010
> ffff880407feffd8 ffff88040708de00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708e690
> 0  3161      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708e3e0 0000000000000082
> 0000000000000246 ffff88040708e9c0
> Jan 19 11:25:38 teletex kernel: ffff880407ff0000 ffff880407ff1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407ff0000 ffff880407ff0010
> ffff880407ff1fd8 ffff88040708e3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2a26>] ?
> __rwsem_do_wake+0x186/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810894f6>] ? up_read+0x16/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708ec70
> 0  3162      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708e9c0 0000000000000082
> 0000000000000246 ffff88040708efa0
> Jan 19 11:25:38 teletex kernel: ffff880407ff2000 ffff880407ff3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407ff2000 ffff880407ff2010
> ffff880407ff3fd8 ffff88040708e9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708f250
> 0  3163      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708efa0 0000000000000082
> 0000000000000246 ffff88040708f580
> Jan 19 11:25:38 teletex kernel: ffff880407ff4000 ffff880407ff5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407ff4000 ffff880407ff4010
> ffff880407ff5fd8 ffff88040708efa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040708f830
> 0  3164      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040708f580 0000000000000082
> 0000000000000246 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880407ff6000 ffff880407ff7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407ff6000 ffff880407ff6010
> ffff880407ff7fd8 ffff88040708f580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810dc322>] ?
> page_add_new_anon_rmap+0x52/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: console-kit-dae S ffff88040da3c930
> 0  3166      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3c680 0000000000000082
> ffff880400000000 ffff88040daaf580
> Jan 19 11:25:38 teletex kernel: ffff880407de0000 ffff880407de1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880407de0000 ffff880407de0010
> ffff880407de1fd8 ffff88040da3c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ac2d2>] ?
> cpumask_next_and+0x22/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81103f61>] ? pipe_wait+0x51/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dcd4>] ?
> check_preempt_wakeup+0xb4/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110498d>] ? pipe_read+0x38d/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: getty           S ffff880406e0bd70
> 0  4123      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0bac0 0000000000000082
> ffffffff00000000 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff88040563e000 ffff88040563ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040563e000 ffff88040563e010
> ffff88040563ffd8 ffff880406e0bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108a4a3>] ?
> __atomic_notifier_call_chain+0x43/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff81320805>] ? notify_update+0x25/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547c5d>] ?
> schedule_timeout+0x1bd/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107ee12>] ? flush_work+0x12/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8131339e>] ?
> copy_from_read_buf+0x6e/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff813139a7>] ? n_tty_read+0x537/0x850
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130d3d5>] ? tty_read+0xb5/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff880166e4e0b0
> 0 14527      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4de00 0000000000000046
> ffff88041fd10380 ffff880166e4bac0
> Jan 19 11:25:38 teletex kernel: ffff88015cb1a000 ffff88015cb1bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015cb1a000 ffff88015cb1a010
> ffff88015cb1bfd8 ffff880166e4de00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff880166e4bd70
> 0 14529      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4bac0 0000000000000046
> ffffffff812b22bc ffff880166e48bc0
> Jan 19 11:25:38 teletex kernel: ffff8801fab94000 ffff8801fab95fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801fab94000 ffff8801fab94010
> ffff8801fab95fd8 ffff880166e4bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff880166e4cf10
> 0 14530      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4cc60 0000000000000046
> ffffffff8105fb03 ffff880166e4d820
> Jan 19 11:25:38 teletex kernel: ffff8801bc3f0000 ffff8801bc3f1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801bc3f0000 ffff8801bc3f0010
> ffff8801bc3f1fd8 ffff880166e4cc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kmirrord        S ffff880166e4f830
> 0 14535      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4f580 0000000000000046
> ffff88007642be40 ffff8801f994c0a0
> Jan 19 11:25:38 teletex kernel: ffff8804068ba000 ffff8804068bbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8804068ba000 ffff8804068ba010
> ffff8804068bbfd8 ffff880166e4f580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81450120>] ? do_reads+0x230/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kcopyd          S ffff880166e49450
> 0 14536      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e491a0 0000000000000046
> ffff88011013a000 ffff880406e085e0
> Jan 19 11:25:38 teletex kernel: ffff88011013a000 ffff88011013bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011013a000 ffff88011013a010
> ffff88011013bfd8 ffff880166e491a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff880406e0c350
> 0 14537      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0c0a0 0000000000000046
> ffffffff812b22bc ffff880406e085e0
> Jan 19 11:25:38 teletex kernel: ffff88011d7a2000 ffff88011d7a3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011d7a2000 ffff88011d7a2010
> ffff88011d7a3fd8 ffff880406e0c0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff880406e0c930
> 0 14539      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0c680 0000000000000046
> ffff88018a01c000 ffff880406e08000
> Jan 19 11:25:38 teletex kernel: ffff88018a01c000 ffff88018a01dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88018a01c000 ffff88018a01c010
> ffff88018a01dfd8 ffff880406e0c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kmirrord        S ffff880132e1c930
> 0 14542      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1c680 0000000000000046
> ffffffff8105fb03 ffff88040d913ac0
> Jan 19 11:25:38 teletex kernel: ffff88010a9c0000 ffff88010a9c1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010a9c0000 ffff88010a9c0010
> ffff88010a9c1fd8 ffff880132e1c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e3f6>] ? task_rq_lock+0x56/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106281c>] ?
> set_cpus_allowed_ptr+0x8c/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kcopyd          S ffff880132e1abd0
> 0 14546      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1a920 0000000000000046
> ffffffff8105fb03 ffff880132e18000
> Jan 19 11:25:38 teletex kernel: ffff880183d16000 ffff880183d17fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880183d16000 ffff880183d16010
> ffff880183d17fd8 ffff880132e1a920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: jbd2/dm-45-8    S ffff88015baac350
> 0 18293      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baac0a0 0000000000000046
> ffff880119d29024 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff88012b43e000 ffff88012b43ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012b43e000 ffff88012b43e010
> ffff88012b43ffd8 ffff88015baac0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b65b2>] ? kjournald2+0x192/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b6420>] ? commit_timeout+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b6420>] ? commit_timeout+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: ext4-dio-unwrit S ffff88015baa82b0
> 0 18294      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baa8000 0000000000000046
> ffff88041fc10380 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801b3c18000 ffff8801b3c19fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b3c18000 ffff8801b3c18010
> ffff8801b3c19fd8 ffff88015baa8000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff88017e6cf250
> 0 18857      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cefa0 0000000000000046
> ffff88017e6ce9c0 ffff88040da74c60
> Jan 19 11:25:38 teletex kernel: ffff8801be8ba000 ffff8801be8bbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801be8ba000 ffff8801be8ba010
> ffff8801be8bbfd8 ffff88017e6cefa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: loop7           S ffff88017e6cabd0
> 0  8455      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6ca920 0000000000000046
> ffff880108201de0 ffff8801cf385e00
> Jan 19 11:25:38 teletex kernel: ffff880108200000 ffff880108201fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880108200000 ffff880108200010
> ffff880108201fd8 ffff88017e6ca920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134264a>] ? loop_thread+0x13a/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81342510>] ?
> do_bio_filebacked+0x280/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff81342510>] ?
> do_bio_filebacked+0x280/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: loop6           S ffff88017e6cf830
> 0 24605      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cf580 0000000000000046
> ffff880100000000 ffff88040d86d820
> Jan 19 11:25:38 teletex kernel: ffff880105c9a000 ffff880105c9bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880105c9a000 ffff880105c9a010
> ffff880105c9bfd8 ffff88017e6cf580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134264a>] ? loop_thread+0x13a/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81342510>] ?
> do_bio_filebacked+0x280/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff81342510>] ?
> do_bio_filebacked+0x280/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kdmflush        S ffff8801cf386c70
> 0 24943      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf3869c0 0000000000000046
> 00042dc400042dbc ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88011d93c000 ffff88011d93dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011d93c000 ffff88011d93c010
> ffff88011d93dfd8 ffff8801cf3869c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: cron            S ffff88040d9a3d70
> 0 21885      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d9a3ac0 0000000000000086
> ffff8800604d1fe8 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801aec7c000 ffff8801aec7dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801aec7c000 ffff8801aec7c010
> ffff8801aec7dfd8 ffff88040d9a3ac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81548715>] ? do_nanosleep+0x95/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81089387>] ?
> hrtimer_nanosleep+0xa7/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077c95>] ? sigprocmask+0x45/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108949d>] ? sys_nanosleep+0x6d/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: udevd           S ffff88017e6cc350
> 0 21963      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cc0a0 0000000000000086
> 000000004f17dbe0 ffff880117a25820
> Jan 19 11:25:38 teletex kernel: ffff88018e7ee000 ffff88018e7effd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88018e7ee000 ffff88018e7ee010
> ffff88018e7effd8 ffff88017e6cc0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474965>] ? sock_recvmsg+0xb5/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff814e9708>] ? unix_peer_get+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eaf95>] ?
> unix_dgram_poll+0xd5/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff811134c5>] ? __destroy_inode+0x15/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d9a40>] ? mmap_region+0x240/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ntpd            S ffff880132e1b1b0
> 0 27698      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1af00 0000000000000082
> 0000000000000002 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88017c6c2000 ffff88017c6c3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017c6c2000 ffff88017c6c2010
> ffff88017c6c3fd8 ffff880132e1af00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124e5b>] ? __getblk+0x1b/0x310
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81181801>] ?
> ext4_mark_iloc_dirty+0x331/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81112a68>] ? touch_atime+0x58/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084416>] ?
> do_schedule_next_timer+0x46/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff810324da>] ? do_signal+0x21a/0x770
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1b44>] ? kmem_cache_free+0x14/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103b264>] ? fpu_finit+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103b2ba>] ? init_fpu+0x3a/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103be88>] ?
> restore_i387_xstate+0x148/0x1d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a59c>] ?
> stub_rt_sigreturn+0x6c/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: smbd            S ffff8801c25e02b0
> 0 31456      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e0000 0000000000000086
> ffff8801ad40c000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801ad40c000 ffff8801ad40dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801ad40c000 ffff8801ad40c010
> ffff8801ad40dfd8 ffff8801c25e0000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b46f1>] ? timerqueue_del+0x31/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ed0f>] ? __d_lookup+0x13f/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff81112b2d>] ? touch_atime+0x11d/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110488b>] ? pipe_read+0x28b/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c81d>] ? do_wait+0x12d/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c989>] ?
> poll_select_set_timeout+0x89/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: smbd            S ffff8801c25e4930
> 0 31463  31456 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e4680 0000000000000082
> 0000000000000004 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff880172ee4000 ffff880172ee5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880172ee4000 ffff880172ee4010
> ffff880172ee5fd8 ffff8801c25e4680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b46f1>] ? timerqueue_del+0x31/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81181330>] ?
> ext4_get_inode_flags+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff81112b2d>] ? touch_atime+0x11d/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110488b>] ? pipe_read+0x28b/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c989>] ?
> poll_select_set_timeout+0x89/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: atd             S ffff880132e1bd70
> 0 26774      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1bac0 0000000000000086
> ffffffff00000028 ffff88000c1c63e0
> Jan 19 11:25:38 teletex kernel: ffff8801b96a0000 ffff8801b96a1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b96a0000 ffff8801b96a0010
> ffff8801b96a1fd8 ffff880132e1bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81548715>] ? do_nanosleep+0x95/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81089387>] ?
> hrtimer_nanosleep+0xa7/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077c95>] ? sigprocmask+0x45/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108949d>] ? sys_nanosleep+0x6d/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: acpid           S ffff880117a20890
> 0 27084      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a205e0 0000000000000086
> 0000000000000000 ffff8801f994e3e0
> Jan 19 11:25:38 teletex kernel: ffff8801294a6000 ffff8801294a7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801294a6000 ffff8801294a6010
> ffff8801294a7fd8 ffff880117a205e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81468320>] ? __map_single+0x1a0/0x440
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134d2b8>] ? scsi_dma_map+0x88/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b73f5>] ? find_get_page+0x75/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7da9>] ? filemap_fault+0x99/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7540>] ? sleep_on_page+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff815478f1>] ? io_schedule+0xa1/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81403a50>] ? evdev_write+0x150/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff81403a57>] ? evdev_read+0x7/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff813ff122>] ?
> input_event_to_user+0x62/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81403b4f>] ? evdev_read+0xff/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: mdadm           S ffff88015baadad0
> 0 27255      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baad820 0000000000000086
> 0000000000000001 ffff88040d911d60
> Jan 19 11:25:38 teletex kernel: ffff8801912f4000 ffff8801912f5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801912f4000 ffff8801912f4010
> ffff8801912f5fd8 ffff88015baad820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a2325>] ? get_disk+0x65/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a237c>] ? exact_lock+0xc/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8133bc44>] ? kobj_lookup+0x184/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a20fb>] ?
> disk_clear_events+0xdb/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ac2d2>] ?
> cpumask_next_and+0x22/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105f3eb>] ?
> select_task_rq_fair+0x39b/0x850
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dcd4>] ?
> check_preempt_wakeup+0xb4/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a1185>] ? blkdev_ioctl+0x205/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81113753>] ? iput+0x43/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: rsyslogd        S ffff88015baae0b0
> 0 26636      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baade00 0000000000000082
> 0000000000000001 ffff8801f994e3e0
> Jan 19 11:25:38 teletex kernel: ffff88010a8ca000 ffff88010a8cbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010a8ca000 ffff88010a8ca010
> ffff88010a8cbfd8 ffff88015baade00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134d2b8>] ? scsi_dma_map+0x88/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff813a181c>] ? mptscsih_qcmd+0x49c/0x820
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b1738>] ?
> radix_tree_delete+0x148/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ab191>] ? delayacct_end+0x81/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81058af7>] ?
> flush_tlb_others_ipi+0x107/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124ce1>] ?
> __find_get_block+0x71/0x1d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8119e68c>] ?
> mb_free_blocks+0x1ec/0x330
> Jan 19 11:25:38 teletex kernel: [<ffffffff81057b88>] ?
> ptep_set_access_flags+0x28/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: rs:main Q:Reg   S ffff88015baaec70
> 0 26637      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baae9c0 0000000000000082
> 0000000000000064 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880179178000 ffff880179179fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880179178000 ffff880179178010
> ffff880179179fd8 ffff88015baae9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff814af0e0>] ?
> ip_append_page+0x570/0x570
> Jan 19 11:25:38 teletex kernel: [<ffffffff814d22b1>] ? udp_sendmsg+0x361/0x920
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094773>] ?
> get_futex_value_locked+0x23/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff8117e33e>] ?
> ext4_file_write+0x6e/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fc0df>] ? fget_light+0x8f/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81475427>] ? sys_sendto+0x157/0x1a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: rsyslogd        S ffff88015baa9450
> 0 26638      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baa91a0 0000000000000082
> 0000000000000001 ffff88015baae9c0
> Jan 19 11:25:38 teletex kernel: ffff880155d82000 ffff880155d83fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880155d82000 ffff880155d82010
> ffff880155d83fd8 ffff88015baa91a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81468320>] ? __map_single+0x1a0/0x440
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81466ea2>] ?
> domain_flush_complete+0x42/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1b44>] ? kmem_cache_free+0x14/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81480c8c>] ?
> skb_free_datagram+0xc/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff814e9b4f>] ?
> unix_dgram_recvmsg+0x2af/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff814748b0>] ?
> sock_sendmsg_nosec+0xe0/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474965>] ? sock_recvmsg+0xb5/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ac2d2>] ?
> cpumask_next_and+0x22/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105f3eb>] ?
> select_task_rq_fair+0x39b/0x850
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dcd4>] ?
> check_preempt_wakeup+0xb4/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: rsyslogd        S ffff88015baa9a30
> 0 26639      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baa9780 0000000000000082
> ffff88041fd10380 ffff8801a9002920
> Jan 19 11:25:38 teletex kernel: ffff8801cc7fa000 ffff8801cc7fbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801cc7fa000 ffff8801cc7fa010
> ffff8801cc7fbfd8 ffff88015baa9780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095023>] ? wake_futex+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81097272>] ? do_futex+0x692/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106abb9>] ? do_syslog+0x4a9/0x530
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8115a0b0>] ? kmsg_poll+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8115a0de>] ? kmsg_read+0x2e/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8114fe42>] ? proc_reg_read+0x82/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: libvirtd        S ffff880117a25ad0
> 0 27256      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a25820 0000000000000082
> ffff88040843e5e0 ffff88040da3af00
> Jan 19 11:25:38 teletex kernel: ffff88019422e000 ffff88019422ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88019422e000 ffff88019422e010
> ffff88019422ffd8 ffff880117a25820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811ab362>] ?
> ext4_ind_map_blocks+0xc2/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ac2d2>] ?
> cpumask_next_and+0x22/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094773>] ?
> get_futex_value_locked+0x23/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d797a>] ? remove_vma+0x4a/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103b264>] ? fpu_finit+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103b2ba>] ? init_fpu+0x3a/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103be88>] ?
> restore_i387_xstate+0x148/0x1d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: libvirtd        S ffff880132e18e70
> 0 27258      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e18bc0 0000000000000082
> 0000000000000002 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff88011d896000 ffff88011d897fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011d896000 ffff88011d896010
> ffff88011d897fd8 ffff880132e18bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094773>] ?
> get_futex_value_locked+0x23/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88040daa82b0
> 0 27668      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040daa8000 0000000000000086
> ffff88002a242c40 ffff880132e1d820
> Jan 19 11:25:38 teletex kernel: ffff8801b548a000 ffff8801b548bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b548a000 ffff8801b548a010
> ffff8801b548bfd8 ffff88040daa8000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129b3af>] ? get_request+0x36f/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff811290c0>] ? __bio_clone+0x20/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bdc28>] ?
> get_page_from_freelist+0x2c8/0x5c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147e452>] ? __alloc_skb+0x72/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147fc90>] ?
> memcpy_fromiovec+0x50/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147ca04>] ? skb_queue_tail+0x24/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810638f9>] ?
> finish_task_switch+0x49/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff81548185>] ?
> __mutex_lock_slowpath+0x145/0x1a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1bcf>] ? kfree+0xf/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81103949>] ?
> __free_pipe_info+0x59/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8ebc>] ? filp_close+0x5c/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kmirrord        S ffff880407ffb790
> 0 32373      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffb4e0 0000000000000046
> ffff88041fc10380 ffff88040d913ac0
> Jan 19 11:25:38 teletex kernel: ffff88005acd2000 ffff88005acd3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88005acd2000 ffff88005acd2010
> ffff88005acd3fd8 ffff880407ffb4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e3f6>] ? task_rq_lock+0x56/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106281c>] ?
> set_cpus_allowed_ptr+0x8c/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kcopyd          S ffff880407fff830
> 0 32376      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407fff580 0000000000000046
> ffffffff812b22bc ffff8801c25e1780
> Jan 19 11:25:38 teletex kernel: ffff880052cce000 ffff880052ccffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880052cce000 ffff880052cce010
> ffff880052ccffd8 ffff880407fff580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffcf10
> 0  4119      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffcc60 0000000000000082
> 0000000000000002 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff880118836000 ffff880118837fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880118836000 ffff880118836010
> ffff880118837fd8 ffff880407ffcc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801d4348000
> 0  4122      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d86d820 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880196040000 ffff880196041fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880196040000 ffff880196040010
> ffff880196041fd8 ffff88040d86d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407fff250
> 0  4125      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffefa0 0000000000000082
> ffff8801ad744580 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff8801e7bbc000 ffff8801e7bbdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801e7bbc000 ffff8801e7bbc010
> ffff8801e7bbdfd8 ffff880407ffefa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff88040d86abd0
> 0  4120      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d86a920 0000000000000046
> ffff88041fc10380 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801e8642000 ffff8801e8643fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801e8642000 ffff8801e8642010
> ffff8801e8643fd8 ffff88040d86a920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-4119      S ffff88040d86b790
> 0  4121      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d86b4e0 0000000000000082
> ffff880400000010 ffff88040da3d820
> Jan 19 11:25:38 teletex kernel: ffff88011e2fc000 ffff88011e2fdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011e2fc000 ffff88011e2fc010
> ffff88011e2fdfd8 ffff88040d86b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6c9a30
> 0  4225      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6c9780 0000000000000086
> 0000000000000000 ffff880132e1e9c0
> Jan 19 11:25:38 teletex kernel: ffff8801ecd72000 ffff8801ecd73fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801ecd72000 ffff8801ecd72010
> ffff8801ecd73fd8 ffff88017e6c9780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff8801ce1e0000
> 0  4228      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a22f00 0000000000000086
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801869f2000 ffff8801869f3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801869f2000 ffff8801869f2010
> ffff8801869f3fd8 ffff880117a22f00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81065aba>] ? load_balance+0x8a/0x600
> Jan 19 11:25:38 teletex kernel: [<ffffffff810011e8>] ? kvm_read_guest+0x48/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8102b886>] ? svm_get_msr+0x136/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fba6>] ?
> kvm_arch_vcpu_load+0xe6/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff813ceab1>] ?
> usb_get_configuration+0x101/0x13d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002c2b>] ?
> kvm_host_page_size+0x3b/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81018dd9>] ? mapping_level+0x19/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81019eb2>] ? tdp_page_fault+0xb2/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff81088ca9>] ?
> lock_hrtimer_base+0x29/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81088ca9>] ?
> lock_hrtimer_base+0x29/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101a31c>] ?
> kvm_mmu_page_fault+0x1c/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81010978>] ?
> kvm_arch_vcpu_ioctl_run+0x4a8/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549770>] ?
> _raw_spin_unlock_irq+0x10/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6cec70
> 0  4230      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6ce9c0 0000000000000086
> ffff8801ad745480 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff8801e7802000 ffff8801e7803fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801e7802000 ffff8801e7802010
> ffff8801e7803fd8 ffff88017e6ce9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880166e4a010
> 0  6284      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e49d60 0000000000000086
> 00012d7effffff92 ffff88040d911780
> Jan 19 11:25:38 teletex kernel: ffff880141eba000 ffff880141ebbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880141eba000 ffff880141eba010
> ffff880141ebbfd8 ffff880166e49d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88000c1c31b0
> 0  6285      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c2f00 0000000000000086
> 00007f2ece7f7000 ffff880166e49d60
> Jan 19 11:25:38 teletex kernel: ffff880199ac2000 ffff880199ac3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199ac2000 ffff880199ac2010
> ffff880199ac3fd8 ffff88000c1c2f00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d478e>] ? tlb_finish_mmu+0xe/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d5ab8>] ? zap_page_range+0xc8/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8363>] ?
> call_rwsem_down_write_failed+0x13/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154894c>] ? down_write+0x1c/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d8dea>] ? sys_munmap+0x3a/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88040d911a30
> 0  6297      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d911780 0000000000000086
> 00012d7dffffff92 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88004c822000 ffff88004c823fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88004c822000 ffff88004c822010
> ffff88004c823fd8 ffff88040d911780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88040d917830
> 0  6298      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d917580 0000000000000086
> 4b7a806fe0c3c01b ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8800af49e000 ffff8800af49ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800af49e000 ffff8800af49e010
> ffff8800af49ffd8 ffff88040d917580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812bafc6>] ?
> bitmap_find_next_zero_area+0x36/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ee9f0>] ?
> get_partial_node+0x130/0x2e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812c69dd>] ?
> iommu_area_alloc+0x7d/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff812bafc6>] ?
> bitmap_find_next_zero_area+0x36/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c4c51>] ?
> shrink_page_list+0x651/0x820
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c520f>] ?
> shrink_inactive_list+0x18f/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c5ad8>] ? shrink_zone+0x498/0x580
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c6832>] ?
> try_to_free_pages+0x182/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be54a>] ?
> __alloc_pages_nodemask+0x43a/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8582>] ?
> do_huge_pmd_anonymous_page+0x132/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054606>] ? do_page_fault+0x136/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d9a40>] ? mmap_region+0x240/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d75b7>] ?
> get_unmapped_area+0x87/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880117a225f0
> 0  4226      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a22340 0000000000000046
> ffff88041fc10380 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880177f5c000 ffff880177f5dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880177f5c000 ffff880177f5c010
> ffff880177f5dfd8 ffff880117a22340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-4225      S ffff880117a26c70
> 0  4227      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a269c0 0000000000000086
> ffff880117a22f00 ffff880117a22f00
> Jan 19 11:25:38 teletex kernel: ffff88013774e000 ffff88013774ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88013774e000 ffff88013774e010
> ffff88013774ffd8 ffff880117a269c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801a9002bd0
> 0  4352      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9002920 0000000000000086
> ffffffff81767f40 ffff88017e6c9780
> Jan 19 11:25:38 teletex kernel: ffff88014dc98000 ffff88014dc99fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88014dc98000 ffff88014dc98010
> ffff88014dc99fd8 ffff8801a9002920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880405973620
> 0  4355      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e7580 0000000000000086
> 0000000000000000 ffff880117a21780
> Jan 19 11:25:38 teletex kernel: ffff88011529c000 ffff88011529dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011529c000 ffff88011529c010
> ffff88011529dfd8 ffff8801c25e7580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549770>] ?
> _raw_spin_unlock_irq+0x10/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801c25e5ad0
> 0  4357      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e5820 0000000000000086
> ffff8804070def80 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88011d10e000 ffff88011d10ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011d10e000 ffff88011d10e010
> ffff88011d10ffd8 ffff8801c25e5820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801a90025f0
> 0  4353      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9002340 0000000000000046
> ffffffff8105fb03 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88012331c000 ffff88012331dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012331c000 ffff88012331c010
> ffff88012331dfd8 ffff8801a9002340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-4352      S ffff8801c25e0890
> 0  4354      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e05e0 0000000000000086
> 0000000000000010 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880117508000 ffff880117509fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880117508000 ffff880117508010
> ffff880117509fd8 ffff8801c25e05e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88040d8a3d70
> 0  5423      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a3ac0 0000000000000082
> ffffffff00000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880201b56000 ffff880201b57fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880201b56000 ffff880201b56010
> ffff880201b57fd8 ffff88040d8a3ac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094773>] ?
> get_futex_value_locked+0x23/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c8b3>] ?
> poll_select_copy_remaining+0x103/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e064>] ? sys_select+0x54/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88010c043620
> 0  5426      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a4680 0000000000000082
> 0000000000000000 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff88012f0b6000 ffff88012f0b7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012f0b6000 ffff88012f0b6010
> ffff88012f0b7fd8 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88040d8a4350
> 0  5427      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a40a0 0000000000000082
> 0000000000000002 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801dbcca000 ffff8801dbccbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801dbcca000 ffff8801dbcca010
> ffff8801dbccbfd8 ffff88040d8a40a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100b1c5>] ?
> emulator_pio_out_emulated+0x75/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077c95>] ? sigprocmask+0x45/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81009a31>] ? kvm_get_rflags+0x11/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810107c5>] ?
> kvm_arch_vcpu_ioctl_run+0x2f5/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054650>] ? do_page_fault+0x180/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88040d8a0890
> 0  5429      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a05e0 0000000000000082
> ffff88011605fb80 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: ffff880103e4c000 ffff880103e4dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880103e4c000 ffff880103e4c010
> ffff880103e4dfd8 ffff88040d8a05e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880406e0cf10
> 0  7009      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0cc60 0000000000000082
> 00007f5c10b37000 ffff880406e0e9c0
> Jan 19 11:25:38 teletex kernel: ffff8801d53de000 ffff8801d53dffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d53de000 ffff8801d53de010
> ffff8801d53dffd8 ffff880406e0cc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d478e>] ? tlb_finish_mmu+0xe/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d5ab8>] ? zap_page_range+0xc8/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8363>] ?
> call_rwsem_down_write_failed+0x13/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154894c>] ? down_write+0x1c/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d8dea>] ? sys_munmap+0x3a/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880407ffc930
> 0  7013      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffc680 0000000000000082
> 000027fdffffff92 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801f61d6000 ffff8801f61d7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801f61d6000 ffff8801f61d6010
> ffff8801f61d7fd8 ffff880407ffc680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880407ff9450
> 0  7014      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ff91a0 0000000000000082
> 000027f5ffffff92 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88010d756000 ffff88010d757fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010d756000 ffff88010d756010
> ffff88010d757fd8 ffff880407ff91a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880406e0b790
> 0  7015      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0b4e0 0000000000000082
> 000027f8ffffff92 ffff88015baa9d60
> Jan 19 11:25:38 teletex kernel: ffff88006bf52000 ffff88006bf53fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88006bf52000 ffff88006bf52010
> ffff88006bf53fd8 ffff880406e0b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880406e0f250
> 0  7016      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0efa0 0000000000000082
> 000027f9ffffff92 ffff880406e085e0
> Jan 19 11:25:38 teletex kernel: ffff880069dae000 ffff880069daffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880069dae000 ffff880069dae010
> ffff880069daffd8 ffff880406e0efa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880406e08890
> 0  7017      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e085e0 0000000000000082
> 000027fbffffff92 ffff880407ffc680
> Jan 19 11:25:38 teletex kernel: ffff8800261b2000 ffff8800261b3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800261b2000 ffff8800261b2010
> ffff8800261b3fd8 ffff880406e085e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880406e0ec70
> 0  7018      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0e9c0 0000000000000082
> 000027f4ffffff92 ffff880407ff91a0
> Jan 19 11:25:38 teletex kernel: ffff8800137c2000 ffff8800137c3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800137c2000 ffff8800137c2010
> ffff8800137c3fd8 ffff880406e0e9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095172>] ? futex_wake+0x112/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf83b>] ? sys_madvise+0x21b/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88040da3d4f0
> 0  7019      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3d240 0000000000000082
> 0000000000000001 ffff88040da3a340
> Jan 19 11:25:38 teletex kernel: ffff8800af5c8000 ffff8800af5c9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800af5c8000 ffff8800af5c8010
> ffff8800af5c9fd8 ffff88040da3d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be428>] ?
> __alloc_pages_nodemask+0x318/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c4c51>] ?
> shrink_page_list+0x651/0x820
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c520f>] ?
> shrink_inactive_list+0x18f/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ea431>] ?
> compaction_suitable+0x91/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ea471>] ? compact_zone+0x21/0x7d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c5ad8>] ? shrink_zone+0x498/0x580
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c6832>] ?
> try_to_free_pages+0x182/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be54a>] ?
> __alloc_pages_nodemask+0x43a/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8582>] ?
> do_huge_pmd_anonymous_page+0x132/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054606>] ? do_page_fault+0x136/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d9a40>] ? mmap_region+0x240/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d75b7>] ?
> get_unmapped_area+0x87/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801cf385ad0
> 0  5424      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf385820 0000000000000046
> ffff88041fd10380 ffff880406e0d820
> Jan 19 11:25:38 teletex kernel: ffff880166a06000 ffff880166a07fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880166a06000 ffff880166a06010
> ffff880166a07fd8 ffff8801cf385820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-5423      S ffff88040d8a54f0
> 0  5425      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d8a5240 0000000000000082
> 0000000000010380 ffff88040d8a40a0
> Jan 19 11:25:38 teletex kernel: ffff8801227f0000 ffff8801227f1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801227f0000 ffff8801227f0010
> ffff8801227f1fd8 ffff88040d8a5240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880166e4a5f0
> 0  5921      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4a340 0000000000000086
> 0000000000000000 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff88016943c000 ffff88016943dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88016943c000 ffff88016943c010
> ffff88016943dfd8 ffff880166e4a340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88010c03b620
> 0  5924      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4b4e0 0000000000000086
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880128fba000 ffff880128fbbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880128fba000 ffff880128fba010
> ffff880128fbbfd8 ffff880166e4b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880166e4abd0
> 0  5926      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4a920 0000000000000086
> ffff880050c67880 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff8801f7ae6000 ffff8801f7ae7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801f7ae6000 ffff8801f7ae6010
> ffff8801f7ae7fd8 ffff880166e4a920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880166e4f250
> 0  5922      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4efa0 0000000000000046
> ffffffff8105fb03 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801f03f4000 ffff8801f03f5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801f03f4000 ffff8801f03f4010
> ffff8801f03f5fd8 ffff880166e4efa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-5921      S ffff880166e4ec70
> 0  5923      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4e9c0 0000000000000086
> ffff880400000010 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88014f212000 ffff88014f213fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88014f212000 ffff88014f212010
> ffff88014f213fd8 ffff880166e4e9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6ce690
> 0  6051      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6ce3e0 0000000000000082
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88015939e000 ffff88015939ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015939e000 ffff88015939e010
> ffff88015939ffd8 ffff88017e6ce3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff8801d1020000
> 0  6056      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994e3e0 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801f01ae000 ffff8801f01affd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801f01ae000 ffff8801f01ae010
> ffff8801f01affd8 ffff8801f994e3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff880407913620
> 0  6057      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f9949d60 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801d43fc000 ffff8801d43fdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d43fc000 ffff8801d43fc010
> ffff8801d43fdfd8 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff8801f9948e70
> 0  6059      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f9948bc0 0000000000000082
> ffff880050c65480 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff88013c968000 ffff88013c969fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88013c968000 ffff88013c968010
> ffff88013c969fd8 ffff8801f9948bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88040da760b0
> 0  5931      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da75e00 0000000000000082
> ffff88040acf2e98 ffff8801c25e40a0
> Jan 19 11:25:38 teletex kernel: ffff88011139c000 ffff88011139dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011139c000 ffff88011139c010
> ffff88011139dfd8 ffff88040da75e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1bcf>] ? kfree+0xf/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549770>] ?
> _raw_spin_unlock_irq+0x10/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f2115>] ?
> kmem_cache_alloc+0xa5/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1bcf>] ? kfree+0xf/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b70af>] ?
> find_get_pages_tag+0xbf/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb2a>] ? __writepage+0xa/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf457>] ?
> write_cache_pages+0x1e7/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb20>] ? set_page_dirty+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf676>] ?
> generic_writepages+0x46/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b855c>] ?
> __filemap_fdatawrite_range+0x7c/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b85c2>] ?
> filemap_write_and_wait_range+0x52/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112b5dd>] ? blkdev_fsync+0x1d/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff81122cfc>] ? do_fsync+0x2c/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff81122d2e>] ? sys_fdatasync+0xe/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffc350
> 0  8718      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffc0a0 0000000000000082
> ffffffff81861ec0 ffff880407ff85e0
> Jan 19 11:25:38 teletex kernel: ffff8800149ae000 ffff8800149affd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800149ae000 ffff8800149ae010
> ffff8800149affd8 ffff880407ffc0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b22bc>] ?
> rb_insert_color+0x10c/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ff8890
> 0  8719      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ff85e0 0000000000000082
> ad88aaf8aaf0aae0 ffff880407ffbac0
> Jan 19 11:25:38 teletex kernel: ffff8800c1c00000 ffff8800c1c01fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800c1c00000 ffff8800c1c00010
> ffff8800c1c01fd8 ffff880407ff85e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105cca5>] ? place_entity+0x55/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dcd4>] ?
> check_preempt_wakeup+0xb4/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077d7e>] ?
> sys_rt_sigprocmask+0xae/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffbd70
> 0  8720      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffbac0 0000000000000082
> 484475c33b48f88b ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8800c1d0e000 ffff8800c1d0ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800c1d0e000 ffff8800c1d0e010
> ffff8800c1d0ffd8 ffff880407ffbac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff88017e6cc930
> 0  6054      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cc680 0000000000000046
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88019fb5e000 ffff88019fb5ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88019fb5e000 ffff88019fb5e010
> ffff88019fb5ffd8 ffff88017e6cc680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6051      S ffff88017e6ca5f0
> 0  6055      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6ca340 0000000000000082
> 0000000000010380 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff880155dda000 ffff880155ddbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880155dda000 ffff880155dda010
> ffff880155ddbfd8 ffff88017e6ca340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880132e1b790
> 0  6166      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1b4e0 0000000000000086
> ffff88016d3b4010 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88016d3b4000 ffff88016d3b5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88016d3b4000 ffff88016d3b4010
> ffff88016d3b5fd8 ffff880132e1b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407910000
> 0  6169      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf384c60 0000000000000086
> 0000000000000000 ffff880407ffa920
> Jan 19 11:25:38 teletex kernel: ffff88017923a000 ffff88017923bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017923a000 ffff88017923a010
> ffff88017923bfd8 ffff8801cf384c60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801cf384930
> 0  6171      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf384680 0000000000000086
> ffff88040703f580 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff8801d0caa000 ffff8801d0cabfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d0caa000 ffff8801d0caa010
> ffff8801d0cabfd8 ffff8801cf384680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880132e1cf10
> 0  6167      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1cc60 0000000000000046
> 0000000000000000 ffff880132e1b4e0
> Jan 19 11:25:38 teletex kernel: ffff88011f0e8000 ffff88011f0e9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011f0e8000 ffff88011f0e8010
> ffff88011f0e9fd8 ffff880132e1cc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6166      S ffff880132e1e690
> 0  6168      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1e3e0 0000000000000086
> 0000000000010380 ffff8801cf384c60
> Jan 19 11:25:38 teletex kernel: ffff8801b344e000 ffff8801b344ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b344e000 ffff8801b344e010
> ffff8801b344ffd8 ffff880132e1e3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffa010
> 0  6291      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ff9d60 0000000000000082
> ffff880100000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880150eec000 ffff880150eedfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880150eec000 ffff880150eec010
> ffff880150eedfd8 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b46f1>] ? timerqueue_del+0x31/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549798>] ?
> _raw_spin_unlock_irqrestore+0x8/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff88040791b620
> 0  6294      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994d240 0000000000000082
> 0000000000000000 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: ffff8801a6ab8000 ffff8801a6ab9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801a6ab8000 ffff8801a6ab8010
> ffff8801a6ab9fd8 ffff8801f994d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fc0c4>] ? fget_light+0x74/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407918000
> 0  6295      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffa920 0000000000000082
> 0000000000000000 ffff88017e6ce3e0
> Jan 19 11:25:38 teletex kernel: ffff8801d0ca8000 ffff8801d0ca9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d0ca8000 ffff8801d0ca8010
> ffff8801d0ca9fd8 ffff880407ffa920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095023>] ? wake_futex+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffe690
> 0  6296      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffe3e0 0000000000000082
> ffff88040dbf1d80 ffff880166e4c680
> Jan 19 11:25:38 teletex kernel: ffff880197e7e000 ffff880197e7ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880197e7e000 ffff880197e7e010
> ffff880197e7ffd8 ffff880407ffe3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880406e0dad0
> 0 27972      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0d820 0000000000000082
> ffff880141e5df58 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: ffff880141e5c000 ffff880141e5dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880141e5c000 ffff880141e5c010
> ffff880141e5dfd8 ffff880406e0d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801cf3825f0
> 0 22478      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf382340 0000000000000082
> ffff880142d95f58 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: ffff880142d94000 ffff880142d95fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880142d94000 ffff880142d94010
> ffff880142d95fd8 ffff8801cf382340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880406e0e0b0
> 0 26989      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0de00 0000000000000082
> ffff8801f6008000 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: ffff8801f6008000 ffff8801f6009fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801f6008000 ffff8801f6008010
> ffff8801f6009fd8 ffff880406e0de00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801f99482b0
> 0  6292      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f9948000 0000000000000046
> ffff88041fc10380 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801e1e4e000 ffff8801e1e4ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801e1e4e000 ffff8801e1e4e010
> ffff8801e1e4ffd8 ffff8801f9948000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6291      S ffff880407ff8e70
> 0  6293      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ff8bc0 0000000000000082
> ffff880407ffa920 ffff880407ffa920
> Jan 19 11:25:38 teletex kernel: ffff880103e70000 ffff880103e71fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880103e70000 ffff880103e70010
> ffff880103e71fd8 ffff880407ff8bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880166e4c930
> 0  6642      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4c680 0000000000000082
> 0000000000000002 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880406e2e000 ffff880406e2ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880406e2e000 ffff880406e2e010
> ffff880406e2ffd8 ffff880166e4c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880405970000
> 0  6646      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e09780 0000000000000082
> 0000000000000000 ffff8801c25e7580
> Jan 19 11:25:38 teletex kernel: ffff88015ce7a000 ffff88015ce7bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015ce7a000 ffff88015ce7a010
> ffff88015ce7bfd8 ffff880406e09780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880406e0d4f0
> 0  6648      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0d240 0000000000000082
> ffff88011605d480 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff8801972b0000 ffff8801972b1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801972b0000 ffff8801972b0010
> ffff8801972b1fd8 ffff880406e0d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880166e48e70
> 0  6644      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e48bc0 0000000000000046
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88017b7c0000 ffff88017b7c1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017b7c0000 ffff88017b7c0010
> ffff88017b7c1fd8 ffff880166e48bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6642      S ffff880166e4d4f0
> 0  6645      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4d240 0000000000000082
> 0000000000010380 ffff880406e09780
> Jan 19 11:25:38 teletex kernel: ffff88017f282000 ffff88017f283fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017f282000 ffff88017f282010
> ffff88017f283fd8 ffff880166e4d240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880406e082b0
> 0  6726      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e08000 0000000000000082
> ffffffff810bc700 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88015e47c000 ffff88015e47dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015e47c000 ffff88015e47c010
> ffff88015e47dfd8 ffff880406e08000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bc700>] ? drain_pages+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801fd420000
> 0  6729      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a24c60 0000000000000082
> 0000000000000000 ffff8801cf386fa0
> Jan 19 11:25:38 teletex kernel: ffff8801a016c000 ffff8801a016dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801a016c000 ffff8801a016c010
> ffff8801a016dfd8 ffff880117a24c60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880117a26690
> 0  6731      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a263e0 0000000000000082
> ffff8804070de680 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: ffff880150172000 ffff880150173fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880150172000 ffff880150172010
> ffff880150173fd8 ffff880117a263e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880117a20e70
> 0  6727      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a20bc0 0000000000000046
> c240a9430440e334 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88015e44e000 ffff88015e44ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015e44e000 ffff88015e44e010
> ffff88015e44ffd8 ffff880117a20bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6726      S ffff880117a24350
> 0  6728      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a240a0 0000000000000082
> 0000000000000010 ffff8801a9005820
> Jan 19 11:25:38 teletex kernel: ffff880170efc000 ffff880170efdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880170efc000 ffff880170efc010
> ffff880170efdfd8 ffff880117a240a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6cbd70
> 0  6873      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cbac0 0000000000000082
> 00000000000200d0 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff8801bfdaa000 ffff8801bfdabfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801bfdaa000 ffff8801bfdaa010
> ffff8801bfdabfd8 ffff88017e6cbac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801d5f7b620
> 0  6876      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf386fa0 0000000000000082
> 0000000000000000 ffff880407ffa920
> Jan 19 11:25:38 teletex kernel: ffff880151cfe000 ffff880151cfffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880151cfe000 ffff880151cfe010
> ffff880151cfffd8 ffff8801cf386fa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801c25e3790
> 0  6879      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e34e0 0000000000000082
> ffff88011605c880 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff8804078d0000 ffff8804078d1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8804078d0000 ffff8804078d0010
> ffff8804078d1fd8 ffff8801c25e34e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff8801cf387830
> 0  6016      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf387580 0000000000000082
> 0000000000000246 ffff88040d949d60
> Jan 19 11:25:38 teletex kernel: ffff8801109a2000 ffff8801109a3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801109a2000 ffff8801109a2010
> ffff8801109a3fd8 ffff8801cf387580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f2105>] ?
> kmem_cache_alloc+0x95/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124260>] ?
> alloc_buffer_head+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7530>] ? __lock_page+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff815478d4>] ? io_schedule+0x84/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7539>] ? sleep_on_page+0x9/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547d6a>] ?
> __wait_on_bit_lock+0x4a/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b751e>] ? __lock_page+0x5e/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084f00>] ?
> autoremove_wake_function+0x30/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7635>] ? find_lock_page+0x55/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7a7b>] ?
> grab_cache_page_write_begin+0x4b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff811269b3>] ?
> block_write_begin+0x33/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b6a72>] ?
> generic_file_buffered_write+0x112/0x290
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b89cf>] ?
> __generic_file_aio_write+0x22f/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff811042b1>] ? pipe_write+0x331/0x680
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a7fe>] ?
> blkdev_aio_write+0x2e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb638>] ? vfs_write+0xc8/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb77b>] ? sys_pwrite64+0x9b/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff88000c1c4930
> 0  6475      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c4680 0000000000000082
> ffffffff810f20a4 ffff8801a9005240
> Jan 19 11:25:38 teletex kernel: ffff8800c138e000 ffff8800c138ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800c138e000 ffff8800c138e010
> ffff8800c138ffd8 ffff88000c1c4680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f20a4>] ?
> kmem_cache_alloc+0x34/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124260>] ?
> alloc_buffer_head+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124a8e>] ?
> alloc_page_buffers+0x6e/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124b3b>] ?
> create_empty_buffers+0x3b/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b05ec>] ?
> __prop_inc_single+0x4c/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7530>] ? __lock_page+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff815478d4>] ? io_schedule+0x84/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7539>] ? sleep_on_page+0x9/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547d6a>] ?
> __wait_on_bit_lock+0x4a/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810582fb>] ? gup_pud_range+0x12b/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ac2d2>] ?
> cpumask_next_and+0x22/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b751e>] ? __lock_page+0x5e/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084f00>] ?
> autoremove_wake_function+0x30/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7635>] ? find_lock_page+0x55/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7a7b>] ?
> grab_cache_page_write_begin+0x4b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff811269b3>] ?
> block_write_begin+0x33/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b6a72>] ?
> generic_file_buffered_write+0x112/0x290
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b89cf>] ?
> __generic_file_aio_write+0x22f/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff811042b1>] ? pipe_write+0x331/0x680
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a7fe>] ?
> blkdev_aio_write+0x2e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb638>] ? vfs_write+0xc8/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb77b>] ? sys_pwrite64+0x9b/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff88017e6c8890
> 0  6874      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6c85e0 0000000000000046
> 0000000000000000 ffff88017e6cbac0
> Jan 19 11:25:38 teletex kernel: ffff8801af336000 ffff8801af337fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801af336000 ffff8801af336010
> ffff8801af337fd8 ffff88017e6c85e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6873      S ffff88017e6cb790
> 0  6875      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cb4e0 0000000000000082
> ffff88017e6cbac0 ffff8801cf386fa0
> Jan 19 11:25:38 teletex kernel: ffff8801af33c000 ffff8801af33dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801af33c000 ffff8801af33c010
> ffff8801af33dfd8 ffff88017e6cb4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880117a21450
> 0  6915      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a211a0 0000000000000086
> ffff8801b6b2c010 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801b6b2c000 ffff8801b6b2dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b6b2c000 ffff8801b6b2c010
> ffff8801b6b2dfd8 ffff880117a211a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801d5f78000
> 0  6920      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a21780 0000000000000086
> 0000000000000000 ffff880117a24c60
> Jan 19 11:25:38 teletex kernel: ffff880147c60000 ffff880147c61fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880147c60000 ffff880147c60010
> ffff880147c61fd8 ffff880117a21780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dc00>] ? task_tick_fair+0xf0/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801cf381a30
> 0  6923      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf381780 0000000000000086
> ffff880150175180 ffff880407ffcc60
> Jan 19 11:25:38 teletex kernel: ffff880187d00000 ffff880187d01fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880187d00000 ffff880187d00010
> ffff880187d01fd8 ffff8801cf381780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff81132a27>] ?
> ep_send_events_proc+0x67/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801cf383790
> 0  6918      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf3834e0 0000000000000046
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801b6b3e000 ffff8801b6b3ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b6b3e000 ffff8801b6b3e010
> ffff8801b6b3ffd8 ffff8801cf3834e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547501>] ? __schedule+0x711/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6915      S ffff8801cf380890
> 0  6919      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf3805e0 0000000000000086
> 0000000000000010 ffff8801a9005820
> Jan 19 11:25:38 teletex kernel: ffff8801695ca000 ffff8801695cbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801695ca000 ffff8801695ca010
> ffff8801695cbfd8 ffff8801cf3805e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880132e1ec70
> 0  6964      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1e9c0 0000000000000086
> 0000000000000000 ffff880132e1b4e0
> Jan 19 11:25:38 teletex kernel: ffff8801c5730000 ffff8801c5731fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801c5730000 ffff8801c5730010
> ffff8801c5731fd8 ffff880132e1e9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880152123620
> 0  6968      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d9134e0 0000000000000086
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801b7016000 ffff8801b7017fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b7016000 ffff8801b7016010
> ffff8801b7017fd8 ffff88040d9134e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101d502>] ? segmented_write+0x62/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81020d20>] ?
> x86_decode_insn+0xd00/0xfc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81022d48>] ?
> x86_emulate_insn+0x648/0x2570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101f110>] ? em_rdtsc+0x50/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0076086>] ?
> xfs_bmap_del_extent+0x776/0x900 [xfs]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801f994b1b0
> 0  6970      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994af00 0000000000000086
> ffff88040dbf0e80 ffff88017e6c9780
> Jan 19 11:25:38 teletex kernel: ffff8801c5732000 ffff8801c5733fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801c5732000 ffff8801c5732010
> ffff8801c5733fd8 ffff8801f994af00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801f9948890
> 0  6966      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f99485e0 0000000000000046
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801da490000 ffff8801da491fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801da490000 ffff8801da490010
> ffff8801da491fd8 ffff8801f99485e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-6964      S ffff8801f994c930
> 0  6967      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994c680 0000000000000086
> 0000000000000010 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88015ca4e000 ffff88015ca4ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015ca4e000 ffff88015ca4e010
> ffff88015ca4ffd8 ffff8801f994c680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: udevd           S ffff8801cf384350
> 0  9320  21963 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf3840a0 0000000000000086
> 0000000000000000 ffff88017e6cc0a0
> Jan 19 11:25:38 teletex kernel: ffff8801436ea000 ffff8801436ebfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801436ea000 ffff8801436ea010
> ffff8801436ebfd8 ffff8801cf3840a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474a9b>] ? sock_sendmsg+0xab/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105b1a>] ? do_lookup+0x2ea/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147326e>] ?
> move_addr_to_kernel+0x2e/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147fe19>] ? verify_iovec+0x69/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81475c13>] ? __sys_sendmsg+0x393/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811157a2>] ? alloc_fd+0xf2/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff8801a9005ad0
> 0  9853      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9005820 0000000000000082
> ffffffff00000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801af7fc000 ffff8801af7fdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801af7fc000 ffff8801af7fc010
> ffff8801af7fdfd8 ffff8801a9005820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880152120000
> 0  9862      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffd820 0000000000000082
> ffffffff00000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801e7ffa000 ffff8801e7ffbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801e7ffa000 ffff8801e7ffa010
> ffff8801e7ffbfd8 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101fc8e>] ? segmented_read+0xde/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fb29>] ?
> kvm_arch_vcpu_load+0x69/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549c26>] ? retint_kernel+0x26/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             W ffff88010c040000
> 0  9863      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ff8000 0000000000000082
> ffffffffffd090f0 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: ffff88015eb10000 ffff88015eb11fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88015eb10000 ffff88015eb10010
> ffff88015eb11fd8 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101fc8e>] ? segmented_read+0xde/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fb29>] ?
> kvm_arch_vcpu_load+0x69/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81003af0>] ? kvm_vm_ioctl+0xb0/0x3e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b915>] ? do_vfs_ioctl+0x35/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801a9006c70
> 0  9864      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a90069c0 0000000000000082
> ffff88019a61da80 ffff880166e4a340
> Jan 19 11:25:38 teletex kernel: ffff88019fa88000 ffff88019fa89fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88019fa88000 ffff88019fa88010
> ffff88019fa89fd8 ffff8801a90069c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801f9949450
> 0  8579      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f99491a0 0000000000000082
> 0000000000000002 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88017908a000 ffff88017908bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017908a000 ffff88017908a010
> ffff88017908bfd8 ffff8801f99491a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88015baab1b0
> 0  8581      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baaaf00 0000000000000082
> ffff880405673b58 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880405672000 ffff880405673fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880405672000 ffff880405672010
> ffff880405673fd8 ffff88015baaaf00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b712d>] ?
> copy_user_generic_string+0x2d/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801f994a5f0
> 0  8582      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994a340 0000000000000082
> ffff880100000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880112efa000 ffff880112efbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880112efa000 ffff880112efa010
> ffff880112efbfd8 ffff8801f994a340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801f994dad0
> 0  8583      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994d820 0000000000000082
> ffff880138d41b58 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880138d40000 ffff880138d41fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880138d40000 ffff880138d40010
> ffff880138d41fd8 ffff8801f994d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801cf380e70
> 0  8587      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf380bc0 0000000000000082
> ffff88040bbbce00 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801121aa000 ffff8801121abfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801121aa000 ffff8801121aa010
> ffff8801121abfd8 ffff8801cf380bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801cf3831b0
> 0  8588      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf382f00 0000000000000082
> ffff88040bbbce00 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801121ac000 ffff8801121adfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801121ac000 ffff8801121ac010
> ffff8801121adfd8 ffff8801cf382f00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff880407ffd4f0
> 0  8698      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880407ffd240 0000000000000082
> ffff880000000000 ffff8801a9005820
> Jan 19 11:25:38 teletex kernel: ffff880004acc000 ffff880004acdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880004acc000 ffff880004acc010
> ffff880004acdfd8 ffff880407ffd240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801a90002b0
> 0  9860      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9000000 0000000000000046
> ffffffff8105fb03 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88018f248000 ffff88018f249fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88018f248000 ffff88018f248010
> ffff88018f249fd8 ffff8801a9000000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-9853      S ffff8801a90060b0
> 0  9861      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9005e00 0000000000000082
> ffff880400000010 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: ffff8801d551c000 ffff8801d551dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d551c000 ffff8801d551c010
> ffff8801d551dfd8 ffff8801a9005e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801c25e25f0
> 0 10150      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e2340 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88017fd16000 ffff88017fd17fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88017fd16000 ffff88017fd16010
> ffff88017fd17fd8 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154884e>] ?
> schedule_hrtimeout_range_clock+0xae/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cb47>] ? __pollwait+0xb7/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81135842>] ?
> eventfd_ctx_read+0xb2/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801fba5b620
> 0 10156      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e2f00 0000000000000082
> ffffffffffd090f0 ffff88015baad240
> Jan 19 11:25:38 teletex kernel: ffff88012164c000 ffff88012164dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012164c000 ffff88012164c010
> ffff88012164dfd8 ffff8801c25e2f00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101fc8e>] ? segmented_read+0xde/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095023>] ? wake_futex+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fb29>] ?
> kvm_arch_vcpu_load+0x69/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a0d7>] ?
> system_call_after_swapgs+0x17/0x65
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801d434b620
> 0 10157      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baad240 0000000000000082
> ffffffffffd090f0 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88012273c000 ffff88012273dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012273c000 ffff88012273c010
> ffff88012273dfd8 ffff88015baad240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101fc8e>] ? segmented_read+0xde/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810262f5>] ? apic_update_ppr+0x35/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002125>] ? kvm_vcpu_block+0x65/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810106ca>] ?
> kvm_arch_vcpu_ioctl_run+0x1fa/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81095023>] ? wake_futex+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2ee>] ? gs_change+0x9/0xb
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fb29>] ?
> kvm_arch_vcpu_load+0x69/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81003af0>] ? kvm_vm_ioctl+0xb0/0x3e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fc0c4>] ? fget_light+0x74/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff8801c25e6c70
> 0 10158      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e69c0 0000000000000082
> ffff88019a61c280 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff88012b46a000 ffff88012b46bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012b46a000 ffff88012b46a010
> ffff88012b46bfd8 ffff8801c25e69c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81472eb4>] ? sock_aio_read+0x144/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6c9450
> 0  8715      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6c91a0 0000000000000082
> ffff88002066e000 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff88002066e000 ffff88002066ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88002066e000 ffff88002066e010
> ffff88002066ffd8 ffff88017e6c91a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             S ffff88017e6cd4f0
> 0  8721      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cd240 0000000000000082
> ffff880004a4c000 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff880004a4c000 ffff880004a4dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880004a4c000 ffff880004a4c010
> ffff880004a4dfd8 ffff88017e6cd240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ccd>] ?
> futex_wait_queue_me+0xcd/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
> Jan 19 11:25:38 teletex kernel: [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb815>] ? sys_write+0x85/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff8801c25e54f0
> 0 10154      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e5240 0000000000000046
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88012941c000 ffff88012941dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88012941c000 ffff88012941c010
> ffff88012941dfd8 ffff8801c25e5240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-10150     S ffff88015baaabd0
> 0 10155      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baaa920 0000000000000082
> 0000000000000010 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801c44e4000 ffff8801c44e5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801c44e4000 ffff8801c44e4010
> ffff8801c44e5fd8 ffff88015baaa920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:11    S ffff88040daadad0
> 0 10549      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040daad820 0000000000000046
> ffff8800246bfdf0 ffff880407ff9d60
> Jan 19 11:25:38 teletex kernel: ffff8800246be000 ffff8800246bffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800246be000 ffff8800246be010
> ffff8800246bffd8 ffff88040daad820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: ntfs-3g         S ffff8801cf3860b0
> 0 10387      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf385e00 0000000000000086
> ffff880400000001 ffff8801f994a920
> Jan 19 11:25:38 teletex kernel: ffff88040dba6000 ffff88040dba7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040dba6000 ffff88040dba6010
> ffff88040dba7fd8 ffff8801cf385e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8125be45>] ? request_end+0xe5/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff8125cdb1>] ?
> fuse_dev_do_write+0x3d1/0xa70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b772d>] ?
> wait_on_page_bit_killable+0x6d/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084f00>] ?
> autoremove_wake_function+0x30/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8125c232>] ?
> fuse_dev_do_read+0x342/0x840
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8125c9d3>] ? fuse_dev_read+0x63/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kublaix1_0      S ffff8801a9007250
> 0  4406      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9006fa0 0000000000000046
> ffff88040a819680 ffff88040d8691a0
> Jan 19 11:25:38 teletex kernel: ffff88008ea5e000 ffff88008ea5ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88008ea5e000 ffff88008ea5e010
> ffff88008ea5ffd8 ffff8801a9006fa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00eb449>] ?
> scst_process_active_cmd+0x369/0x1510 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec90e>] ?
> scst_cmd_thread+0x24e/0x2e0 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec6c0>] ?
> scst_cmd_tasklet+0x50/0x50 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec6c0>] ?
> scst_cmd_tasklet+0x50/0x50 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kublaid1_0      S ffff8801a9002010
> 0  4407      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801a9001d60 0000000000000046
> ffff88040a810400 ffff880407ff8000
> Jan 19 11:25:38 teletex kernel: ffff8800d24a4000 ffff8800d24a5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800d24a4000 ffff8800d24a4010
> ffff8800d24a5fd8 ffff8801a9001d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00eb449>] ?
> scst_process_active_cmd+0x369/0x1510 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec90e>] ?
> scst_cmd_thread+0x24e/0x2e0 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec6c0>] ?
> scst_cmd_tasklet+0x50/0x50 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa00ec6c0>] ?
> scst_cmd_tasklet+0x50/0x50 [scst]
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:6     D ffff88040daa8e70
> 0  5866      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040daa8bc0 0000000000000046
> ffff880400000000 ffff8801c25e40a0
> Jan 19 11:25:38 teletex kernel: ffff8801094ec000 ffff8801094edfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801094ec000 ffff8801094ec010
> ffff8801094edfd8 ffff88040daa8bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b70af>] ?
> find_get_pages_tag+0xbf/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb2a>] ? __writepage+0xa/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf457>] ?
> write_cache_pages+0x1e7/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb20>] ? set_page_dirty+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1bcf>] ? kfree+0xf/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129aab7>] ?
> blk_flush_plug_list+0xa7/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf676>] ?
> generic_writepages+0x46/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111de63>] ?
> writeback_single_inode+0x193/0x370
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111e87d>] ?
> writeback_sb_inodes+0x1dd/0x2a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111eff6>] ?
> __writeback_inodes_wb+0x86/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f29b>] ? wb_writeback+0x1eb/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f330>] ?
> wb_do_writeback+0x80/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81075863>] ? lock_timer_base+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f53a>] ?
> bdi_writeback_thread+0x7a/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:7     D ffff8801c25e4350
> 0  5933      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e40a0 0000000000000046
> ffff880400000001 ffff88040da3de00
> Jan 19 11:25:38 teletex kernel: ffff8800d3136000 ffff8800d3137fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800d3136000 ffff8800d3136010
> ffff8800d3137fd8 ffff8801c25e40a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b70af>] ?
> find_get_pages_tag+0xbf/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb2a>] ? __writepage+0xa/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf457>] ?
> write_cache_pages+0x1e7/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810beb20>] ? set_page_dirty+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bf676>] ?
> generic_writepages+0x46/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111de63>] ?
> writeback_single_inode+0x193/0x370
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111e87d>] ?
> writeback_sb_inodes+0x1dd/0x2a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111eff6>] ?
> __writeback_inodes_wb+0x86/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f29b>] ? wb_writeback+0x1eb/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f330>] ?
> wb_do_writeback+0x80/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81075863>] ? lock_timer_base+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f53a>] ?
> bdi_writeback_thread+0x7a/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:12    S ffff88015baacf10
> 0  6177      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baacc60 0000000000000046
> ffff8800aeb93df0 ffff88040da3bac0
> Jan 19 11:25:38 teletex kernel: ffff8800aeb92000 ffff8800aeb93fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800aeb92000 ffff8800aeb92010
> ffff8800aeb93fd8 ffff88015baacc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/1:2     S ffff8801f994ec70
> 0  6746      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994e9c0 0000000000000046
> ffff88040bbfb678 ffff8801cf380000
> Jan 19 11:25:38 teletex kernel: ffff88040dba4000 ffff88040dba5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040dba4000 ffff88040dba4010
> ffff88040dba5fd8 ffff8801f994e9c0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455cee>] ? do_dbs_timer+0x20e/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455ae0>] ?
> powersave_bias_target+0x180/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88000c1c7830
> 0  6766  27668 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c7580 0000000000000086
> ffff88040a2e59c8 ffff880166e4a340
> Jan 19 11:25:38 teletex kernel: ffff88040a2e4000 ffff88040a2e5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040a2e4000 ffff88040a2e4010
> ffff88040a2e5fd8 ffff88000c1c7580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f3ad5>] ?
> __kmalloc_track_caller+0x105/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474a9b>] ? sock_sendmsg+0xab/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe70f>] ? cdev_get+0x5f/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe9b7>] ? chrdev_open+0x117/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105871>] ? do_lookup+0x41/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff811099cc>] ? do_last+0x8c/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a215>] ? path_openat+0x115/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a64d>] ? do_filp_open+0x4d/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff8801f994bd70
> 0  6776   6766 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994bac0 0000000000000086
> ffff88040be23810 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff88008ce96000 ffff88008ce97fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88008ce96000 ffff88008ce96010
> ffff88008ce97fd8 ffff8801f994bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004799>] ?
> sky2_xmit_frame+0x329/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81487cfd>] ?
> dev_hard_start_xmit+0x2fd/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107e898>] ?
> start_flush_work+0x98/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478149>] ? release_sock+0x19/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff814b9122>] ? tcp_sendmsg+0x842/0xce0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb7de>] ? sys_write+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff8801f994cf10
> 0  6781   6776 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994cc60 0000000000000086
> ffff88040ae29c00 ffff88040d9169c0
> Jan 19 11:25:38 teletex kernel: ffff88010518e000 ffff88010518ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010518e000 ffff88010518e010
> ffff88010518ffd8 ffff8801f994cc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sudo            S ffff88040da3a010
> 0  7032   6781 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da39d60 0000000000000086
> ffff88040bbb3800 ffff88040da3a340
> Jan 19 11:25:38 teletex kernel: ffff8800bc5b2000 ffff8800bc5b3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800bc5b2000 ffff8800bc5b2010
> ffff8800bc5b3fd8 ffff88040da39d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c2169>] ?
> __pagevec_release+0x19/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c4ff8>] ?
> putback_lru_pages+0x1d8/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c5271>] ?
> shrink_inactive_list+0x1f1/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be428>] ?
> __alloc_pages_nodemask+0x318/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1030>] ? pagevec_strip+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1c7d>] ?
> pagevec_lru_move_fn+0xbd/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1429>] ? do_wp_page+0x3d9/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff88040da3dad0
> 0  7038   7032 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3d820 0000000000000086
> ffff88040af8aa00 ffff88040d8691a0
> Jan 19 11:25:38 teletex kernel: ffff88006bf5a000 ffff88006bf5bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88006bf5a000 ffff88006bf5a010
> ffff88006bf5bfd8 ffff88040da3d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: udevd           S ffff880166e4dad0
> 0  7051  21963 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4d820 0000000000000082
> 0000000000000000 ffff8801a9005820
> Jan 19 11:25:38 teletex kernel: ffff8800d315a000 ffff8800d315bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800d315a000 ffff8800d315a010
> ffff8800d315bfd8 ffff880166e4d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474a9b>] ? sock_sendmsg+0xab/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105b1a>] ? do_lookup+0x2ea/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147326e>] ?
> move_addr_to_kernel+0x2e/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147fe19>] ? verify_iovec+0x69/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81475c13>] ? __sys_sendmsg+0x393/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113337b>] ?
> ep_scan_ready_list+0x16b/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff811157a2>] ? alloc_fd+0xf2/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: net.agent       S ffff880166e48890
> 0  7054      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e485e0 0000000000000082
> ffff880035057228 ffff880117a21d60
> Jan 19 11:25:38 teletex kernel: ffff8800af578000 ffff8800af579fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800af578000 ffff8800af578010
> ffff8800af579fd8 ffff880166e485e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d189a>] ?
> handle_pte_fault+0x8a/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ps              D ffff880117a260b0
> 0  7055   7054 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a25e00 0000000000000086
> ffffffff00000001 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff880080684000 ffff880080685fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880080684000 ffff880080684010
> ffff880080685fd8 ffff880117a25e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111344d>] ?
> new_inode_pseudo+0x3d/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e82c>] ? __d_instantiate+0x7c/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff811509ab>] ? task_dumpable+0x3b/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8115302a>] ? pid_revalidate+0x6a/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: grep            S ffff880117a22010
> 0  7056   7054 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a21d60 0000000000000086
> ffff880000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8800aea00000 ffff8800aea01fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800aea00000 ffff8800aea00010
> ffff8800aea01fd8 ffff880117a21d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b73f5>] ? find_get_page+0x75/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7da9>] ? filemap_fault+0x99/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81103f61>] ? pipe_wait+0x51/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110498d>] ? pipe_read+0x38d/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             x ffff880117a22bd0
> 0  7075      1 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff880117a22920 0000000000000046
> ffff880117a22920 ffff880132e1e9c0
> Jan 19 11:25:38 teletex kernel: ffff8801ea21e000 ffff8801ea21ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801ea21e000 ffff8801ea21e010
> ffff8801ea21ffd8 ffff880117a22920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a7b19>] ?
> __cfq_exit_single_io_context+0x89/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8127b9d0>] ? T.511+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106d10d>] ? do_exit+0x55d/0x810
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106d410>] ? do_group_exit+0x50/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107a4f9>] ?
> get_signal_to_deliver+0x1c9/0x510
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103235d>] ? do_signal+0x9d/0x770
> Jan 19 11:25:38 teletex kernel: [<ffffffff81078d8c>] ?
> do_send_sig_info+0x6c/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81078e05>] ?
> do_send_specific+0x55/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81078fd7>] ? do_tkill+0x67/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81032a95>] ?
> do_notify_resume+0x65/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a35b>] ? int_signal+0x12/0x17
> Jan 19 11:25:38 teletex kernel: kvm             D ffff880407020000
> 0  7082      1 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff88017e6cd820 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880199b4c000 ffff880199b4dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199b4c000 ffff880199b4c010
> ffff880199b4dfd8 ffff88017e6cd820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c4c51>] ?
> shrink_page_list+0x651/0x820
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c520f>] ?
> shrink_inactive_list+0x18f/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c458e>] ?
> shrink_active_list+0x25e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a822d>] ? cfq_cic_lookup+0xbd/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c5ad8>] ? shrink_zone+0x498/0x580
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bdc28>] ?
> get_page_from_freelist+0x2c8/0x5c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c6832>] ?
> try_to_free_pages+0x182/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be54a>] ?
> __alloc_pages_nodemask+0x43a/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d00cb>] ?
> clear_huge_page+0x6b/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8582>] ?
> do_huge_pmd_anonymous_page+0x132/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d2d2d>] ?
> __get_user_pages+0x12d/0x530
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100249e>] ?
> get_user_page_nowait+0x2e/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810025cd>] ? hva_to_pfn+0x11d/0x410
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002929>] ? __gfn_to_pfn+0x39/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81018eed>] ? try_async_pf+0x4d/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff81002c68>] ?
> kvm_host_page_size+0x78/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81019f1e>] ?
> tdp_page_fault+0x11e/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8101a31c>] ?
> kvm_mmu_page_fault+0x1c/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81010978>] ?
> kvm_arch_vcpu_ioctl_run+0x4a8/0xf90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100fb29>] ?
> kvm_arch_vcpu_load+0x69/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81003c31>] ? kvm_vm_ioctl+0x1f1/0x3e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: net.agent       S ffff880117a23790
> 0  7076      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a234e0 0000000000000082
> ffff88040ae28380 ffff880117a27580
> Jan 19 11:25:38 teletex kernel: ffff880164732000 ffff880164733fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880164732000 ffff880164732010
> ffff880164733fd8 ffff880117a234e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ps              D ffff880117a27830
> 0  7078   7076 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a27580 0000000000000082
> ffffffff00000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801bed46000 ffff8801bed47fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801bed46000 ffff8801bed46010
> ffff8801bed47fd8 ffff880117a27580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104e71>] ? unlazy_walk+0x111/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: grep            S ffff88040d912bd0
> 0  7079   7076 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d912920 0000000000000082
> ffff880199b4a010 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880199b4a000 ffff880199b4bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199b4a000 ffff880199b4a010
> ffff880199b4bfd8 ffff88040d912920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b73f5>] ? find_get_page+0x75/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7da9>] ? filemap_fault+0x99/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81103f61>] ? pipe_wait+0x51/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d4d8c>] ? unmap_vmas+0x5cc/0x8a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110498d>] ? pipe_read+0x38d/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff880166e4c350
> 0  7080      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880166e4c0a0 0000000000000046
> ffff88041fc0c6c0 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880199a0e000 ffff880199a0ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199a0e000 ffff880199a0e010
> ffff880199a0ffd8 ffff880166e4c0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-7075      S ffff88040d9fc930
> 0  7081      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d9fc680 0000000000000082
> 0000000000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801be0a0000 ffff8801be0a1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801be0a0000 ffff8801be0a0010
> ffff8801be0a1fd8 ffff88040d9fc680
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/u:3     S ffff88040daaf250
> 0  7133      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040daaefa0 0000000000000046
> 0000000000000003 ffff880132e1c0a0
> Jan 19 11:25:38 teletex kernel: ffff8801c3496000 ffff8801c3497fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801c3496000 ffff8801c3496010
> ffff8801c3497fd8 ffff88040daaefa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108bc20>] ? async_schedule+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: net.agent       S ffff8801c25e0e70
> 0  7268      1 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e0bc0 0000000000000086
> ffff88040af88700 ffff8801c25e11a0
> Jan 19 11:25:38 teletex kernel: ffff88010519a000 ffff88010519bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010519a000 ffff88010519a010
> ffff88010519bfd8 ffff8801c25e0bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b2244>] ?
> rb_insert_color+0x94/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff810687fd>] ? do_fork+0xdd/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ps              D ffff8801c25e1a30
> 0  7270   7268 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e1780 0000000000000082
> ffffffff00000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff8801647bc000 ffff8801647bdfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801647bc000 ffff8801647bc010
> ffff8801647bdfd8 ffff8801c25e1780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104e71>] ? unlazy_walk+0x111/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: grep            S ffff8801c25e7250
> 0  7271   7268 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e6fa0 0000000000000086
> ffff8801790ae010 ffff8801c25e1780
> Jan 19 11:25:38 teletex kernel: ffff8801790ae000 ffff8801790affd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801790ae000 ffff8801790ae010
> ffff8801790affd8 ffff8801c25e6fa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549c26>] ? retint_kernel+0x26/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b73f5>] ? find_get_page+0x75/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b7da9>] ? filemap_fault+0x99/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81103f61>] ? pipe_wait+0x51/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d4d8c>] ? unmap_vmas+0x5cc/0x8a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110498d>] ? pipe_read+0x38d/0x4b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kvm             D ffff8801c25e1450
> 0  7273      1 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff8801c25e11a0 0000000000000082
> 73ef23ce792e21af ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88010fed2000 ffff88010fed3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010fed2000 ffff88010fed2010
> ffff88010fed3fd8 ffff8801c25e11a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff814205a1>] ?
> get_active_stripe+0x341/0x740
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff814277a2>] ? make_request+0x192/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8142eea9>] ?
> md_make_request+0x109/0x250
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129976e>] ?
> generic_make_request+0x13e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810990da>] ?
> smp_call_function_single+0x16a/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff8129995b>] ? submit_bio+0x5b/0xd0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124745>] ? submit_bh+0xe5/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127918>] ?
> __block_write_full_page+0x1f8/0x380
> Jan 19 11:25:38 teletex kernel: [<ffffffff81127040>] ?
> end_buffer_async_read+0x1e0/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112a370>] ? I_BDEV+0x10/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c4c51>] ?
> shrink_page_list+0x651/0x820
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c520f>] ?
> shrink_inactive_list+0x18f/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c458e>] ?
> shrink_active_list+0x25e/0x2d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c5ad8>] ? shrink_zone+0x498/0x580
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c6832>] ?
> try_to_free_pages+0x182/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be54a>] ?
> __alloc_pages_nodemask+0x43a/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8582>] ?
> do_huge_pmd_anonymous_page+0x132/0x340
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d297d>] ?
> handle_mm_fault+0x1ed/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054606>] ? do_page_fault+0x136/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100364a>] ? kvm_dev_ioctl+0x9a/0x470
> Jan 19 11:25:38 teletex kernel: [<ffffffff810cf871>] ? sys_madvise+0x251/0x6c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: kvm-pit-wq      S ffff88040d94a010
> 0  7274      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d949d60 0000000000000046
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880138d52000 ffff880138d53fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880138d52000 ffff880138d52010
> ffff880138d53fd8 ffff88040d949d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d981>] ? update_curr+0x121/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff815477e0>] ?
> preempt_schedule+0x40/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080cb5>] ?
> rescuer_thread+0x2c5/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810809f0>] ?
> process_one_work+0x3c0/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: vhost-7273      S ffff88040d949450
> 0  7275      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040d9491a0 0000000000000082
> ffff880400000010 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff88010b556000 ffff88010b557fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010b556000 ffff88010b556010
> ffff88010b557fd8 ffff88040d9491a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed9>] ?
> autoremove_wake_function+0x9/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff814637c5>] ? vhost_worker+0x135/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81463690>] ?
> vhost_poll_flush+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:38    S ffff8801c25e60b0
> 0  7279      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e5e00 0000000000000046
> ffff88010b5fe000 ffff88040d9169c0
> Jan 19 11:25:38 teletex kernel: ffff88010b5fe000 ffff88010b5fffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010b5fe000 ffff88010b5fe010
> ffff88010b5fffd8 ffff8801c25e5e00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547bff>] ?
> schedule_timeout+0x15f/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff81075cc0>] ? del_timer+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/0:2     S ffff8801c25e6690
> 0  7282      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e63e0 0000000000000046
> 000c350000000000 ffff880407ffd820
> Jan 19 11:25:38 teletex kernel: ffff880199bd8000 ffff880199bd9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199bd8000 ffff880199bd8010
> ffff880199bd9fd8 ffff8801c25e63e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455cee>] ? do_dbs_timer+0x20e/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455ae0>] ?
> powersave_bias_target+0x180/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:5     S ffff88015baabd70
> 0  7305      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baabac0 0000000000000046
> ffff88014323bdf0 ffff88015baaefa0
> Jan 19 11:25:38 teletex kernel: ffff88014323a000 ffff88014323bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88014323a000 ffff88014323a010
> ffff88014323bfd8 ffff88015baabac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88015baa8890
> 0  7345  27668 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baa85e0 0000000000000082
> 0000000000000000 ffff88015baab4e0
> Jan 19 11:25:38 teletex kernel: ffff8801ea2ae000 ffff8801ea2affd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801ea2ae000 ffff8801ea2ae010
> ffff8801ea2affd8 ffff88015baa85e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b15fa>] ?
> start_this_handle+0x42a/0x4e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147e426>] ? __alloc_skb+0x46/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ee9f0>] ?
> get_partial_node+0x130/0x2e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f2115>] ?
> kmem_cache_alloc+0xa5/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe70f>] ? cdev_get+0x5f/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe9b7>] ? chrdev_open+0x117/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105871>] ? do_lookup+0x41/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff811099cc>] ? do_last+0x8c/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a215>] ? path_openat+0x115/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a64d>] ? do_filp_open+0x4d/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88015baab790
> 0  7360   7345 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baab4e0 0000000000000086
> ffff88040be23810 ffff8801f994e3e0
> Jan 19 11:25:38 teletex kernel: ffff88011228a000 ffff88011228bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011228a000 ffff88011228a010
> ffff88011228bfd8 ffff88015baab4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004799>] ?
> sky2_xmit_frame+0x329/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004569>] ?
> sky2_xmit_frame+0xf9/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81487cfd>] ?
> dev_hard_start_xmit+0x2fd/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107e898>] ?
> start_flush_work+0x98/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478149>] ? release_sock+0x19/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff814b9122>] ? tcp_sendmsg+0x842/0xce0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb7de>] ? sys_write+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff8801f994b790
> 0  7367   7360 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994b4e0 0000000000000082
> ffff88040ae2b480 ffff8801a9007580
> Jan 19 11:25:38 teletex kernel: ffff8801111b8000 ffff8801111b9fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801111b8000 ffff8801111b8010
> ffff8801111b9fd8 ffff8801f994b4e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sudo            S ffff880132e18890
> 0  7466   7367 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e185e0 0000000000000086
> 0000000000000001 ffff880132e191a0
> Jan 19 11:25:38 teletex kernel: ffff8801bec1a000 ffff8801bec1bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801bec1a000 ffff8801bec1a010
> ffff8801bec1bfd8 ffff880132e185e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811ab362>] ?
> ext4_ind_map_blocks+0xc2/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81186330>] ?
> ext4_map_blocks+0x170/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81124260>] ?
> alloc_buffer_head+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f199f>] ? new_slab+0x1af/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1030>] ? pagevec_strip+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1c7d>] ?
> pagevec_lru_move_fn+0xbd/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1429>] ? do_wp_page+0x3d9/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d005>] ?
> check_preempt_curr+0x65/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: su              S ffff880132e19450
> 0  7467   7466 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e191a0 0000000000000086
> ffff88040ae2b800 ffff8801f994c0a0
> Jan 19 11:25:38 teletex kernel: ffff880117d4e000 ffff880117d4ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880117d4e000 ffff880117d4e010
> ffff880117d4ffd8 ffff880132e191a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff8801f994c350
> 0  7476   7467 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994c0a0 0000000000000082
> ffff88040ab9f680 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff8801081da000 ffff8801081dbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801081da000 ffff8801081da010
> ffff8801081dbfd8 ffff8801f994c0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c559>] ?
> wait_consider_task+0x7f9/0x990
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ps              D ffff88040da38890
> 0  7606   7476 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff88040da385e0 0000000000000086
> ffffffff00000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880108de0000 ffff880108de1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880108de0000 ffff880108de0010
> ffff880108de1fd8 ffff88040da385e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104e71>] ? unlazy_walk+0x111/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: ps              D ffff88000c1c4350
> 0  7638   7038 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff88000c1c40a0 0000000000000086
> ffffffff8167be00 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff880108de2000 ffff880108de3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880108de2000 ffff880108de2010
> ffff880108de3fd8 ffff88000c1c40a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104e71>] ? unlazy_walk+0x111/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kworker/u:0     S ffff88040da3b1b0
> 0  7654      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3af00 0000000000000046
> 0000000000000003 ffff88040daaefa0
> Jan 19 11:25:38 teletex kernel: ffff88011090e000 ffff88011090ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011090e000 ffff88011090e010
> ffff88011090ffd8 ffff88040da3af00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108bc20>] ? async_schedule+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88000c1c0890
> 0  7657  27668 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c05e0 0000000000000082
> 0000000000000000 ffff8801a9007580
> Jan 19 11:25:38 teletex kernel: ffff88010bf56000 ffff88010bf57fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010bf56000 ffff88010bf56010
> ffff88010bf57fd8 ffff88000c1c05e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b15fa>] ?
> start_this_handle+0x42a/0x4e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147e426>] ? __alloc_skb+0x46/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f2115>] ?
> kmem_cache_alloc+0xa5/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe70f>] ? cdev_get+0x5f/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe9b7>] ? chrdev_open+0x117/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105871>] ? do_lookup+0x41/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff811099cc>] ? do_last+0x8c/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a215>] ? path_openat+0x115/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a64d>] ? do_filp_open+0x4d/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88040da38e70
> 0  7669   7657 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da38bc0 0000000000000082
> ffff88040be23810 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801646b2000 ffff8801646b3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801646b2000 ffff8801646b2010
> ffff8801646b3fd8 ffff88040da38bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004799>] ?
> sky2_xmit_frame+0x329/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004569>] ?
> sky2_xmit_frame+0xf9/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81487cfd>] ?
> dev_hard_start_xmit+0x2fd/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107e898>] ?
> start_flush_work+0x98/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478149>] ? release_sock+0x19/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff814b9122>] ? tcp_sendmsg+0x842/0xce0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb7de>] ? sys_write+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff88040da39450
> 0  7678   7669 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da391a0 0000000000000086
> ffff880400000001 ffff88000c1c69c0
> Jan 19 11:25:38 teletex kernel: ffff880141e6c000 ffff880141e6dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880141e6c000 ffff880141e6c010
> ffff880141e6dfd8 ffff88040da391a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064c93>] ?
> try_to_wake_up+0x1b3/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f8b7>] ? tty_ioctl+0x657/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kworker/1:3     S ffff880117a202b0
> 0  7812      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a20000 0000000000000046
> 0000000000010380 ffff8801f994e9c0
> Jan 19 11:25:38 teletex kernel: ffff88010944e000 ffff88010944ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010944e000 ffff88010944e010
> ffff88010944ffd8 ffff880117a20000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134b0de>] ?
> scsi_request_fn+0xbe/0x570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8150>] ? cfq_kick_queue+0x30/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: sudo            S ffff88017e6ca010
> 0  7839   7678 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6c9d60 0000000000000082
> ffffffff8147d290 ffff88017e6cde00
> Jan 19 11:25:38 teletex kernel: ffff8804057f0000 ffff8804057f1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8804057f0000 ffff8804057f0010
> ffff8804057f1fd8 ffff88017e6c9d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147d290>] ? skb_put+0x30/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff811ab362>] ?
> ext4_ind_map_blocks+0xc2/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81186330>] ?
> ext4_map_blocks+0x170/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ee9f0>] ?
> get_partial_node+0x130/0x2e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81057e78>] ? pte_alloc_one+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1030>] ? pagevec_strip+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1c7d>] ?
> pagevec_lru_move_fn+0xbd/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1429>] ? do_wp_page+0x3d9/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: su              S ffff88017e6ce0b0
> 0  7840   7839 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6cde00 0000000000000082
> ffff880126bbd180 ffff88040d8a4680
> Jan 19 11:25:38 teletex kernel: ffff88040b23c000 ffff88040b23dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040b23c000 ffff88040b23c010
> ffff88040b23dfd8 ffff88017e6cde00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff88017e6c8e70
> 0  7848   7840 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6c8bc0 0000000000000082
> ffff880100000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880164678000 ffff880164679fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880164678000 ffff880164678010
> ffff880164679fd8 ffff88017e6c8bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c559>] ?
> wait_consider_task+0x7f9/0x990
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f8b7>] ? tty_ioctl+0x657/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: netstat         D ffff88000c1c1a30
> 0  7909   7848 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff88000c1c1780 0000000000000086
> ffff8801bd93c000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880199a3c000 ffff880199a3dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880199a3c000 ffff880199a3c010
> ffff880199a3dfd8 ffff88000c1c1780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f1d64>] ? T.923+0xe4/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ed0f>] ? __d_lookup+0x13f/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104d2e>] ? path_get+0x2e/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff81104e71>] ? unlazy_walk+0x111/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d320a>] ?
> __access_remote_vm+0x3a/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ff81>] ? dynamic_dname+0xb1/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d3407>] ?
> access_process_vm+0x57/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81150c5f>] ?
> proc_pid_cmdline+0x6f/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff811523e2>] ? proc_info_read+0xb2/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88000c1c7250
> 0  7923  27668 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c6fa0 0000000000000082
> 0000000000000000 ffff8801c25e63e0
> Jan 19 11:25:38 teletex kernel: ffff8801120f6000 ffff8801120f7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801120f6000 ffff8801120f6010
> ffff8801120f7fd8 ffff88000c1c6fa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b15fa>] ?
> start_this_handle+0x42a/0x4e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8147e426>] ? __alloc_skb+0x46/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ee9f0>] ?
> get_partial_node+0x130/0x2e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f2115>] ?
> kmem_cache_alloc+0xa5/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe70f>] ? cdev_get+0x5f/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe9b7>] ? chrdev_open+0x117/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105871>] ? do_lookup+0x41/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff811099cc>] ? do_last+0x8c/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a215>] ? path_openat+0x115/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a64d>] ? do_filp_open+0x4d/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff88000c1c54f0
> 0  7931   7923 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c5240 0000000000000086
> ffff88040be23810 ffff8801f9949d60
> Jan 19 11:25:38 teletex kernel: ffff8801be05e000 ffff8801be05ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801be05e000 ffff8801be05e010
> ffff8801be05ffd8 ffff88000c1c5240
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004799>] ?
> sky2_xmit_frame+0x329/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81487cfd>] ?
> dev_hard_start_xmit+0x2fd/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107e898>] ?
> start_flush_work+0x98/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478149>] ? release_sock+0x19/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff814b9122>] ? tcp_sendmsg+0x842/0xce0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb7de>] ? sys_write+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff88000c1c02b0
> 0  7942   7931 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c0000 0000000000000086
> ffff880126bbdc00 ffff880117a20000
> Jan 19 11:25:38 teletex kernel: ffff88011225e000 ffff88011225ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011225e000 ffff88011225e010
> ffff88011225ffd8 ffff88000c1c0000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sudo            S ffff88000c1c3790
> 0  8055   7942 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c34e0 0000000000000082
> 0000000000000000 ffff88000c1c63e0
> Jan 19 11:25:38 teletex kernel: ffff88040b3d0000 ffff88040b3d1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88040b3d0000 ffff88040b3d0010
> ffff88040b3d1fd8 ffff88000c1c34e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811ab362>] ?
> ext4_ind_map_blocks+0xc2/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105fb03>] ?
> pick_next_task_fair+0x103/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81057e78>] ? pte_alloc_one+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1030>] ? pagevec_strip+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1c7d>] ?
> pagevec_lru_move_fn+0xbd/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1429>] ? do_wp_page+0x3d9/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: su              S ffff88000c1c6690
> 0  8056   8055 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88000c1c63e0 0000000000000086
> ffff88040acd9500 ffff8801c25e2920
> Jan 19 11:25:38 teletex kernel: ffff8801110d0000 ffff8801110d1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801110d0000 ffff8801110d0010
> ffff8801110d1fd8 ffff88000c1c63e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff8801c25e2bd0
> 0  8064   8056 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801c25e2920 0000000000000082
> ffff88040acdbb80 ffff88017e6c9780
> Jan 19 11:25:38 teletex kernel: ffff8801112d2000 ffff8801112d3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801112d2000 ffff8801112d2010
> ffff8801112d3fd8 ffff8801c25e2920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: kworker/0:0     S ffff8801f994f250
> 0  8231      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801f994efa0 0000000000000046
> 0000000000000001 ffff88015baaefa0
> Jan 19 11:25:38 teletex kernel: ffff880164742000 ffff880164743fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880164742000 ffff880164742010
> ffff880164743fd8 ffff8801f994efa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134b0de>] ?
> scsi_request_fn+0xbe/0x570
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8150>] ? cfq_kick_queue+0x30/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:32    S ffff8801cf382010
> 0  8250      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf381d60 0000000000000046
> ffff880143201df0 ffff8801f994e9c0
> Jan 19 11:25:38 teletex kernel: ffff880143200000 ffff880143201fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880143200000 ffff880143200010
> ffff880143201fd8 ffff8801cf381d60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106bbc9>] ? release_task+0x239/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/1:4     S ffff8801cf3802b0
> 0  8259      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff8801cf380000 0000000000000046
> 0023186000000001 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff880138d70000 ffff880138d71fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880138d70000 ffff880138d70010
> ffff880138d71fd8 ffff8801cf380000
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455cee>] ? do_dbs_timer+0x20e/0x3d0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455ae0>] ?
> powersave_bias_target+0x180/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: lsof            D ffff8801cf382bd0
> 0  8261   8064 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff8801cf382920 0000000000000086
> ffff88012618c2b8 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff88011100a000 ffff88011100bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011100a000 ffff88011100a010
> ffff88011100bfd8 ffff8801cf382920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811059a1>] ? do_lookup+0x171/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110742c>] ? path_lookupat+0xcc/0x780
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1d47>] ?
> handle_pte_fault+0x537/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154929d>] ?
> rwsem_down_failed_common+0xbd/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff812b8334>] ?
> call_rwsem_down_read_failed+0x14/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154892e>] ? down_read+0xe/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff81066e7d>] ? get_mm_exe_file+0x1d/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff81152d83>] ? proc_exe_link+0x63/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81151d0f>] ?
> proc_pid_readlink+0x5f/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ff326>] ? sys_readlinkat+0x76/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: lsof            x ffff8801f994abd0
> 0  8262   8261 0x00000004
> Jan 19 11:25:38 teletex kernel: ffff8801f994a920 0000000000000046
> 0000000000000011 ffff88000c1c5240
> Jan 19 11:25:38 teletex kernel: ffff88011100c000 ffff88011100dfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88011100c000 ffff88011100c010
> ffff88011100dfd8 ffff8801f994a920
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff81079bc2>] ?
> do_notify_parent+0x182/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff810b111f>] ?
> perf_event_exit_task+0xbf/0x1f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106d10d>] ? do_exit+0x55d/0x810
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106d410>] ? do_group_exit+0x50/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107a4f9>] ?
> get_signal_to_deliver+0x1c9/0x510
> Jan 19 11:25:38 teletex kernel: [<ffffffff8103235d>] ? do_signal+0x9d/0x770
> Jan 19 11:25:38 teletex kernel: [<ffffffff81032a95>] ?
> do_notify_resume+0x65/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a35b>] ? int_signal+0x12/0x17
> Jan 19 11:25:38 teletex kernel: kworker/u:2     S ffff880132e1c350
> 0  8269      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1c0a0 0000000000000046
> 0000000000000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801becc6000 ffff8801becc7fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801becc6000 ffff8801becc6010
> ffff8801becc7fd8 ffff880132e1c0a0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8139d1ae>] ?
> mpt_fault_reset_work+0x9e/0x3e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108bc20>] ? async_schedule+0x20/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff8139d110>] ?
> mpt_HardResetHandler+0x280/0x280
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: sshd            S ffff880132e1dad0
> 0  8270  27668 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1d820 0000000000000086
> ffff8801b4d76000 ffff8801f994e9c0
> Jan 19 11:25:38 teletex kernel: ffff8801b4d76000 ffff8801b4d77fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801b4d76000 ffff8801b4d76010
> ffff8801b4d77fd8 ffff880132e1d820
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811b15fa>] ?
> start_this_handle+0x42a/0x4e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f3ad5>] ?
> __kmalloc_track_caller+0x105/0x160
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81478a70>] ?
> sock_alloc_send_pskb+0x1d0/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81474a9b>] ? sock_sendmsg+0xab/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812ae012>] ? kobject_get+0x12/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe70f>] ? cdev_get+0x5f/0xb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fe9b7>] ? chrdev_open+0x117/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff81105871>] ? do_lookup+0x41/0x350
> Jan 19 11:25:38 teletex kernel: [<ffffffff811116ae>] ? dput+0x1e/0x190
> Jan 19 11:25:38 teletex kernel: [<ffffffff811099cc>] ? do_last+0x8c/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a215>] ? path_openat+0x115/0x420
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110a64d>] ? do_filp_open+0x4d/0xc0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d391>] ? sys_poll+0x71/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sshd            S ffff880132e1e0b0
> 0  8281   8270 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e1de00 0000000000000086
> ffff88040be23810 ffff88040da3a340
> Jan 19 11:25:38 teletex kernel: ffff880103332000 ffff880103333fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880103332000 ffff880103332010
> ffff880103333fd8 ffff880132e1de00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffffa0004799>] ?
> sky2_xmit_frame+0x329/0x6b0 [sky2]
> Jan 19 11:25:38 teletex kernel: [<ffffffff8146871e>] ? map_sg+0x15e/0x1e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81487cfd>] ?
> dev_hard_start_xmit+0x2fd/0x5f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107e898>] ?
> start_flush_work+0x98/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d38c>] ? __wake_up+0x3c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff814781d0>] ? release_sock+0xa0/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff814b9122>] ? tcp_sendmsg+0x842/0xce0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb7de>] ? sys_write+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff880406e0f830
> 0  8294   8281 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0f580 0000000000000082
> ffff88040b208380 ffff880406e08000
> Jan 19 11:25:38 teletex kernel: ffff8801095d4000 ffff8801095d5fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801095d4000 ffff8801095d4010
> ffff8801095d5fd8 ffff880406e0f580
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130f258>] ?
> tty_check_change+0xf8/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130cc58>] ? tty_get_pgrp+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130fdbf>] ? tty_ioctl+0xb5f/0xbb0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: sudo            S ffff880406e0a5f0
> 0  8393   8294 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0a340 0000000000000086
> 0000000000000000 ffff880406e08bc0
> Jan 19 11:25:38 teletex kernel: ffff880141f2a000 ffff880141f2bfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880141f2a000 ffff880141f2a010
> ffff880141f2bfd8 ffff880406e0a340
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff811ab362>] ?
> ext4_ind_map_blocks+0xc2/0x550
> Jan 19 11:25:38 teletex kernel: [<ffffffff810890e2>] ?
> __hrtimer_start_range_ns+0x1f2/0x3b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff815488bd>] ?
> schedule_hrtimeout_range_clock+0x11d/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff81186330>] ?
> ext4_map_blocks+0x170/0x200
> Jan 19 11:25:38 teletex kernel: [<ffffffff810ee9f0>] ?
> get_partial_node+0x130/0x2e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff814eb04c>] ?
> unix_dgram_poll+0x18c/0x1b0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110c9e4>] ?
> poll_schedule_timeout+0x44/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
> Jan 19 11:25:38 teletex kernel: [<ffffffff81057e78>] ? pte_alloc_one+0x38/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff810be21b>] ?
> __alloc_pages_nodemask+0x10b/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1030>] ? pagevec_strip+0x70/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1c7d>] ?
> pagevec_lru_move_fn+0xbd/0xe0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1429>] ? do_wp_page+0x3d9/0x7c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110dcae>] ?
> core_sys_select+0x1be/0x300
> Jan 19 11:25:38 teletex kernel: [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff810643db>] ?
> wake_up_new_task+0xeb/0x140
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110e052>] ? sys_select+0x42/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: su              S ffff880406e08e70
> 0  8395   8393 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e08bc0 0000000000000082
> ffff880400000000 ffffffff8171b020
> Jan 19 11:25:38 teletex kernel: ffff8801d526e000 ffff8801d526ffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801d526e000 ffff8801d526e010
> ffff8801d526ffd8 ffff880406e08bc0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810d1c25>] ?
> handle_pte_fault+0x415/0x930
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c8e1>] ? do_wait+0x1f1/0x230
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106c9ab>] ? sys_wait4+0x8b/0xf0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81077a58>] ?
> set_current_blocked+0x38/0x60
> Jan 19 11:25:38 teletex kernel: [<ffffffff8106b020>] ?
> wait_noreap_copyout+0x120/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: bash            S ffff880132e19a30
> 0  8403   8395 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880132e19780 0000000000000082
> 0000000000000000 ffff8801c25e63e0
> Jan 19 11:25:38 teletex kernel: ffff8801032b2000 ffff8801032b3fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801032b2000 ffff8801032b2010
> ffff8801032b3fd8 ffff880132e19780
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105dcd4>] ?
> check_preempt_wakeup+0xb4/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d014>] ?
> check_preempt_curr+0x74/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547c5d>] ?
> schedule_timeout+0x1bd/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff8107ee12>] ? flush_work+0x12/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff813139a7>] ? n_tty_read+0x537/0x850
> Jan 19 11:25:38 teletex kernel: [<ffffffff81064d40>] ?
> try_to_wake_up+0x260/0x260
> Jan 19 11:25:38 teletex kernel: [<ffffffff8130d3d5>] ? tty_read+0xb5/0x100
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
> Jan 19 11:25:38 teletex kernel: [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: flush-253:8     S ffff88040da3bd70
> 0  8482      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3bac0 0000000000000046
> ffff88015f6bda00 ffff880407ffa920
> Jan 19 11:25:38 teletex kernel: ffff8801bc914000 ffff8801bc915fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8801bc914000 ffff8801bc914010
> ffff8801bc915fd8 ffff88040da3bac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81075863>] ? lock_timer_base+0x33/0x70
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:9     S ffff88040da3e0b0
> 0  8487      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88040da3de00 0000000000000046
> ffff88010badbdf0 ffff88040daad820
> Jan 19 11:25:38 teletex kernel: ffff88010bada000 ffff88010badbfd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010bada000 ffff88010bada010
> ffff88010badbfd8 ffff88040da3de00
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/0:3     S ffff88015baaf250
> 0  8617      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88015baaefa0 0000000000000046
> 002dc6c000000000 ffff8801c25e2340
> Jan 19 11:25:38 teletex kernel: ffff88010ab06000 ffff88010ab07fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010ab06000 ffff88010ab06010
> ffff88010ab07fd8 ffff88015baaefa0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134b0de>] ?
> scsi_request_fn+0xbe/0x570
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8150>] ? cfq_kick_queue+0x30/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff81455ae0>] ?
> powersave_bias_target+0x180/0x180
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: kworker/1:0     S ffff880406e0e690
> 0  8622      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880406e0e3e0 0000000000000046
> ffff8801dbaee810 ffff8801f994e9c0
> Jan 19 11:25:38 teletex kernel: ffff88010d480000 ffff88010d481fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff88010d480000 ffff88010d480010
> ffff88010d481fd8 ffff880406e0e3e0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8134b0de>] ?
> scsi_request_fn+0xbe/0x570
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8150>] ? cfq_kick_queue+0x30/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff812a8120>] ?
> cfq_init_queue+0x3a0/0x3a0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8108075a>] ?
> process_one_work+0x12a/0x3c0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ecd>] ? worker_thread+0x1ed/0x3f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81080ce0>] ?
> rescuer_thread+0x2f0/0x2f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:23    S ffff880117a23d70
> 0  8689      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff880117a23ac0 0000000000000046
> ffff880000000000 ffff88040d86bac0
> Jan 19 11:25:38 teletex kernel: ffff880013dbe000 ffff880013dbffd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff880013dbe000 ffff880013dbe010
> ffff880013dbffd8 ffff880117a23ac0
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: flush-253:44    S ffff88017e6ccf10
> 0  8716      2 0x00000000
> Jan 19 11:25:38 teletex kernel: ffff88017e6ccc60 0000000000000046
> ffff8801113b1440 ffff88040d94efa0
> Jan 19 11:25:38 teletex kernel: ffff8800206c0000 ffff8800206c1fd8
> 0000000000010380 0000000000004000
> Jan 19 11:25:38 teletex kernel: ffff8800206c0000 ffff8800206c0010
> ffff8800206c1fd8 ffff88017e6ccc60
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfa9d>] ?
> determine_dirtyable_memory+0xd/0x20
> Jan 19 11:25:38 teletex kernel: [<ffffffff810bfb2d>] ?
> global_dirty_limits+0x2d/0x120
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f38e>] ?
> wb_do_writeback+0xde/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81547bff>] ?
> schedule_timeout+0x15f/0x220
> Jan 19 11:25:38 teletex kernel: [<ffffffff81075cc0>] ? del_timer+0x80/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f5cb>] ?
> bdi_writeback_thread+0x10b/0x150
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff8111f4c0>] ?
> wb_do_writeback+0x210/0x210
> Jan 19 11:25:38 teletex kernel: [<ffffffff81084a66>] ? kthread+0x96/0xa0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f4>] ?
> kernel_thread_helper+0x4/0x10
> Jan 19 11:25:38 teletex kernel: [<ffffffff810849d0>] ?
> kthread_worker_fn+0x130/0x130
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> Jan 19 11:25:38 teletex kernel: SysRq : Show Regs
> Jan 19 11:25:38 teletex kernel: CPU 1
> Jan 19 11:25:38 teletex kernel: Modules linked in: ntfs scst_disk
> scst_tape scst_cdrom scst_changer scst_vdisk scst_modisk
> scst_processor scst_user scst_raid qla2x00tgt scst tun xfs qla2xxx
> sky2 [last unloaded: scsi_wait_scan]
> Jan 19 11:25:38 teletex kernel:
> Jan 19 11:25:38 teletex kernel: Pid: 6057, comm: kvm Tainted: G
> W   3.1.0.9 #7 System manufacturer System Product Name/Crosshair IV
> Formula
> Jan 19 11:25:38 teletex kernel: RIP: 0010:[<ffffffff8101092c>]
> [<ffffffff8101092c>] kvm_arch_vcpu_ioctl_run+0x45c/0xf90
> Jan 19 11:25:38 teletex kernel: RSP: 0018:ffff8801d43fdd28  EFLAGS: 00000282
> Jan 19 11:25:38 teletex kernel: RAX: 0000000000000000 RBX:
> 00007f8315bdb1d0 RCX: 0000000100000000
> Jan 19 11:25:38 teletex kernel: RDX: ffff8804079157a8 RSI:
> 0000000100000000 RDI: ffff880407913620
> Jan 19 11:25:38 teletex kernel: RBP: ffff880407913650 R08:
> 000000000000003d R09: 000000000000005a
> Jan 19 11:25:38 teletex kernel: R10: 00007f8308e3a418 R11:
> 0000000000000065 R12: ffff880407913620
> Jan 19 11:25:38 teletex kernel: R13: ffff880407913650 R14:
> ffff880130e48038 R15: ffff8801d43fdfd8
> Jan 19 11:25:38 teletex kernel: FS:  00007f82e6afb700(0000)
> GS:ffff88041fd00000(0000) knlGS:ffff880005500000
> Jan 19 11:25:38 teletex kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Jan 19 11:25:38 teletex kernel: CR2: 00007f8316a2fc48 CR3:
> 00000001d4234000 CR4: 00000000000006e0
> Jan 19 11:25:38 teletex kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Jan 19 11:25:38 teletex kernel: DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Jan 19 11:25:38 teletex kernel: Process kvm (pid: 6057, threadinfo
> ffff8801d43fc000, task ffff8801f9949d60)
> Jan 19 11:25:38 teletex kernel: 0000000000000000 0000000081860100
> ffff8801d43fddb8 ffffffff8105e720
> Jan 19 11:25:38 teletex kernel: 0000000000000001 ffff8801d43fc010
> 00ff880100000010 ffff8804079157d5
> Jan 19 11:25:38 teletex kernel: ffff880407915700 ffff8801d43fc000
> ffff8801d43fc000 ffff8804079157a8
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: Call Trace:
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105e720>] ?
> __dequeue_entity+0x40/0x50
> Jan 19 11:25:38 teletex kernel: [<ffffffff8100498f>] ?
> kvm_vcpu_ioctl+0x4df/0x5e0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8105c790>] ?
> __wake_up_common+0x50/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
> Jan 19 11:25:38 teletex kernel: [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
> Jan 19 11:25:38 teletex kernel: [<ffffffff8154a13b>] ?
> system_call_fastpath+0x16/0x1b
> Jan 19 11:25:38 teletex kernel: CPU#1: active:     0000000000000000
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC0 ctrl:  0000030d011c2e58
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC0 count: 00006a601bc615a6
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC0 left:  0000000000000000
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC1 ctrl:  0000030e5507e8b1
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC1 count: 0000004c11029b7c
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC1 left:  0000000000000000
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC2 ctrl:  0000020c4499ecaf
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC2 count: 00003cc1d99dc20b
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC2 left:  0000000000000000
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC3 ctrl:  0000030b840988df
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC3 count: 0000b57496cd674f
> Jan 19 11:25:38 teletex kernel: CPU#1:   gen-PMC3 left:  0000000000000000
>
>
> On Thu, Jan 19, 2012 at 20:34, kordex <kordex@gmail.com> wrote:
>> Full dmesg of the case attached.
>>
>> Br,
>> -Mikko Kortelainen
>>
>> On Thu, Jan 19, 2012 at 13:12, Bart Van Assche <bvanassche@acm.org> wrote:
>>> On Thu, Jan 19, 2012 at 11:54 AM, kordex <kordex@gmail.com> wrote:
>>>> > root@teletex:/usr/src/linux# dmesg
>>>> > +0x12e7/0x1c50
>>>> >  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>>>
>>> The above output is truncated - the most interesting part is missing.
>>>
>>> Bart.

Do I need to give you anything else? Any leads on what the problem
might be? The machine is still running and in this state.

top - 16:58:19 up 19 days, 20:48,  1 user,  load average: 78.00, 78.04, 78.08

Br,
-Mikko Kortelainen
