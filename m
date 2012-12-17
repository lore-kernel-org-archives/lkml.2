Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2LQWgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:36:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2LQWgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:36:08 -0500
Date: Mon, 17 Dec 2012 23:36:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: dri-devel@lists.freedesktop.org
cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: i915: GPU hang
Message-ID: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:gYoTXtCmmO8weoSzgi8UmFXITnrEx/PRgCIAAsVf+bQ
 DVbc9C2IPIwHwdCRM0q6WqgmsMV/wWqLAWsdy+OgN154YVgaZR
 qYzRxnchBXjF3ueK6DZkyrP4iGql0kuFe1paCd5oBsz1OCp2ZD
 hcqtfmtARRTZitA17BYVjX841SvENd5ze7HZKvLVz11lUzavfj
 9YxadvZjkPYtwzeB5y5J8jXchddIXg4CuY5iC6zk74iRVOXEwy
 EsEV39fY65PNz3+aDuBlKBa56SBUnbOPU8OGTkUxNfyubGs5GL
 66R3rZutJK1z49pQ/IOUpO6KK8MVAc8EgjK6hPe6flP8OSSDj4
 sEKYn5mU69jo363P2mrLNZ7/rDSS02wLt7xWGw52VVQ7hyTg+Y
 6spFSX3NKRB9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Sorry, not sure what information is most appropriate here. GPU hangs from 
time to time on this laptop, typically when running firefox on 
graphics-intensive sites. Error log at the bottom. Distro is Debian 6.0.6 
(squeeze), lspci

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 011f
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915

kernel version 3.5.2 (yes, I'll try to upgrade). Sometimes also the 
X-server freezes and restarts with no errors in dmesg. Is it a known 
problem?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[drm:i915_reset] *ERROR* Failed to reset chip.
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:906 intel_enable_pipe+0x16c/0x1c0 [i915]()
Hardware name: Extensa 5220                   
PLL state assertion failure (expected on, current off)
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage tun crypto_blkcipher aes_generic mperf cpufreq_powersave cpufreq_userspace cpufreq_stats i915 drm_kms_helper bnep rfcomm bluetooth crc16 fuse cryptomgr aead arc4 crypto_algapi rt2800usb rt2800lib crc_ccitt rt2x00usb rt2x00lib mac80211 cfg80211 uhci_hcd sg ehci_hcd tg3 sr_mod tifm_7xx1 usbcore cdrom coretemp snd_hda_codec_realtek pcmcia psmouse tifm_core i2c_i801 yenta_socket pcmcia_rsrc snd_hda_intel hwmon libphy snd_hda_codec usb_common pcmcia_core sdhci_pci sdhci mmc_core
Pid: 1780, comm: Xorg Not tainted 3.5.2 #32
Call Trace:
[<c1029958>] ? warn_slowpath_common+0x78/0xb0
[<f83bb4bc>] ? intel_enable_pipe+0x16c/0x1c0 [i915]
[<f83bb4bc>] ? intel_enable_pipe+0x16c/0x1c0 [i915]
[<c1029a23>] ? warn_slowpath_fmt+0x33/0x40
[<f83bb4bc>] ? intel_enable_pipe+0x16c/0x1c0 [i915]
[<f83c0d32>] ? i9xx_crtc_mode_set+0x942/0x1070 [i915]
[<f83bd03b>] ? intel_crtc_mode_set+0x5b/0x90 [i915]
[<f8118cd8>] ? drm_crtc_helper_set_mode+0x358/0x4a0 [drm_kms_helper]
[<f83bf75c>] ? intel_get_load_detect_pipe+0x22c/0x3a0 [i915]
[<c1096bb3>] ? find_get_page+0x63/0xc0
[<c10f572a>] ? __find_get_block+0x9a/0x1e0
[<c10f522a>] ? __find_get_block_slow+0xfa/0x1b0
[<f83d7d9b>] ? intel_tv_detect+0x9b/0x460 [i915]
[<c10f588b>] ? __getblk+0x1b/0x320
[<c1215c01>] ? drm_get_connector_name+0x31/0x50
[<f8119cc8>] ? drm_helper_probe_single_connector_modes+0x258/0x310 [drm_kms_helper]
[<c1215acf>] ? drm_mode_getconnector+0x33f/0x370
[<c1206223>] ? drm_ioctl+0x263/0x4e0
[<c1215790>] ? drm_mode_getencoder+0xb0/0xb0
[<c1205fc0>] ? drm_version+0x90/0x90
[<c10dbecd>] ? do_vfs_ioctl+0x8d/0x600
[<c11032d6>] ? fsnotify+0x196/0x2c0
[<c10e69c0>] ? alloc_fd+0xc0/0x110
[<c10cc8c7>] ? vfs_write+0x107/0x150
[<c10dc47d>] ? sys_ioctl+0x3d/0x70
[<c133c92c>] ? sysenter_do_call+0x12/0x22
---[ end trace 81ff939dea1daea3 ]---
