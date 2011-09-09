Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1IIXXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:23:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab1IIXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:23:02 -0400
Date: Fri, 9 Sep 2011 16:22:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anders <aeriksson2@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-kernel@vger.kernel.org,
        "lirc-list@lists.sourceforge.net" <lirc-list@lists.sourceforge.net>,
        linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: 3.0.1. imon locking issues?
Message-Id: <20110909162245.c1f85760.akpm@linux-foundation.org>
In-Reply-To: <4E63CB51.7030907@gmail.com>
References: <4E63CB51.7030907@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Sun, 04 Sep 2011 21:02:41 +0200
Anders <aeriksson2@gmail.com> wrote:

> Found this oops produced by kdump here. It seems imon related.
> 
>
> ...
>
> <4>[  278.893189] Restarting tasks ... done.
> <6>[  278.994452] usb 5-1: USB disconnect, device number 2
> <3>[  278.995191] imon:send_packet: error submitting urb(-19)
> <3>[  279.000016] imon:vfd_write: send packet failed for packet #3
> <3>[  279.000028] imon:vfd_write: no iMON device present
> <3>[  279.000032] imon:vfd_write: no iMON device present
> <3>[  279.000036] imon:vfd_write: no iMON device present
> <3>[  279.000040] imon:vfd_write: no iMON device present
> <3>[  279.000044] imon:vfd_write: no iMON device present
> <3>[  279.000048] imon:vfd_write: no iMON device present
> <3>[  279.000053] imon:vfd_write: no iMON device present
> <3>[  279.000057] imon:vfd_write: no iMON device present
> <3>[  279.000061] imon:vfd_write: no iMON device present
> <3>[  279.000065] imon:vfd_write: no iMON device present
> <3>[  279.000069] imon:vfd_write: no iMON device present
> <3>[  279.000073] imon:vfd_write: no iMON device present
> <3>[  279.000077] imon:vfd_write: no iMON device present
> <3>[  279.000081] imon:vfd_write: no iMON device present
> <3>[  279.000085] imon:vfd_write: no iMON device present
> <0>[  279.042361] stack segment: 0000 [#1] PREEMPT SMP
> <4>[  279.042450] CPU 1
> <4>[  279.042482] Modules linked in: saa7134_alsa tda1004x saa7134_dvb
> videobuf_dvb dvb_core ir_kbd_i2c tda827x ir_lirc_codec lirc_dev tda8290
> ir_sony_decoder tuner ir_jvc_decoder snd_hda_codec_realtek
> ir_rc6_decoder saa7134 videobuf_dma_sg videobuf_core v4l2_common
> rc_imon_mce imon ir_rc5_decoder ir_nec_decoder rc_core videodev
> snd_hda_intel parport_pc snd_hda_codec v4l2_compat_ioctl32 parport
> tveeprom snd_hwdep i2c_piix4 sg pcspkr rtc_cmos atiixp asus_atk0110
> <4>[  279.043219]
> <4>[  279.043242] Pid: 1922, comm: LCDd Not tainted 3.0.1-dirty #24
> System manufacturer System Product Name/M2A-VM HDMI
> <4>[  279.043318] RIP: 0010:[<ffffffff810231bb>]  [<ffffffff810231bb>]
> mutex_spin_on_owner+0x3e/0x63
> <4>[  279.043318] RSP: 0018:ffff88004a1c3e00  EFLAGS: 00010246
> <4>[  279.043318] RAX: ffff880074118cf0 RBX: ffff8800725d0020 RCX:
> 0000000000000000
> <4>[  279.043318] RDX: ffff8800725d0038 RSI: 65766f6d65723d4e RDI:
> ffff8800725d0020
> <4>[  279.043318] RBP: 65766f6d65723d4e R08: 0000000000000000 R09:
> ffff88007308fe40
> <4>[  279.043318] R10: 0000000000000001 R11: 0000000000000246 R12:
> 0000000000000000
> <4>[  279.043318] R13: ffff88004a1c2010 R14: ffff88004a1c2010 R15:
> 0000000000000001
> <4>[  279.043318] FS:  00007f9c84ed5700(0000) GS:ffff880077c80000(0000)
> knlGS:0000000000000000
> <4>[  279.043318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[  279.043318] CR2: 00007eff71e392a0 CR3: 00000000730f9000 CR4:
> 00000000000006e0
> <4>[  279.043318] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> <4>[  279.043318] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> <4>[  279.043318] Process LCDd (pid: 1922, threadinfo ffff88004a1c2000,
> task ffff880074118cf0)
> <0>[  279.043318] Stack:
> <4>[  279.043318]  0000000000000286 ffff8800725d0020 ffff880074118cf0
> 65766f6d65723d4e
> <4>[  279.043318]  0000000000000000 ffffffff814c14dc 0000000000000000
> ffff8800725d0038
> <4>[  279.043318]  ffffffff81048211 ffff88004a1c3ed8 0000000000000286
> ffff880074118cf0
> <0>[  279.043318] Call Trace:
> <4>[  279.043318]  [<ffffffff814c14dc>] ? __mutex_lock_slowpath+0x57/0x17f
> <4>[  279.043318]  [<ffffffff81048211>] ? lock_hrtimer_base+0x1b/0x3c
> <4>[  279.043318]  [<ffffffff810482d1>] ? hrtimer_try_to_cancel+0x63/0x6c
> <4>[  279.043318]  [<ffffffff814c1404>] ? mutex_lock+0x12/0x22
> <4>[  279.043318]  [<ffffffff814c1a8a>] ? do_nanosleep+0x77/0xb0
> <4>[  279.043318]  [<ffffffffa0100805>] ? vfd_write+0x63/0x1bd [imon]
> <4>[  279.043318]  [<ffffffff8104877d>] ? hrtimer_nanosleep+0x9c/0x108
> <4>[  279.043318]  [<ffffffff810b22cb>] ? vfs_write+0xad/0x12e
> <4>[  279.043318]  [<ffffffff810b2402>] ? sys_write+0x45/0x6e
> <4>[  279.043318]  [<ffffffff814c317b>] ? system_call_fastpath+0x16/0x1b
> <0>[  279.043318] Code: 00 55 48 89 f5 53 48 89 fb 48 83 ec 08 eb 0e 49
> 8b 45 00 a8 08 74 04 31 c0 eb 2c f3 90 e8 02 38 05 00 45 31 e4 48 39 6b
> 18 75 08
> <83>[  279.043318]  7d 28 00 41 0f 95 c4 e8 60 48 05 00 45 84 e4 75 d2
> 31 c0 48
> <1>[  279.043318] RIP  [<ffffffff810231bb>] mutex_spin_on_owner+0x3e/0x63
> <4>[  279.043318]  RSP <ffff88004a1c3e00>

Yes, vfd_write() appears to have got all confused and passed a garbage
pointer into mutex_lock().

