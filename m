Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1EZCA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:00:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40575 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab1EZCAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=yDAFd7zuWp5hUcNnTh5nJuSxiuPrq2wctT3vu4U41Ndk4L6AKlIs/psMPBF2OtXv7k
         WXC9xLHrM/CvHA2Y46JenUyxehf45AfiF91uI2+axcxkASMpDRSnFvQX94IPR2xOIM3D
         0a2h0LQuuzPAm6g6OP26Yjlf+KYGun9AHzwXU=
Date: Wed, 25 May 2011 22:00:21 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: linux-kernel@vger.kernel.org
cc: tiwai@suse.de, alsa-devel@alsa-project.org
Subject: hda_intel remove_proc_entry: removing non-empty directory 'irq/42',
 leaking at least 'smp_affinity_list'
Message-ID: <alpine.DEB.2.02.1105252151140.2539@ubuntu-natty>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got the below warning on suspend -

[  118.608869] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[  118.608903] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[  118.805635] ------------[ cut here ]------------
[  118.805647] WARNING: at fs/proc/generic.c:849 remove_proc_entry+0x26e/0x280()
[  118.805650] Hardware name: 0876                            
[  118.805654] remove_proc_entry: removing non-empty directory 'irq/42', leaking at least 'smp_affinity_list'
[  118.805657] Modules linked in: cryptd aes_x86_64 aes_generic parport_pc ppdev nls_utf8 udf crc_itu_t fuse binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek i915 snd_hda_intel snd_hda_codec arc4 drm_kms_helper drm snd_hwdep i2c_algo_bit iwlagn snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq cfbcopyarea cfbimgblt snd_timer cfbfillrect mac80211 snd_seq_device snd uvcvideo usb_storage soundcore cfg80211 videodev ideapad_laptop v4l2_compat_ioctl32 psmouse video snd_page_alloc serio_raw intel_ips sparse_keymap btusb mac_hid lp bluetooth parport ext4 mbcache jbd2 ahci libahci libata atl1c
[  118.805719] Pid: 182, comm: kworker/u:6 Tainted: G        W   2.6.39+ #11
[  118.805727] Call Trace:
[  118.805738]  [<ffffffff8105875f>] warn_slowpath_common+0x7f/0xc0
[  118.805744]  [<ffffffff81058856>] warn_slowpath_fmt+0x46/0x50
[  118.805748]  [<ffffffff8119f84e>] remove_proc_entry+0x26e/0x280
[  118.805756]  [<ffffffff811f59e0>] ? sprintf+0x40/0x50
[  118.805763]  [<ffffffff810b7db7>] unregister_irq_proc+0xb7/0xe0
[  118.805767]  [<ffffffff810b3a4c>] free_desc+0x2c/0x70
[  118.805771]  [<ffffffff810b3ada>] irq_free_descs+0x4a/0x90
[  118.805778]  [<ffffffff81029c9b>] free_irq_at+0x3b/0x50
[  118.805783]  [<ffffffff8102bc7b>] destroy_irq+0x7b/0x90
[  118.805789]  [<ffffffff8102bf0e>] native_teardown_msi_irq+0xe/0x10
[  118.805796]  [<ffffffff8122282f>] default_teardown_msi_irqs+0x6f/0x90
[  118.805801]  [<ffffffff81222216>] free_msi_irqs+0x96/0x130
[  118.805806]  [<ffffffff81222ec5>] pci_disable_msi+0x45/0x50
[  118.805813]  [<ffffffffa03372cb>] azx_suspend+0xab/0x100 [snd_hda_intel]
[  118.805820]  [<ffffffff8120fcd6>] pci_legacy_suspend+0x46/0xe0
[  118.805825]  [<ffffffff81210b45>] pci_pm_suspend+0xd5/0x120
[  118.805832]  [<ffffffff812c5889>] pm_op+0x1b9/0x220
[  118.805838]  [<ffffffff810825e0>] ? async_schedule+0x20/0x20
[  118.805842]  [<ffffffff812c5a10>] __device_suspend+0x90/0x150
[  118.805847]  [<ffffffff812c5af1>] async_suspend+0x21/0x60
[  118.805851]  [<ffffffff81082664>] async_run_entry_fn+0x84/0x180
[  118.805857]  [<ffffffff81074912>] process_one_work+0x122/0x430
[  118.805862]  [<ffffffff81075402>] worker_thread+0x162/0x360
[  118.805866]  [<ffffffff810752a0>] ? manage_workers.clone.21+0x250/0x250
[  118.805871]  [<ffffffff8107a406>] kthread+0x96/0xa0
[  118.805877]  [<ffffffff81488a24>] kernel_thread_helper+0x4/0x10
[  118.805883]  [<ffffffff8147fe01>] ? retint_restore_args+0x13/0x13
[  118.805888]  [<ffffffff8107a370>] ? flush_kthread_worker+0xb0/0xb0
[  118.805892]  [<ffffffff81488a20>] ? gs_change+0x13/0x13
[  118.805895] ---[ end trace e0ec9dc53f93f46f ]---
[  118.805908] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  118.818709] HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
