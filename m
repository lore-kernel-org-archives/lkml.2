Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1D0GiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:38:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45143 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1D0GiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VFN1yTuS88/0GRDLUGhxWZf5bv+xbZrmfsCcawg6gxuvcX1p/1QN7HAxr6LF1HFivB
         ha86emb2el8/wscP7Y+19FICCXd4ieKjl4cKIEFTBdooPPZE6IUElX/EMy3K1zmvphZt
         ujX9vjuEpFKvFrJ8XyfeIht5PCE7+Bnf6H1o0=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UG0Xy2UEkNj2S_bS-PjOG5krNkQ@mail.gmail.com>
References: <BANLkTi=UG0Xy2UEkNj2S_bS-PjOG5krNkQ@mail.gmail.com>
Date: Wed, 27 Apr 2011 14:38:01 +0800
Message-ID: <BANLkTi=8OyYiMdz8Fmih2L=U+yj3S_-CRw@mail.gmail.com>
Subject: Re: kernel panic after unplug usb bluetooth dongle
From: Dave Young <hidave.darkstar@gmail.com>
To: Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 2:35 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
>
> Unplug usb bluetooth dongle make kernel panic as below. Thomas, any
> idea about it?

BTW, addr2line -e vmlinux 0xffffffff81048988 show:
kernel/timer.c:1183:
list_for_each_entry(nte, varp->vec + slot, entry) {

>
> usb 6-1: USB disconnect, device number 3
> btusb_intr_complete: hci0 urb ffff8801275bb9c0 failed to resubmit (19)
> btusb_bulk_complete: hci0 urb ffff8801275bb540 failed to resubmit (19)
> btusb_bulk_complete: hci0 urb ffff8801275bb6c0 failed to resubmit (19)
> btusb_send_frame: hci0 urb ffff8801275bb6c0 submission failed
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81048988>] get_next_timer_interrupt+0x13d/0x21d
> PGD 12609c067 PUD 1260b5067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/dmi/id/chassis_type
> CPU 0
> Modules linked in: tun rfcomm bnep snd_pcm_oss snd_mixer_oss kvm_intel
> kvm btusb bluetooth snd_hda_codec_analog snd_hda_intel dell_wmi
> sparse_keymap snd_hda_codec snd_hwdep e1000e snd_pcm wmi snd_timer
> 8139too rfkill snd_page_alloc
>
> Pid: 0, comm: swapper Not tainted 2.6.39-rc5 #224 Dell Inc. OptiPlex
> 780                 /0V4W66
> RIP: 0010:[<ffffffff81048988>]  [<ffffffff81048988>]
> get_next_timer_interrupt+0x13d/0x21d
> RSP: 0018:ffffffff817dddf8  EFLAGS: 00010097
> RAX: 0000000000000000 RBX: ffffffff819adb80 RCX: 000000000000003e
> RDX: 0000000000000000 RSI: 000000000000003e RDI: 0000000000000000
> RBP: ffffffff817dde58 R08: ffffffff817dde08 R09: 00000000010000fe
> R10: 0000000000000000 R11: 0000000000000001 R12: 000000010000fdf7
> R13: ffffffff819aefb0 R14: ffffffff819aebd0 R15: 0000000000000040
> FS:  0000000000000000(0000) GS:ffff880127c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000012605a000 CR4: 00000000000406b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff817dc000, task ffffffff81800020)
> Stack:
>  ffffffff817dde28 ffffffff8105c769 ffffffff819aebd0 ffffffff819aefd0
>  ffffffff819af3d0 ffffffff819af7d0 ffffffff817dde48 000000000000ccc0
>  ffff880127c0e2a0 00000000a983c6e8 0000000000000000 000000010000fdf7
> Call Trace:
>  [<ffffffff8105c769>] ? sched_clock_local+0x1c/0x80
>  [<ffffffff810652c4>] tick_nohz_stop_sched_tick+0x370/0x390
>  [<ffffffff81001e77>] cpu_idle+0x2f/0x9a
>  [<ffffffff814fd409>] rest_init+0xad/0xb1
>  [<ffffffff814fd35c>] ? csum_partial_copy_generic+0x16c/0x16c
>  [<ffffffff818b0c49>] start_kernel+0x399/0x3a4
>  [<ffffffff818b0140>] ? early_idt_handlers+0x140/0x140
>  [<ffffffff818b02af>] x86_64_start_reservations+0xb6/0xba
>  [<ffffffff818b03b3>] x86_64_start_kernel+0x100/0x10f
> Code: 04 4a 8b 14 30 4d 8d 2c 06 eb 20 4c 89 d0 f6 42 18 01 75 11 48
> 8b 42 10 41 bb 01 00 00 00 4c 39 d0 49 0f 49 c2 48 89 fa 49 89 c2
>  8b 3a 4c 39 ea 0f 18 0f 75 d5 45 85 db 74 10 85 f6 74 04 39
> RIP  [<ffffffff81048988>] get_next_timer_interrupt+0x13d/0x21d
>  RSP <ffffffff817dddf8>
> CR2: 0000000000000000
> ---[ end trace 5621bb82abfeb30f ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> Pid: 0, comm: swapper Tainted: G      D     2.6.39-rc5 #224
> Call Trace:
>  [<ffffffff8151a544>] panic+0xb7/0x1c9
>  [<ffffffff8103ef48>] do_exit+0xb6/0x7b3
>  [<ffffffff8103bd25>] ? kmsg_dump+0x120/0x12f
>  [<ffffffff8103bc96>] ? kmsg_dump+0x91/0x12f
>  [<ffffffff8151e23f>] oops_end+0xc1/0xc9
>  [<ffffffff810228c3>] no_context+0x1f3/0x202
>  [<ffffffff81022a8d>] __bad_area_nosemaphore+0x1bb/0x1e1
>  [<ffffffff810685c8>] ? mark_lock+0x22/0x261
>  [<ffffffff8106a49c>] ? __lock_acquire+0xe05/0xe14
>  [<ffffffff81022ac1>] bad_area_nosemaphore+0xe/0x10
>  [<ffffffff815202a3>] do_page_fault+0x20b/0x421
>  [<ffffffff8106a49c>] ? __lock_acquire+0xe05/0xe14
>  [<ffffffff8106a49c>] ? __lock_acquire+0xe05/0xe14
>  [<ffffffff8151d020>] ? _raw_spin_unlock_irq+0x2b/0x37
>  [<ffffffff812816fd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8151d5e5>] page_fault+0x25/0x30
>  [<ffffffff81048988>] ? get_next_timer_interrupt+0x13d/0x21d
>  [<ffffffff81048894>] ? get_next_timer_interrupt+0x49/0x21d
>  [<ffffffff8105c769>] ? sched_clock_local+0x1c/0x80
>  [<ffffffff810652c4>] tick_nohz_stop_sched_tick+0x370/0x390
>  [<ffffffff81001e77>] cpu_idle+0x2f/0x9a
>  [<ffffffff814fd409>] rest_init+0xad/0xb1
>  [<ffffffff814fd35c>] ? csum_partial_copy_generic+0x16c/0x16c
>  [<ffffffff818b0c49>] start_kernel+0x399/0x3a4
>  [<ffffffff818b0140>] ? early_idt_handlers+0x140/0x140
>  [<ffffffff818b02af>] x86_64_start_reservations+0xb6/0xba
>  [<ffffffff818b03b3>] x86_64_start_kernel+0x100/0x10f
>
> --
> Regards
> dave
>



-- 
Regards
dave
