Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1EKPpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:45:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46613 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1EKPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Hbj3XJuBBBoSpOy+DTr1/uQ8ZOSfg0fPVuRPCmoufthb7kGnRtPTRLK2C6kz6Jv88k
         tLZo5ANicd0hK8s6crx8UpoXqaa2dHlwacW77wTp7gvf44m5nZZxKxIy49A9jfnefSzY
         JXYjX6+k10qNdhp5bWnV8XYwsj141PfMs2eoE=
Message-ID: <4DCA2D14.3040500@suse.cz>
Date: Wed, 11 May 2011 08:30:44 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>, stable@kernel.org
Subject: Re: apparent regression (crash) - 2.6.38.6
References: <4DC9983B.4070006@msgid.tls.msk.ru>
In-Reply-To: <4DC9983B.4070006@msgid.tls.msk.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 09:55 PM, Michael Tokarev wrote:
> Hello.
> 
> I just tried 2.6.38.6 (which has been released today), and
> discovered that it crashes during bootup on my machine.
> 2.6.38.5 with exactly the same config works.

Is it reproducible?

> Unfortunately I don't have time _right now_ to debug the
> issue, but will try tomorrow.
> 
> For now, here's a part of dmesg with an oops, captured
> using netconsole.  If someone have a clue, please speak
> up ;)
> 
> What I also noticed is that for some reason, udev now loads
> option driver (option: v0.7.2:USB Driver for GSM modems),
> even if I don't have any modems connected to the system.
> This is obviously not related to the issue at hand.
...
> [  106.761932] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-2/2-2:1.0/input/input6
> [  106.762170] generic-usb 0003:046D:C044.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.1-2/input0
> [  106.994177] scsi 10:0:0:0: Direct-Access     Kingston DT HyperX        HMAP PQ: 0 ANSI: 0 CCS
> [  106.994458] sd 10:0:0:0: Attached scsi generic sg3 type 0
> [  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> [  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> [  106.994840] PGD 19efc9067 PUD 0
> [  106.994898] Oops: 0000 [#1] SMP
> [  106.994955] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host0/target0:0:0/0:0:0:0/block/sda/removable
> [  106.995082] CPU 1
> [  106.995110] Modules linked in: option snd_hda_codec_hdmi usb_wwan snd_hda_codec_realtek snd_hda_intel snd_hda_codec fbcon font bitblit softcursor snd_hwdep radeon ttm drm_kms_helper snd_pcm snd_seq drm snd_timer agpgart snd_seq_device sg fb fbdev i2c_algo_bit i2c_piix4 i2c_core snd sr_mod processor usbserial thermal_sys cfbcopyarea cfbimgblt cfbfillrect evdev soundcore cdrom k10temp asus_atk0110 psmouse button snd_page_alloc hwmon ehci_hcd usb_storage shpchp uas pci_hotplug wmi netconsole r8169 mii ext4 mbcache jbd2 crc16 configfs pata_atiixp ohci_hcd ahci libahci libata usbhid hid usbcore nls_base sd_mod scsi_mod crc_t10dif
> [  106.996301]
> [  106.996325] Pid: 10, comm: ksoftirqd/1 Not tainted 2.6.38-amd64 #2.6.38.6 System manufacturer System Product Name/M3A78-EM
> [  106.996493] RIP: 0010:[<ffffffff811bec1b>]  [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> [  106.996665] RSP: 0018:ffff8800cfc43de8  EFLAGS: 00010046
> [  106.996740] RAX: 0000000000000000 RBX: ffff88019b8c54d8 RCX: 0000000000000000
> [  106.997674] RDX: ffff88019bb1b380 RSI: 0000000000000000 RDI: ffff88019b8c54d8
> [  107.003475] RBP: ffff88019b8c5850 R08: ffff88019e6b1810 R09: 0000000000000001
> [  107.003475] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  107.003475] R13: ffff88019b8c54d8 R14: ffff88019d63c040 R15: ffff88019e788800
> [  107.003475] FS:  0000000000000000(0000) GS:ffff8800cfc40000(0000) knlGS:00000000f7560720
> [  107.003475] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  107.003475] CR2: 0000000000000048 CR3: 000000019efe2000 CR4: 00000000000006e0
> [  107.003475] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  107.003475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  107.003475] Process ksoftirqd/1 (pid: 10, threadinfo ffff88019fcda000, task ffff88019fc90080)
> [  107.003475] Stack:
> [  107.003475]  ffff88019b8c54d8 ffffffff811c6527 ffff88019b8c54d8 0000000000000296
> [  107.003475]  ffff8800cfc43e58 ffffffff811c675a ffff88019d63c000 ffff88019d63c000
> [  107.003475]  ffff8800cfc43e58 ffffffffa000e1db ffff88019ed729c0 ffffffffa002a500
> [  107.003475] Call Trace:
> [  107.003475]  <IRQ>
> [  107.003475]  [<ffffffff811c6527>] ? __blk_run_queue+0x37/0x190
> [  107.003475]  [<ffffffff811c675a>] ? blk_run_queue+0x2a/0x50
> [  107.003475]  [<ffffffffa000e1db>] ? scsi_run_queue+0xeb/0x370 [scsi_mod]
> [  107.003475]  [<ffffffffa000f39b>] ? scsi_next_command+0x3b/0x60 [scsi_mod]
> [  107.003475]  [<ffffffffa001013f>] ? scsi_io_completion+0x34f/0x570 [scsi_mod]
> [  107.003475]  [<ffffffff811cafc5>] ? blk_done_softirq+0x75/0x90
> [  107.003475]  [<ffffffff81052f1d>] ? __do_softirq+0x9d/0x1d0
> [  107.003475]  [<ffffffff8100349c>] ? call_softirq+0x1c/0x30
> [  107.003475]  <EOI>
> [  107.003475]  [<ffffffff81005535>] ? do_softirq+0x65/0xa0
> [  107.003475]  [<ffffffff81052b27>] ? run_ksoftirqd+0x87/0x150
> [  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
> [  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
> [  107.003475]  [<ffffffff8106bf06>] ? kthread+0x96/0xa0
> [  107.003475]  [<ffffffff810033a4>] ? kernel_thread_helper+0x4/0x10
> [  107.003475]  [<ffffffff8106be70>] ? kthread+0x0/0xa0
> [  107.003475]  [<ffffffff810033a0>] ? kernel_thread_helper+0x0/0x10
> [  107.003475] Code: 48 83 c4 08 c3 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 31 c0 48 3b 3f 48 8b 57 18 74 09 48 83 c4 08 c3 0f 1f 40 00 48 8b 02 <48> 8b 50 48 b8 01 00 00 00 48 85 d2 74 e6 48 83 c4 08 ff e2 90
> [  107.003475] RIP  [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> [  107.003475]  RSP <ffff8800cfc43de8>
> [  107.003475] CR2: 0000000000000048
> [  107.003475] ---[ end trace 9fcac9eeba5b3f54 ]---
> [  107.003475] Kernel panic - not syncing: Fatal exception in interrupt
> [  107.003475] Pid: 10, comm: ksoftirqd/1 Tainted: G      D     2.6.38-amd64 #2.6.38.6
> [  107.003475] Call Trace:
> [  107.003475]  <IRQ>  [<ffffffff81340bb9>] ? panic+0x92/0x1a0
> [  107.003475]  [<ffffffff8104c482>] ? kmsg_dump+0x42/0x100
> [  107.003475]  [<ffffffff81006823>] ? oops_end+0xa3/0xb0
> [  107.003475]  [<ffffffff8102c9b3>] ? no_context+0x103/0x270
> [  107.003475]  [<ffffffff8102d1b9>] ? do_page_fault+0x289/0x430
> [  107.003475]  [<ffffffff81036804>] ? check_preempt_curr+0x74/0x90
> [  107.003475]  [<ffffffff81045275>] ? try_to_wake_up+0xc5/0x430
> [  107.003475]  [<ffffffff81343f25>] ? page_fault+0x25/0x30
> [  107.003475]  [<ffffffff811bec1b>] ? elv_queue_empty+0x1b/0x30
> [  107.003475]  [<ffffffff811c6527>] ? __blk_run_queue+0x37/0x190
> [  107.003475]  [<ffffffff811c675a>] ? blk_run_queue+0x2a/0x50
> [  107.003475]  [<ffffffffa000e1db>] ? scsi_run_queue+0xeb/0x370 [scsi_mod]
> [  107.003475]  [<ffffffffa000f39b>] ? scsi_next_command+0x3b/0x60 [scsi_mod]
> [  107.003475]  [<ffffffffa001013f>] ? scsi_io_completion+0x34f/0x570 [scsi_mod]
> [  107.003475]  [<ffffffff811cafc5>] ? blk_done_softirq+0x75/0x90

There are only few changes in the scsi layer:
$ git log --color v2.6.38.5..v2.6.38.6 -- drivers/scsi/|git shortlog
Dan Rosenberg (2):
      pmcraid: reject negative request size
      mpt2sas: prevent heap overflows and unchecked reads

James Bottomley (2):
      put stricter guards on queue dead checks
      fix oops in scsi_run_queue()

Mike Snitzer (1):
      scsi_dh: fix reference counting in scsi_dh_activate error path

regards,
-- 
js
suse labs
