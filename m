Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1AMNZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:25:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35671 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1AMNZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GiPamsmF+PJL1AmYRtIWQJPy9L1vAQzaCOmB02dhuUBf4yXv9fosXCmJCnpLhjTmsU
         JY1ZykQvO4W6k36EKdzDTyqD5dmsuJwONmKYspb1ik/c70xd8fmM/AAReijlnlaPdCUQ
         HetAYmCRzONpvcv14Y7w1A/3SJZ29jtSjUQ8s=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
Date: Thu, 13 Jan 2011 14:23:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-wl-default+; KDE/4.5.5; x86_64; ; )
Cc: Ingo Brunberg <ingo_brunberg@web.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <m31v4hkmkf.fsf@ingo.homenetwork>
In-Reply-To: <m31v4hkmkf.fsf@ingo.homenetwork>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101131423.51640.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Donnerstag, 13. Januar 2011 schrieb Ingo Brunberg:
> I also suffer from this bug with 2.6.37. The first time the following
> trace made it into my logs. Hopefully it might help.

Thanks for the trace!

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> IP: [<ffffffffa00983e4>] rt2x00lib_txdone+0x31/0x259 [rt2x00lib]
> PGD a7011067 PUD ab9b2067 PMD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3.4/2-3.4:1.0/firmware/2-3.4:1.0/loading
> CPU 3 
> Modules linked in: aes_generic af_packet w83627ehf hwmon_vid ipv6 fbcon font bitblit softcursor dm_mod arc4 ecb crypto_blkcipher cryptomgr aead crypto_algapi rt73usb rt2x00usb rt2x00lib mac80211 cfg80211 usbhid hid radeon snd_hda_codec_realtek ttm r8169 drm_kms_helper sr_mod drm cdrom firewire_ohci snd_hda_intel i2c_piix4 bitrev 8250_pnp processor snd_hda_codec ohci_hcd thermal_sys ehci_hcd usbcore crc32 8250 i2c_algo_bit firewire_core i2c_core sg pata_atiixp crc_itu_t rtc button k10temp evdev hwmon snd_pcm snd_timer cfbcopyarea cfbimgblt snd floppy cfbfillrect serial_core mii nls_base soundcore snd_page_alloc
> 
> Pid: 3069, comm: kworker/3:0 Not tainted 2.6.37 #1 M3A785GXH/128M/To Be Filled By O.E.M.
> RIP: 0010:[<ffffffffa00983e4>]  [<ffffffffa00983e4>] rt2x00lib_txdone+0x31/0x259 [rt2x00lib]
> RSP: 0018:ffff880094ad3d30  EFLAGS: 00010286
> RAX: 0000000000000030 RBX: ffff88011df79980 RCX: 0000000000000014
> RDX: 0000000000000101 RSI: ffff880094ad3d90 RDI: 0000000000000000
> RBP: ffff88011ec37af8 R08: 0000000000000002 R09: ffffffff00000002
> R10: 0000000000000286 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000028 R14: ffff880094ad3d90 R15: ffff88011df79c10
> FS:  00007fc5bad23710(0000) GS:ffff8800cfd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000090 CR3: 00000000ab985000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/3:0 (pid: 3069, threadinfo ffff880094ad2000, task ffff88011ff08b20)
> Stack:
> ffff88011fc7e420 0000000000011000 0000000000000030 0000000000004000
> ffff88011ec37af8 ffff88011dcb3af0 ffff88011df79980 ffff88011dcb3b40
> ffff88011dcb3b40 0000000000000003 ffff88011df79c10 ffffffffa009862e
> Call Trace:
> [<ffffffffa009862e>] ? rt2x00lib_txdone_noinfo+0x22/0x27 [rt2x00lib]
> [<ffffffffa0016316>] ? rt2x00usb_work_txdone+0x3e/0x6d [rt2x00usb]
> [<ffffffffa0016a0d>] ? rt2x00usb_watchdog+0x69/0xe0 [rt2x00usb]
> [<ffffffffa009aed9>] ? rt2x00link_watchdog+0x0/0x4a [rt2x00lib]
> [<ffffffffa009af00>] ? rt2x00link_watchdog+0x27/0x4a [rt2x00lib]
> [<ffffffff8104256e>] ? process_one_work+0x20e/0x34e
> [<ffffffff81042a45>] ? worker_thread+0x1c9/0x340
> [<ffffffff8102612e>] ? __wake_up_common+0x41/0x78
> [<ffffffff8104287c>] ? worker_thread+0x0/0x340
> [<ffffffff8104287c>] ? worker_thread+0x0/0x340
> [<ffffffff810455a9>] ? kthread+0x7a/0x82
> [<ffffffff81002cd4>] ? kernel_thread_helper+0x4/0x10
> [<ffffffff8104552f>] ? kthread+0x0/0x82
> [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10
> Code: f6 41 55 41 54 55 48 89 fd 53 48 83 ec 28 4c 8b 67 10 48 8b 47 08 48 8b 18 49 8d 44 24 30 4c 89 e7 4d 8d 6c 24 28 48 89 44 24 10 <41> 8b 94 24 90 00 00 00 66 89 54 24 1e e8 1b 16 14 00 48 89 ef 
> RIP  [<ffffffffa00983e4>] rt2x00lib_txdone+0x31/0x259 [rt2x00lib]
> RSP <ffff880094ad3d30>
> CR2: 0000000000000090
> ---[ end trace 2c6843a38ee68ff0 ]---

Just a shot in the dark but since the stack trace shows the newly added
watchdog this might be the result of a race between a regular txdone work
(mac80211 workqueue) vs the watchdog work (global workqueue).

I guess the following situation could happen:
A regular tx done work calls rt2x00lib_txdone which first sets entry->skb to
NULL, calls the driver specific clear_entry and afterwards increases
Q_INDEX_DONE. If the watchdog work calls rt2x00lib_txdone on a different CPU
inbetween the skb might be NULL and cause the above oops.

Ivo, does that sound reasonable?

Helmut
