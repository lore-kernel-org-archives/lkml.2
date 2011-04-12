Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1DLTJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:09:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54516 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1DLTJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:09:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 12 Apr 2011 21:09:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: kernel 2.6.39-rc3 drm, radeon: device driver tries to free DMA
 memory it has not allocated
Message-ID: <20110412210940.0b3d598b@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just switched from 2.6.38-rc7 to 2.6.39-rc3 and got this at some point
during userland startup:

WARNING: at lib/dma-debug.c:803 check_unmap+0x19a/0x696()
Hardware name: System Product Name
NULL NULL: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x00000000ce47b000] [size=4096 bytes]
Modules linked in: cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Pid: 4397, comm: X Tainted: G        W   2.6.39-rc3 #2
Call Trace:
 [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
 [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8134606d>] ? _raw_spin_lock_irqsave+0x49/0x53
 [<ffffffff811474e5>] ? check_unmap+0x102/0x696
 [<ffffffff8114757d>] check_unmap+0x19a/0x696
 [<ffffffff81021810>] ? __change_page_attr_set_clr+0x16d/0x99d
 [<ffffffff81147ae5>] debug_dma_free_coherent+0x6c/0x7a
 [<ffffffff811ccb00>] ttm_put_pages+0x117/0x255
 [<ffffffff811c62cb>] ttm_tt_free_alloced_pages+0xbc/0xe2
 [<ffffffff811c6695>] ttm_tt_destroy+0x50/0xda
 [<ffffffff811c6f27>] ttm_bo_cleanup_memtype_use+0x29/0x63
 [<ffffffff811c96aa>] ttm_bo_release+0x112/0x1df
 [<ffffffff811c9598>] ? ttm_bo_create+0xff/0xff
 [<ffffffff81139882>] kref_put+0x43/0x4d
 [<ffffffff811c7748>] ttm_bo_unref+0x33/0x40
 [<ffffffff811f6f66>] radeon_bo_unref+0x3f/0x5e
 [<ffffffff811b58f2>] ? drm_gem_handle_delete+0x89/0xab
 [<ffffffff811b5779>] ? drm_gem_object_release_handle+0x5a/0x5a
 [<ffffffff8120985a>] radeon_gem_object_free+0x1e/0x20
 [<ffffffff811b57a1>] drm_gem_object_free+0x28/0x2a
 [<ffffffff81139882>] kref_put+0x43/0x4d
 [<ffffffff811b5901>] drm_gem_handle_delete+0x98/0xab
 [<ffffffff811b5937>] drm_gem_close_ioctl+0x23/0x25
 [<ffffffff811b4106>] drm_ioctl+0x277/0x343
 [<ffffffff811b5914>] ? drm_gem_handle_delete+0xab/0xab
 [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
 [<ffffffff81058895>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810b5e8b>] do_vfs_ioctl+0x464/0x4b3
 [<ffffffff810953bd>] ? remove_vma+0x69/0x71
 [<ffffffff810b5f1c>] sys_ioctl+0x42/0x65
 [<ffffffff813472bb>] system_call_fastpath+0x16/0x1b
---[ end trace 6a2f7052e2c76f52 ]---
DMA-API: debugging out of memory - disabling

This is an AMD RS780/ ATI Radeon HD 3200 system with Gentoo xorg-server
1.9.4 and xf86-video-ati 6.14.1.
-- 
Stefan Richter
-=====-==-== -=-- -==--
http://arcgraph.de/sr/
