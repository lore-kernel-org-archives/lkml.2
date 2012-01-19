Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2ASKyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:54:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39609 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2ASKyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
Date: Thu, 19 Jan 2012 12:54:17 +0200
Message-ID: <CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
Subject: Re: BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: kordex <kordex@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, peterz@infradead.org,
        kvm@vger.kernel.org, avi@redhat.com,
        Mikko Kortelainen <mikko.kortelainen@fail-safe.net>,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also sending to scst-devel@lists.sou­rceforge.net as patch is theirs.

On Thu, Jan 19, 2012 at 12:23, kordex <kordex@gmail.com> wrote:
> Greetings,
>
> I was powering up kvm virtual machine (Windows 7 guest). Spice-client
> shows 'Windows starting up' but it was hanged. After that i got to
> console to see the cause and saw that ps -eLf is unable to return all
> the processes as it hangs too. Also lsof hangs.
>
> The machine is up and running and I am able to access it.
>
> It's a x86_64 machine with 16G ram and powered by AMD Athlon(tm) II X2
> 250 on ASUS crosshair iv board, addon cards LSI Logic  SAS1068E
> controller and two QLogic ISP2312-based fc-cards. Matrox Graphics,
> Inc. MGA G550 AGP pcie-1x graphics. userland is debian sid.
>
> This is a vanilla kernel with only scst lifo-patch applied (should not
> count in any way) and qla2xxx-tgt module loaded. Patch and other
> related info attached.
>
> Linux teletex 3.1.0.9 #7 SMP PREEMPT Mon Nov 21 22:13:25 EET 2011
> x86_64 GNU/Linux
>
> root@teletex:/usr/src# md5sum linux-3.1.tar.bz2 # source provided from
> this iirc was 3.1.0.1. (local version .9)
> 8d43453f8159b2332ad410b19d86a931  linux-3.1.tar.bz2
>
> root@teletex:/usr/src/linux# dmesg
> +0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040cad02b0     0  3136      1 0x00000000
>  ffff88040cad0000 0000000000000082 0000000000000246 ffff88040cad5e00
>  ffff880405836000 ffff880405837fd8 0000000000010380 0000000000004000
>  ffff880405836000 ffff880405836010 ffff880405837fd8 ffff88040cad0000
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040cad60b0     0  3137      1 0x00000000
>  ffff88040cad5e00 0000000000000082 0000000000000246 ffff88040cad1780
>  ffff880405838000 ffff880405839fd8 0000000000010380 0000000000004000
>  ffff880405838000 ffff880405838010 ffff880405839fd8 ffff88040cad5e00
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040cad1a30     0  3138      1 0x00000000
>  ffff88040cad1780 0000000000000082 0000000000000246 ffff88040d8a6fa0
>  ffff88040583a000 ffff88040583bfd8 0000000000010380 0000000000004000
>  ffff88040583a000 ffff88040583a010 ffff88040583bfd8 ffff88040cad1780
> Call Trace:
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040d8a7250     0  3139      1 0x00000000
>  ffff88040d8a6fa0 0000000000000082 0000000000000246 ffff88040d8a1780
>  ffff88040583c000 ffff88040583dfd8 0000000000010380 0000000000004000
>  ffff88040583c000 ffff88040583c010 ffff88040583dfd8 ffff88040d8a6fa0
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040d8a1a30     0  3140      1 0x00000000
>  ffff88040d8a1780 0000000000000082 0000000000000246 ffff88040d8a11a0
>  ffff88040583e000 ffff88040583ffd8 0000000000010380 0000000000004000
>  ffff88040583e000 ffff88040583e010 ffff88040583ffd8 ffff88040d8a1780
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040d8a1450     0  3141      1 0x00000000
>  ffff88040d8a11a0 0000000000000082 0000000000000246 ffff88040d86e3e0
>  ffff880407080000 ffff880407081fd8 0000000000010380 0000000000004000
>  ffff880407080000 ffff880407080010 ffff880407081fd8 ffff88040d8a11a0
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a0d7>] ? system_call_after_swapgs+0x17/0x65
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040d86e690     0  3142      1 0x00000000
>  ffff88040d86e3e0 0000000000000082 0000000000000246 ffff88040d86d240
>  ffff880407082000 ffff880407083fd8 0000000000010380 0000000000004000
>  ffff880407082000 ffff880407082010 ffff880407083fd8 ffff88040d86e3e0
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040d86d4f0     0  3143      1 0x00000000
>  ffff88040d86d240 0000000000000082 0000000000000246 ffff880407088000
>  ffff880407084000 ffff880407085fd8 0000000000010380 0000000000004000
>  ffff880407084000 ffff880407084010 ffff880407085fd8 ffff88040d86d240
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff8804070882b0     0  3144      1 0x00000000
>  ffff880407088000 0000000000000082 0000000000000246 ffff8804070885e0
>  ffff880407086000 ffff880407087fd8 0000000000010380 0000000000004000
>  ffff880407086000 ffff880407086010 ffff880407087fd8 ffff880407088000
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff880407088890     0  3145      1 0x00000000
>  ffff8804070885e0 0000000000000082 0000000000000246 ffff880407088bc0
>  ffff880407090000 ffff880407091fd8 0000000000010380 0000000000004000
>  ffff880407090000 ffff880407090010 ffff880407091fd8 ffff8804070885e0
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8105e720>] ? __dequeue_entity+0x40/0x50
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff880407088e70     0  3146      1 0x00000000
>  ffff880407088bc0 0000000000000082 0000000000000246 ffff8804070891a0
>  ffff880407092000 ffff880407093fd8 0000000000010380 0000000000004000
>  ffff880407092000 ffff880407092010 ffff880407093fd8 ffff880407088bc0
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff880407089450     0  3147      1 0x00000000
>  ffff8804070891a0 0000000000000082 0000000000000246 ffff880407089780
>  ffff880407094000 ffff880407095fd8 0000000000010380 0000000000004000
>  ffff880407094000 ffff880407094010 ffff880407095fd8 ffff8804070891a0
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff880407089a30     0  3148      1 0x00000000
>  ffff880407089780 0000000000000082 0000000000000246 ffff880407089d60
>  ffff880407096000 ffff880407097fd8 0000000000010380 0000000000004000
>  ffff880407096000 ffff880407096010 ffff880407097fd8 ffff880407089780
> Call Trace:
>  [<ffffffff81549798>] ? _raw_spin_unlock_irqrestore+0x8/0x30
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708a010     0  3149      1 0x00000000
>  ffff880407089d60 0000000000000082 0000000000000246 ffff88040708a340
>  ffff880407098000 ffff880407099fd8 0000000000010380 0000000000004000
>  ffff880407098000 ffff880407098010 ffff880407099fd8 ffff880407089d60
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708a5f0     0  3150      1 0x00000000
>  ffff88040708a340 0000000000000082 0000000000000246 ffff88040708a920
>  ffff88040709a000 ffff88040709bfd8 0000000000010380 0000000000004000
>  ffff88040709a000 ffff88040709a010 ffff88040709bfd8 ffff88040708a340
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708abd0     0  3151      1 0x00000000
>  ffff88040708a920 0000000000000082 0000000000000246 ffff88040708af00
>  ffff88040709c000 ffff88040709dfd8 0000000000010380 0000000000004000
>  ffff88040709c000 ffff88040709c010 ffff88040709dfd8 ffff88040708a920
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708b1b0     0  3152      1 0x00000000
>  ffff88040708af00 0000000000000082 0000000000000246 ffff88040708b4e0
>  ffff88040709e000 ffff88040709ffd8 0000000000010380 0000000000004000
>  ffff88040709e000 ffff88040709e010 ffff88040709ffd8 ffff88040708af00
> Call Trace:
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708b790     0  3153      1 0x00000000
>  ffff88040708b4e0 0000000000000082 0000000000000246 ffffffff8171b020
>  ffff880407fe0000 ffff880407fe1fd8 0000000000010380 0000000000004000
>  ffff880407fe0000 ffff880407fe0010 ffff880407fe1fd8 ffff88040708b4e0
> Call Trace:
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708bd70     0  3154      1 0x00000000
>  ffff88040708bac0 0000000000000082 0000000000000246 ffffffff8171b020
>  ffff880407fe2000 ffff880407fe3fd8 0000000000010380 0000000000004000
>  ffff880407fe2000 ffff880407fe2010 ffff880407fe3fd8 ffff88040708bac0
> Call Trace:
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708c350     0  3155      1 0x00000000
>  ffff88040708c0a0 0000000000000082 0000000000000246 ffffffff8171b020
>  ffff880407fe4000 ffff880407fe5fd8 0000000000010380 0000000000004000
>  ffff880407fe4000 ffff880407fe4010 ffff880407fe5fd8 ffff88040708c0a0
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708c930     0  3156      1 0x00000000
>  ffff88040708c680 0000000000000082 0000000000000246 ffff88040708cc60
>  ffff880407fe6000 ffff880407fe7fd8 0000000000010380 0000000000004000
>  ffff880407fe6000 ffff880407fe6010 ffff880407fe7fd8 ffff88040708c680
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708cf10     0  3157      1 0x00000000
>  ffff88040708cc60 0000000000000082 0000000000000246 ffff88040708d240
>  ffff880407fe8000 ffff880407fe9fd8 0000000000010380 0000000000004000
>  ffff880407fe8000 ffff880407fe8010 ffff880407fe9fd8 ffff88040708cc60
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708d4f0     0  3158      1 0x00000000
>  ffff88040708d240 0000000000000082 0000000000000246 ffff88040708d820
>  ffff880407fea000 ffff880407febfd8 0000000000010380 0000000000004000
>  ffff880407fea000 ffff880407fea010 ffff880407febfd8 ffff88040708d240
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708dad0     0  3159      1 0x00000000
>  ffff88040708d820 0000000000000082 0000000000000246 ffffffff8171b020
>  ffff880407fec000 ffff880407fedfd8 0000000000010380 0000000000004000
>  ffff880407fec000 ffff880407fec010 ffff880407fedfd8 ffff88040708d820
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708e0b0     0  3160      1 0x00000000
>  ffff88040708de00 0000000000000082 0000000000000246 ffff88040708e3e0
>  ffff880407fee000 ffff880407feffd8 0000000000010380 0000000000004000
>  ffff880407fee000 ffff880407fee010 ffff880407feffd8 ffff88040708de00
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810c1d40>] ? __lru_cache_add+0x80/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708e690     0  3161      1 0x00000000
>  ffff88040708e3e0 0000000000000082 0000000000000246 ffff88040708e9c0
>  ffff880407ff0000 ffff880407ff1fd8 0000000000010380 0000000000004000
>  ffff880407ff0000 ffff880407ff0010 ffff880407ff1fd8 ffff88040708e3e0
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff812b2a26>] ? __rwsem_do_wake+0x186/0x1b0
>  [<ffffffff812b2b0a>] ? rwsem_wake+0x4a/0x60
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff810894f6>] ? up_read+0x16/0x20
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708ec70     0  3162      1 0x00000000
>  ffff88040708e9c0 0000000000000082 0000000000000246 ffff88040708efa0
>  ffff880407ff2000 ffff880407ff3fd8 0000000000010380 0000000000004000
>  ffff880407ff2000 ffff880407ff2010 ffff880407ff3fd8 ffff88040708e9c0
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708f250     0  3163      1 0x00000000
>  ffff88040708efa0 0000000000000082 0000000000000246 ffff88040708f580
>  ffff880407ff4000 ffff880407ff5fd8 0000000000010380 0000000000004000
>  ffff880407ff4000 ffff880407ff4010 ffff880407ff5fd8 ffff88040708efa0
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff81096cfb>] ? do_futex+0x11b/0xae0
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040708f830     0  3164      1 0x00000000
>  ffff88040708f580 0000000000000082 0000000000000246 ffffffff8171b020
>  ffff880407ff6000 ffff880407ff7fd8 0000000000010380 0000000000004000
>  ffff880407ff6000 ffff880407ff6010 ffff880407ff7fd8 ffff88040708f580
> Call Trace:
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff81318e7f>] ? vt_event_wait+0x9f/0x120
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81318f24>] ? vt_waitactive+0x24/0x50
>  [<ffffffff8105e720>] ? __dequeue_entity+0x40/0x50
>  [<ffffffff8131a577>] ? vt_ioctl+0x12e7/0x1c50
>  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>  [<ffffffff810d1d47>] ? handle_pte_fault+0x537/0x930
>  [<ffffffff8130f500>] ? tty_ioctl+0x2a0/0xbb0
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8110b97b>] ? do_vfs_ioctl+0x9b/0x4f0
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff8110be19>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> console-kit-dae S ffff88040da3c930     0  3166      1 0x00000000
>  ffff88040da3c680 0000000000000082 ffff880400000000 ffff88040daaf580
>  ffff880407de0000 ffff880407de1fd8 0000000000010380 0000000000004000
>  ffff880407de0000 ffff880407de0010 ffff880407de1fd8 ffff88040da3c680
> Call Trace:
>  [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
>  [<ffffffff812ac2d2>] ? cpumask_next_and+0x22/0x40
>  [<ffffffff81103f61>] ? pipe_wait+0x51/0x70
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8105dcd4>] ? check_preempt_wakeup+0xb4/0x170
>  [<ffffffff8110498d>] ? pipe_read+0x38d/0x4b0
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff810fac7f>] ? do_sync_read+0xbf/0x100
>  [<ffffffff81064d40>] ? try_to_wake_up+0x260/0x260
>  [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
>  [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> getty           S ffff880406e0bd70     0  4123      1 0x00000000
>  ffff880406e0bac0 0000000000000082 ffffffff00000000 ffff880407ff8000
>  ffff88040563e000 ffff88040563ffd8 0000000000010380 0000000000004000
>  ffff88040563e000 ffff88040563e010 ffff88040563ffd8 ffff880406e0bac0
> Call Trace:
>  [<ffffffff8108a4a3>] ? __atomic_notifier_call_chain+0x43/0x50
>  [<ffffffff81320805>] ? notify_update+0x25/0x30
>  [<ffffffff81547c5d>] ? schedule_timeout+0x1bd/0x220
>  [<ffffffff8107ee12>] ? flush_work+0x12/0x30
>  [<ffffffff8131339e>] ? copy_from_read_buf+0x6e/0x140
>  [<ffffffff813139a7>] ? n_tty_read+0x537/0x850
>  [<ffffffff81064d40>] ? try_to_wake_up+0x260/0x260
>  [<ffffffff8130d3d5>] ? tty_read+0xb5/0x100
>  [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
>  [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
>  [<ffffffff81549d2f>] ? page_fault+0x1f/0x30
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> kdmflush        S ffff880166e4e0b0     0 14527      2 0x00000000
>  ffff880166e4de00 0000000000000046 ffff88041fd10380 ffff880166e4bac0
>  ffff88015cb1a000 ffff88015cb1bfd8 0000000000010380 0000000000004000
>  ffff88015cb1a000 ffff88015cb1a010 ffff88015cb1bfd8 ffff880166e4de00
> Call Trace:
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff880166e4bd70     0 14529      2 0x00000000
>  ffff880166e4bac0 0000000000000046 ffffffff812b22bc ffff880166e48bc0
>  ffff8801fab94000 ffff8801fab95fd8 0000000000010380 0000000000004000
>  ffff8801fab94000 ffff8801fab94010 ffff8801fab95fd8 ffff880166e4bac0
> Call Trace:
>  [<ffffffff812b22bc>] ? rb_insert_color+0x10c/0x140
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff880166e4cf10     0 14530      2 0x00000000
>  ffff880166e4cc60 0000000000000046 ffffffff8105fb03 ffff880166e4d820
>  ffff8801bc3f0000 ffff8801bc3f1fd8 0000000000010380 0000000000004000
>  ffff8801bc3f0000 ffff8801bc3f0010 ffff8801bc3f1fd8 ffff880166e4cc60
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kmirrord        S ffff880166e4f830     0 14535      2 0x00000000
>  ffff880166e4f580 0000000000000046 ffff88007642be40 ffff8801f994c0a0
>  ffff8804068ba000 ffff8804068bbfd8 0000000000010380 0000000000004000
>  ffff8804068ba000 ffff8804068ba010 ffff8804068bbfd8 ffff880166e4f580
> Call Trace:
>  [<ffffffff81450120>] ? do_reads+0x230/0x230
>  [<ffffffff8108075a>] ? process_one_work+0x12a/0x3c0
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kcopyd          S ffff880166e49450     0 14536      2 0x00000000
>  ffff880166e491a0 0000000000000046 ffff88011013a000 ffff880406e085e0
>  ffff88011013a000 ffff88011013bfd8 0000000000010380 0000000000004000
>  ffff88011013a000 ffff88011013a010 ffff88011013bfd8 ffff880166e491a0
> Call Trace:
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff880406e0c350     0 14537      2 0x00000000
>  ffff880406e0c0a0 0000000000000046 ffffffff812b22bc ffff880406e085e0
>  ffff88011d7a2000 ffff88011d7a3fd8 0000000000010380 0000000000004000
>  ffff88011d7a2000 ffff88011d7a2010 ffff88011d7a3fd8 ffff880406e0c0a0
> Call Trace:
>  [<ffffffff812b22bc>] ? rb_insert_color+0x10c/0x140
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff880406e0c930     0 14539      2 0x00000000
>  ffff880406e0c680 0000000000000046 ffff88018a01c000 ffff880406e08000
>  ffff88018a01c000 ffff88018a01dfd8 0000000000010380 0000000000004000
>  ffff88018a01c000 ffff88018a01c010 ffff88018a01dfd8 ffff880406e0c680
> Call Trace:
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kmirrord        S ffff880132e1c930     0 14542      2 0x00000000
>  ffff880132e1c680 0000000000000046 ffffffff8105fb03 ffff88040d913ac0
>  ffff88010a9c0000 ffff88010a9c1fd8 0000000000010380 0000000000004000
>  ffff88010a9c0000 ffff88010a9c0010 ffff88010a9c1fd8 ffff880132e1c680
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff8105e3f6>] ? task_rq_lock+0x56/0xb0
>  [<ffffffff8106281c>] ? set_cpus_allowed_ptr+0x8c/0x120
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kcopyd          S ffff880132e1abd0     0 14546      2 0x00000000
>  ffff880132e1a920 0000000000000046 ffffffff8105fb03 ffff880132e18000
>  ffff880183d16000 ffff880183d17fd8 0000000000010380 0000000000004000
>  ffff880183d16000 ffff880183d16010 ffff880183d17fd8 ffff880132e1a920
> Call Trace:
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> jbd2/dm-45-8    S ffff88015baac350     0 18293      2 0x00000000
>  ffff88015baac0a0 0000000000000046 ffff880119d29024 ffff8801c25e2340
>  ffff88012b43e000 ffff88012b43ffd8 0000000000010380 0000000000004000
>  ffff88012b43e000 ffff88012b43e010 ffff88012b43ffd8 ffff88015baac0a0
> Call Trace:
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff811b65b2>] ? kjournald2+0x192/0x1e0
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff811b6420>] ? commit_timeout+0x10/0x10
>  [<ffffffff811b6420>] ? commit_timeout+0x10/0x10
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> ext4-dio-unwrit S ffff88015baa82b0     0 18294      2 0x00000000
>  ffff88015baa8000 0000000000000046 ffff88041fc10380 ffff88040d86bac0
>  ffff8801b3c18000 ffff8801b3c19fd8 0000000000010380 0000000000004000
>  ffff8801b3c18000 ffff8801b3c18010 ffff8801b3c19fd8 ffff88015baa8000
> Call Trace:
>  [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff88017e6cf250     0 18857      2 0x00000000
>  ffff88017e6cefa0 0000000000000046 ffff88017e6ce9c0 ffff88040da74c60
>  ffff8801be8ba000 ffff8801be8bbfd8 0000000000010380 0000000000004000
>  ffff8801be8ba000 ffff8801be8ba010 ffff8801be8bbfd8 ffff88017e6cefa0
> Call Trace:
>  [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> loop7           S ffff88017e6cabd0     0  8455      2 0x00000000
>  ffff88017e6ca920 0000000000000046 ffff880108201de0 ffff8801cf385e00
>  ffff880108200000 ffff880108201fd8 0000000000010380 0000000000004000
>  ffff880108200000 ffff880108200010 ffff880108201fd8 ffff88017e6ca920
> Call Trace:
>  [<ffffffff8134264a>] ? loop_thread+0x13a/0x260
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81342510>] ? do_bio_filebacked+0x280/0x280
>  [<ffffffff81342510>] ? do_bio_filebacked+0x280/0x280
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> loop6           S ffff88017e6cf830     0 24605      2 0x00000000
>  ffff88017e6cf580 0000000000000046 ffff880100000000 ffff88040d86d820
>  ffff880105c9a000 ffff880105c9bfd8 0000000000010380 0000000000004000
>  ffff880105c9a000 ffff880105c9a010 ffff880105c9bfd8 ffff88017e6cf580
> Call Trace:
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff81064c93>] ? try_to_wake_up+0x1b3/0x260
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff8134264a>] ? loop_thread+0x13a/0x260
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff81342510>] ? do_bio_filebacked+0x280/0x280
>  [<ffffffff81342510>] ? do_bio_filebacked+0x280/0x280
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kdmflush        S ffff8801cf386c70     0 24943      2 0x00000000
>  ffff8801cf3869c0 0000000000000046 00042dc400042dbc ffff88040d86bac0
>  ffff88011d93c000 ffff88011d93dfd8 0000000000010380 0000000000004000
>  ffff88011d93c000 ffff88011d93c010 ffff88011d93dfd8 ffff8801cf3869c0
> Call Trace:
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> cron            S ffff88040d9a3d70     0 21885      1 0x00000000
>  ffff88040d9a3ac0 0000000000000086 ffff8800604d1fe8 ffffffff8171b020
>  ffff8801aec7c000 ffff8801aec7dfd8 0000000000010380 0000000000004000
>  ffff8801aec7c000 ffff8801aec7c010 ffff8801aec7dfd8 ffff88040d9a3ac0
> Call Trace:
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff81548715>] ? do_nanosleep+0x95/0xc0
>  [<ffffffff81089387>] ? hrtimer_nanosleep+0xa7/0x150
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff81077c95>] ? sigprocmask+0x45/0x80
>  [<ffffffff8108949d>] ? sys_nanosleep+0x6d/0x70
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> udevd           S ffff88017e6cc350     0 21963      1 0x00000000
>  ffff88017e6cc0a0 0000000000000086 000000004f17dbe0 ffff880117a25820
>  ffff88018e7ee000 ffff88018e7effd8 0000000000010380 0000000000004000
>  ffff88018e7ee000 ffff88018e7ee010 ffff88018e7effd8 ffff88017e6cc0a0
> Call Trace:
>  [<ffffffff81474965>] ? sock_recvmsg+0xb5/0xe0
>  [<ffffffff814e9708>] ? unix_peer_get+0x38/0x50
>  [<ffffffff814eaf95>] ? unix_dgram_poll+0xd5/0x1b0
>  [<ffffffff811134c5>] ? __destroy_inode+0x15/0x80
>  [<ffffffff815488bd>] ? schedule_hrtimeout_range_clock+0x11d/0x140
>  [<ffffffff8113337b>] ? ep_scan_ready_list+0x16b/0x170
>  [<ffffffff8113367f>] ? ep_poll+0x2df/0x340
>  [<ffffffff810d9a40>] ? mmap_region+0x240/0x5f0
>  [<ffffffff81064d40>] ? try_to_wake_up+0x260/0x260
>  [<ffffffff811337b5>] ? sys_epoll_wait+0xd5/0xf0
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> ntpd            S ffff880132e1b1b0     0 27698      1 0x00000000
>  ffff880132e1af00 0000000000000082 0000000000000002 ffff88040d86bac0
>  ffff88017c6c2000 ffff88017c6c3fd8 0000000000010380 0000000000004000
>  ffff88017c6c2000 ffff88017c6c2010 ffff88017c6c3fd8 ffff880132e1af00
> Call Trace:
>  [<ffffffff81124e5b>] ? __getblk+0x1b/0x310
>  [<ffffffff815488bd>] ? schedule_hrtimeout_range_clock+0x11d/0x140
>  [<ffffffff81181801>] ? ext4_mark_iloc_dirty+0x331/0x550
>  [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff81112a68>] ? touch_atime+0x58/0x170
>  [<ffffffff811116ae>] ? dput+0x1e/0x190
>  [<ffffffff812b22bc>] ? rb_insert_color+0x10c/0x140
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff81084416>] ? do_schedule_next_timer+0x46/0xe0
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff81077a58>] ? set_current_blocked+0x38/0x60
>  [<ffffffff810324da>] ? do_signal+0x21a/0x770
>  [<ffffffff810f1b44>] ? kmem_cache_free+0x14/0x90
>  [<ffffffff8103b264>] ? fpu_finit+0x14/0x30
>  [<ffffffff8103b2ba>] ? init_fpu+0x3a/0x160
>  [<ffffffff8103be88>] ? restore_i387_xstate+0x148/0x1d0
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff8154a59c>] ? stub_rt_sigreturn+0x6c/0xd0
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> smbd            S ffff8801c25e02b0     0 31456      1 0x00000000
>  ffff8801c25e0000 0000000000000086 ffff8801ad40c000 ffffffff8171b020
>  ffff8801ad40c000 ffff8801ad40dfd8 0000000000010380 0000000000004000
>  ffff8801ad40c000 ffff8801ad40c010 ffff8801ad40dfd8 ffff8801c25e0000
> Call Trace:
>  [<ffffffff812b2244>] ? rb_insert_color+0x94/0x140
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff812b46f1>] ? timerqueue_del+0x31/0x90
>  [<ffffffff8154884e>] ? schedule_hrtimeout_range_clock+0xae/0x140
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
>  [<ffffffff8110ed0f>] ? __d_lookup+0x13f/0x160
>  [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
>  [<ffffffff81112b2d>] ? touch_atime+0x11d/0x170
>  [<ffffffff8110488b>] ? pipe_read+0x28b/0x4b0
>  [<ffffffff8106c81d>] ? do_wait+0x12d/0x230
>  [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
>  [<ffffffff8110c989>] ? poll_select_set_timeout+0x89/0xa0
>  [<ffffffff8110d391>] ? sys_poll+0x71/0x100
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> smbd            S ffff8801c25e4930     0 31463  31456 0x00000000
>  ffff8801c25e4680 0000000000000082 0000000000000004 ffff8801f9949d60
>  ffff880172ee4000 ffff880172ee5fd8 0000000000010380 0000000000004000
>  ffff880172ee4000 ffff880172ee4010 ffff880172ee5fd8 ffff8801c25e4680
> Call Trace:
>  [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff812b46f1>] ? timerqueue_del+0x31/0x90
>  [<ffffffff8154884e>] ? schedule_hrtimeout_range_clock+0xae/0x140
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d101>] ? do_sys_poll+0x411/0x4a0
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff81181330>] ? ext4_get_inode_flags+0x70/0x70
>  [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
>  [<ffffffff8106e17e>] ? current_fs_time+0x1e/0x30
>  [<ffffffff81112b2d>] ? touch_atime+0x11d/0x170
>  [<ffffffff8110488b>] ? pipe_read+0x28b/0x4b0
>  [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
>  [<ffffffff8110c989>] ? poll_select_set_timeout+0x89/0xa0
>  [<ffffffff8110d391>] ? sys_poll+0x71/0x100
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> atd             S ffff880132e1bd70     0 26774      1 0x00000000
>  ffff880132e1bac0 0000000000000086 ffffffff00000028 ffff88000c1c63e0
>  ffff8801b96a0000 ffff8801b96a1fd8 0000000000010380 0000000000004000
>  ffff8801b96a0000 ffff8801b96a0010 ffff8801b96a1fd8 ffff880132e1bac0
> Call Trace:
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff81548715>] ? do_nanosleep+0x95/0xc0
>  [<ffffffff81089387>] ? hrtimer_nanosleep+0xa7/0x150
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff81077c95>] ? sigprocmask+0x45/0x80
>  [<ffffffff8108949d>] ? sys_nanosleep+0x6d/0x70
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> acpid           S ffff880117a20890     0 27084      1 0x00000000
>  ffff880117a205e0 0000000000000086 0000000000000000 ffff8801f994e3e0
>  ffff8801294a6000 ffff8801294a7fd8 0000000000010380 0000000000004000
>  ffff8801294a6000 ffff8801294a6010 ffff8801294a7fd8 ffff880117a205e0
> Call Trace:
>  [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
>  [<ffffffff81468320>] ? __map_single+0x1a0/0x440
>  [<ffffffff815488bd>] ? schedule_hrtimeout_range_clock+0x11d/0x140
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8134d2b8>] ? scsi_dma_map+0x88/0xd0
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff810b73f5>] ? find_get_page+0x75/0xd0
>  [<ffffffff810b7da9>] ? filemap_fault+0x99/0x4a0
>  [<ffffffff810b7540>] ? sleep_on_page+0x10/0x10
>  [<ffffffff815478f1>] ? io_schedule+0xa1/0xd0
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff81403a50>] ? evdev_write+0x150/0x150
>  [<ffffffff81403a57>] ? evdev_read+0x7/0x280
>  [<ffffffff813ff122>] ? input_event_to_user+0x62/0x70
>  [<ffffffff81403b4f>] ? evdev_read+0xff/0x280
>  [<ffffffff811116ae>] ? dput+0x1e/0x190
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> mdadm           S ffff88015baadad0     0 27255      1 0x00000000
>  ffff88015baad820 0000000000000086 0000000000000001 ffff88040d911d60
>  ffff8801912f4000 ffff8801912f5fd8 0000000000010380 0000000000004000
>  ffff8801912f4000 ffff8801912f4010 ffff8801912f5fd8 ffff88015baad820
> Call Trace:
>  [<ffffffff812b22bc>] ? rb_insert_color+0x10c/0x140
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff8154884e>] ? schedule_hrtimeout_range_clock+0xae/0x140
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff812ae012>] ? kobject_get+0x12/0x20
>  [<ffffffff812a2325>] ? get_disk+0x65/0xb0
>  [<ffffffff812a237c>] ? exact_lock+0xc/0x20
>  [<ffffffff8133bc44>] ? kobj_lookup+0x184/0x200
>  [<ffffffff812a20fb>] ? disk_clear_events+0xdb/0x120
>  [<ffffffff812ac2d2>] ? cpumask_next_and+0x22/0x40
>  [<ffffffff8105f3eb>] ? select_task_rq_fair+0x39b/0x850
>  [<ffffffff8105dcd4>] ? check_preempt_wakeup+0xb4/0x170
>  [<ffffffff8105d014>] ? check_preempt_curr+0x74/0x90
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff81064c93>] ? try_to_wake_up+0x1b3/0x260
>  [<ffffffff81084ed9>] ? autoremove_wake_function+0x9/0x30
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff812a1185>] ? blkdev_ioctl+0x205/0x6c0
>  [<ffffffff81113753>] ? iput+0x43/0x230
>  [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> rsyslogd        S ffff88015baae0b0     0 26636      1 0x00000000
>  ffff88015baade00 0000000000000082 0000000000000001 ffff8801f994e3e0
>  ffff88010a8ca000 ffff88010a8cbfd8 0000000000010380 0000000000004000
>  ffff88010a8ca000 ffff88010a8ca010 ffff88010a8cbfd8 ffff88015baade00
> Call Trace:
>  [<ffffffff812b47b0>] ? timerqueue_add+0x60/0xb0
>  [<ffffffff810890e2>] ? __hrtimer_start_range_ns+0x1f2/0x3b0
>  [<ffffffff8154884e>] ? schedule_hrtimeout_range_clock+0xae/0x140
>  [<ffffffff810882b0>] ? update_rmtp+0x80/0x80
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8134d2b8>] ? scsi_dma_map+0x88/0xd0
>  [<ffffffff813a181c>] ? mptscsih_qcmd+0x49c/0x820
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8105e720>] ? __dequeue_entity+0x40/0x50
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
>  [<ffffffff812b1738>] ? radix_tree_delete+0x148/0x2b0
>  [<ffffffff810ab191>] ? delayacct_end+0x81/0xa0
>  [<ffffffff81058af7>] ? flush_tlb_others_ipi+0x107/0x150
>  [<ffffffff81124ce1>] ? __find_get_block+0x71/0x1d0
>  [<ffffffff8119e68c>] ? mb_free_blocks+0x1ec/0x330
>  [<ffffffff81057b88>] ? ptep_set_access_flags+0x28/0x40
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff8108d4ad>] ? ktime_get_ts+0x6d/0xe0
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> rs:main Q:Reg   S ffff88015baaec70     0 26637      1 0x00000000
>  ffff88015baae9c0 0000000000000082 0000000000000064 ffff88040d86bac0
>  ffff880179178000 ffff880179179fd8 0000000000010380 0000000000004000
>  ffff880179178000 ffff880179178010 ffff880179179fd8 ffff88015baae9c0
> Call Trace:
>  [<ffffffff814af0e0>] ? ip_append_page+0x570/0x570
>  [<ffffffff814d22b1>] ? udp_sendmsg+0x361/0x920
>  [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
>  [<ffffffff81094773>] ? get_futex_value_locked+0x23/0x60
>  [<ffffffff81094ccd>] ? futex_wait_queue_me+0xcd/0x110
>  [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
>  [<ffffffff8117e33e>] ? ext4_file_write+0x6e/0x2b0
>  [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
>  [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
>  [<ffffffff810fc0df>] ? fget_light+0x8f/0xf0
>  [<ffffffff81475427>] ? sys_sendto+0x157/0x1a0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> rsyslogd        S ffff88015baa9450     0 26638      1 0x00000000
>  ffff88015baa91a0 0000000000000082 0000000000000001 ffff88015baae9c0
>  ffff880155d82000 ffff880155d83fd8 0000000000010380 0000000000004000
>  ffff880155d82000 ffff880155d82010 ffff880155d83fd8 ffff88015baa91a0
> Call Trace:
>  [<ffffffff810b9969>] ? mempool_alloc+0x59/0x140
>  [<ffffffff81468320>] ? __map_single+0x1a0/0x440
>  [<ffffffff815488bd>] ? schedule_hrtimeout_range_clock+0x11d/0x140
>  [<ffffffff81466ea2>] ? domain_flush_complete+0x42/0x50
>  [<ffffffff8108526c>] ? add_wait_queue+0x1c/0x60
>  [<ffffffff814eb04c>] ? unix_dgram_poll+0x18c/0x1b0
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff810f1b44>] ? kmem_cache_free+0x14/0x90
>  [<ffffffff81480c8c>] ? skb_free_datagram+0xc/0x40
>  [<ffffffff814e9b4f>] ? unix_dgram_recvmsg+0x2af/0x430
>  [<ffffffff814748b0>] ? sock_sendmsg_nosec+0xe0/0xe0
>  [<ffffffff81474965>] ? sock_recvmsg+0xb5/0xe0
>  [<ffffffff812ac2d2>] ? cpumask_next_and+0x22/0x40
>  [<ffffffff8105f3eb>] ? select_task_rq_fair+0x39b/0x850
>  [<ffffffff8105dcd4>] ? check_preempt_wakeup+0xb4/0x170
>  [<ffffffff8105d014>] ? check_preempt_curr+0x74/0x90
>  [<ffffffff8105d091>] ? ttwu_do_wakeup+0x11/0x90
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> rsyslogd        S ffff88015baa9a30     0 26639      1 0x00000000
>  ffff88015baa9780 0000000000000082 ffff88041fd10380 ffff8801a9002920
>  ffff8801cc7fa000 ffff8801cc7fbfd8 0000000000010380 0000000000004000
>  ffff8801cc7fa000 ffff8801cc7fa010 ffff8801cc7fbfd8 ffff88015baa9780
> Call Trace:
>  [<ffffffff8108adb1>] ? sched_clock_cpu+0x61/0xf0
>  [<ffffffff81064c93>] ? try_to_wake_up+0x1b3/0x260
>  [<ffffffff81095023>] ? wake_futex+0x33/0x70
>  [<ffffffff81097272>] ? do_futex+0x692/0xae0
>  [<ffffffff8106abb9>] ? do_syslog+0x4a9/0x530
>  [<ffffffff81084ed0>] ? wake_up_bit+0x40/0x40
>  [<ffffffff8115a0b0>] ? kmsg_poll+0x40/0x40
>  [<ffffffff8115a0de>] ? kmsg_read+0x2e/0x70
>  [<ffffffff8114fe42>] ? proc_reg_read+0x82/0xd0
>  [<ffffffff810fb8e5>] ? vfs_read+0xc5/0x170
>  [<ffffffff810fba7e>] ? sys_read+0x4e/0x90
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> libvirtd        S ffff880117a25ad0     0 27256      1 0x00000000
>  ffff880117a25820 0000000000000082 ffff88040843e5e0 ffff88040da3af00
>  ffff88019422e000 ffff88019422ffd8 0000000000010380 0000000000004000
>  ffff88019422e000 ffff88019422e010 ffff88019422ffd8 ffff880117a25820
> Call Trace:
>  [<ffffffff811ab362>] ? ext4_ind_map_blocks+0xc2/0x550
>  [<ffffffff812ac2d2>] ? cpumask_next_and+0x22/0x40
>  [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
>  [<ffffffff81094773>] ? get_futex_value_locked+0x23/0x60
>  [<ffffffff81094ccd>] ? futex_wait_queue_me+0xcd/0x110
>  [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
>  [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
>  [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
>  [<ffffffff81077a58>] ? set_current_blocked+0x38/0x60
>  [<ffffffff8112f544>] ? fsnotify+0x1f4/0x320
>  [<ffffffff810d797a>] ? remove_vma+0x4a/0x70
>  [<ffffffff8103b264>] ? fpu_finit+0x14/0x30
>  [<ffffffff8103b2ba>] ? init_fpu+0x3a/0x160
>  [<ffffffff8103be88>] ? restore_i387_xstate+0x148/0x1d0
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> libvirtd        S ffff880132e18e70     0 27258      1 0x00000000
>  ffff880132e18bc0 0000000000000082 0000000000000002 ffff8801f9949d60
>  ffff88011d896000 ffff88011d897fd8 0000000000010380 0000000000004000
>  ffff88011d896000 ffff88011d896010 ffff88011d897fd8 ffff880132e18bc0
> Call Trace:
>  [<ffffffff81094a01>] ? get_futex_key+0x201/0x2b0
>  [<ffffffff81094773>] ? get_futex_value_locked+0x23/0x60
>  [<ffffffff81094ccd>] ? futex_wait_queue_me+0xcd/0x110
>  [<ffffffff81094ee5>] ? futex_wait+0x175/0x240
>  [<ffffffff81095172>] ? futex_wake+0x112/0x130
>  [<ffffffff81096d1c>] ? do_futex+0x13c/0xae0
>  [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
>  [<ffffffff81054675>] ? do_page_fault+0x1a5/0x430
>  [<ffffffff8109773a>] ? sys_futex+0x7a/0x180
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> sshd            S ffff88040daa82b0     0 27668      1 0x00000000
>  ffff88040daa8000 0000000000000086 ffff88002a242c40 ffff880132e1d820
>  ffff8801b548a000 ffff8801b548bfd8 0000000000010380 0000000000004000
>  ffff8801b548a000 ffff8801b548a010 ffff8801b548bfd8 ffff88040daa8000
> Call Trace:
>  [<ffffffff8129b3af>] ? get_request+0x36f/0x3c0
>  [<ffffffff811290c0>] ? __bio_clone+0x20/0x60
>  [<ffffffff815488bd>] ? schedule_hrtimeout_range_clock+0x11d/0x140
>  [<ffffffff810bdc28>] ? get_page_from_freelist+0x2c8/0x5c0
>  [<ffffffff8110c9e4>] ? poll_schedule_timeout+0x44/0x60
>  [<ffffffff8110d9aa>] ? do_select+0x52a/0x670
>  [<ffffffff8110ca90>] ? poll_freewait+0x70/0x70
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8110cba0>] ? __pollwait+0x110/0x110
>  [<ffffffff8147e452>] ? __alloc_skb+0x72/0x160
>  [<ffffffff810be21b>] ? __alloc_pages_nodemask+0x10b/0x7c0
>  [<ffffffff8147fc90>] ? memcpy_fromiovec+0x50/0x70
>  [<ffffffff8147ca04>] ? skb_queue_tail+0x24/0x60
>  [<ffffffff8105e720>] ? __dequeue_entity+0x40/0x50
>  [<ffffffff8105fb03>] ? pick_next_task_fair+0x103/0x190
>  [<ffffffff810638f9>] ? finish_task_switch+0x49/0xd0
>  [<ffffffff815470ad>] ? __schedule+0x2bd/0x8c0
>  [<ffffffff8110dcae>] ? core_sys_select+0x1be/0x300
>  [<ffffffff810fab7f>] ? do_sync_write+0xbf/0x100
>  [<ffffffff81548185>] ? __mutex_lock_slowpath+0x145/0x1a0
>  [<ffffffff810f1bcf>] ? kfree+0xf/0xa0
>  [<ffffffff81103949>] ? __free_pipe_info+0x59/0x70
>  [<ffffffff8110e052>] ? sys_select+0x42/0x120
>  [<ffffffff810f8ebc>] ? filp_close+0x5c/0x90
>  [<ffffffff810f8f9d>] ? sys_close+0xad/0x120
>  [<ffffffff8154a13b>] ? system_call_fastpath+0x16/0x1b
> kmirrord        S ffff880407ffb790     0 32373      2 0x00000000
>  ffff880407ffb4e0 0000000000000046 ffff88041fc10380 ffff88040d913ac0
>  ffff88005acd2000 ffff88005acd3fd8 0000000000010380 0000000000004000
>  ffff88005acd2000 ffff88005acd2010 ffff88005acd3fd8 ffff880407ffb4e0
> Call Trace:
>  [<ffffffff8105e3f6>] ? task_rq_lock+0x56/0xb0
>  [<ffffffff8106281c>] ? set_cpus_allowed_ptr+0x8c/0x120
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kcopyd          S ffff880407fff830     0 32376      2 0x00000000
>  ffff880407fff580 0000000000000046 ffffffff812b22bc ffff8801c25e1780
>  ffff880052cce000 ffff880052ccffd8 0000000000010380 0000000000004000
>  ffff880052cce000 ffff880052cce010 ffff880052ccffd8 ffff880407fff580
> Call Trace:
>  [<ffffffff812b22bc>] ? rb_insert_color+0x10c/0x140
>  [<ffffffff81547501>] ? __schedule+0x711/0x8c0
>  [<ffffffff8105d981>] ? update_curr+0x121/0x130
>  [<ffffffff815477e0>] ? preempt_schedule+0x40/0x60
>  [<ffffffff8105e530>] ? set_user_nice+0xe0/0x180
>  [<ffffffff81080cb5>] ? rescuer_thread+0x2c5/0x2f0
>  [<ffffffff8105c790>] ? __wake_up_common+0x50/0x80
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff810809f0>] ? process_one_work+0x3c0/0x3c0
>  [<ffffffff81084a66>] ? kthread+0x96/0xa0
>  [<ffffffff8154b2f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810849d0>] ? kthread_worker_fn+0x130/0x130
>  [<ffffffff8154b2f0>] ? gs_change+0xb/0xb
> kvm             S ffff880407ffcf10     0  4119      1 0x00000000
>  ffff880407ffcc60 0000000000000082 0000000000000002 ffff8801f9949d60
>  ffff
>
> Br,
> -Mikko Kortelainen
