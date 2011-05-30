Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab1E3Scs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:32:48 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:53470 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1E3Scr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:32:47 -0400
X-ASG-Debug-ID: 1306780365-01de280c1e0c0b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE3E2C9.6060207@fusionio.com>
Date: Mon, 30 May 2011 20:32:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: <airlied@redhat.com>, <keithp@keithp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: WARNING: at drivers/gpu/drm/i915/i915_drv.c:344 gen6_gt_force_wake_put+0x58/0x60()
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: WARNING: at drivers/gpu/drm/i915/i915_drv.c:344 gen6_gt_force_wake_put+0x58/0x60()
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306780365
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65126
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using 3.0-rc1 I get a ton of the above. It was introduced over the last 2-3 days
or so, at least the early 2.6.39+ did not generate them (I think, I could have
missed it...)

[  136.845854] WARNING: at drivers/gpu/drm/i915/i915_drv.c:344 gen6_gt_force_wake_put+0x58/0x60()
[  136.845855] Hardware name: MacBookPro8,2
[  136.845855] Modules linked in: fuse aes_generic binfmt_misc nbd nls_iso8859_1 nls_cp437 vfat fat hid_apple btusb uvcvideo bluetooth usbhid videodev hid bcm5974 v4l2_compat_ioctl32 joydev snd_hda_codec_cirrus arc4 brcmsmac(C) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm brcmutil(C) mac80211 sr_mod snd_seq_midi snd_rawmidi cdrom snd_seq_midi_event snd_seq cfg80211 snd_timer snd_seq_device tg3 firewire_ohci snd applesmc firewire_core input_polldev sdhci_pci sdhci ehci_hcd crc_itu_t soundcore crc_ccitt uhci_hcd snd_page_alloc apple_bl
[  136.845872] Pid: 2322, comm: kworker/u:20 Tainted: G        WC  3.0.0-rc1+ #212
[  136.845874] Call Trace:
[  136.845876]  [<ffffffff8104c90f>] warn_slowpath_common+0x7f/0xc0
[  136.845878]  [<ffffffff8104c96a>] warn_slowpath_null+0x1a/0x20
[  136.845880]  [<ffffffff81303c68>] gen6_gt_force_wake_put+0x58/0x60
[  136.845882]  [<ffffffff8131b38e>] i915_restore_display+0xa0e/0x1d80
[  136.845885]  [<ffffffff8131d138>] i915_restore_state+0x78/0x870
[  136.845887]  [<ffffffff812e2c8b>] ? intel_gtt_chipset_flush+0x1b/0x20
[  136.845890]  [<ffffffff81327665>] ? i915_gem_restore_gtt_mappings+0x135/0x150
[  136.845892]  [<ffffffff810766b0>] ? async_schedule+0x20/0x20
[  136.845894]  [<ffffffff813036d6>] i915_drm_thaw+0x46/0x110
[  136.845897]  [<ffffffff813039ee>] i915_resume+0x4e/0x80
[  136.845899]  [<ffffffff81303a36>] i915_pm_resume+0x16/0x20
[  136.845901]  [<ffffffff81254e26>] pci_pm_resume+0x76/0xd0
[  136.845903]  [<ffffffff81369ed7>] pm_op+0xe7/0x1c0
[  136.845905]  [<ffffffff8136a287>] device_resume+0x57/0x100
[  136.845906]  [<ffffffff8136a351>] async_resume+0x21/0x50
[  136.845908]  [<ffffffff8107672f>] async_run_entry_fn+0x7f/0x180
[  136.845910]  [<ffffffff8106939a>] process_one_work+0x11a/0x480
[  136.845913]  [<ffffffff8106a10f>] worker_thread+0x15f/0x360
[  136.845915]  [<ffffffff81069fb0>] ? manage_workers.isra.29+0x230/0x230
[  136.845917]  [<ffffffff8106e48c>] kthread+0x8c/0xa0
[  136.845919]  [<ffffffff814f1da4>] kernel_thread_helper+0x4/0x10
[  136.845921]  [<ffffffff8106e400>] ? flush_kthread_worker+0xa0/0xa0
[  136.845923]  [<ffffffff814f1da0>] ? gs_change+0x13/0x13

-- 
Jens Axboe

