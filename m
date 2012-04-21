Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DUNCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:02:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54060 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2DUNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:02:08 -0400
Date: Sat, 21 Apr 2012 15:03:07 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Regression][3.4-rc3][intel-dri] MMIO read or write has been
 dropped ffffffff
Message-ID: <20120421130307.GB5019@phenom.ffwll.local>
Mail-Followup-To: Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <201204210739.08963.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204210739.08963.maciej.rutecki@gmail.com>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 07:39:08AM +0200, Maciej Rutecki wrote:
> Bad kernel: 3.4-rc3
> Last known good: 3.3
> 
> Subsystem: dri-intel (guess)
> 
> Steps to reproduce:
> 1. Suspend to ram
> 2. Resume
> 
> After resume laptop works ok, but in dmesg I found:
> [  164.098113] ------------[ cut here ]------------
> [  164.098124] WARNING: at drivers/gpu/drm/i915/i915_drv.c:398 
> gen6_gt_check_fifodbg.isra.6+0x31/0x43()
> [  164.098126] Hardware name: 1141ALG
> [  164.098128] MMIO read or write has been dropped ffffffff
> [  164.098129] Modules linked in: xt_tcpudp xt_limit xt_state iptable_filter 
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables bnep rfcomm 
> bluetooth uinput fuse loop sha256_generic aes_x86_64 aes_generic cbc dm_crypt 
> dm_mod uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev 
> usbhid hid media snd_hda_codec_hdmi snd_hda_codec_conexant arc4 iwlwifi 
> mac80211 thinkpad_acpi cfg80211 coretemp nvram snd_hda_intel snd_hda_codec 
> snd_hwdep snd_pcm snd_page_alloc snd_seq ehci_hcd sdhci_pci crc32c_intel 
> iTCO_wdt iTCO_vendor_support ghash_clmulni_intel snd_seq_device cryptd 
> snd_timer microcode snd acpi_cpufreq mperf usbcore psmouse sdhci r8169 
> mmc_core mii ac rfkill i2c_i801 soundcore mei(C) serio_raw pcspkr thermal 
> battery power_supply wmi usb_common evdev processor
> [  164.098188] Pid: 4684, comm: kworker/u:9 Tainted: G         C   3.4.0-rc3 
> #1
> [  164.098189] Call Trace:
> [  164.098197]  [<ffffffff8103aa3c>] warn_slowpath_common+0x7e/0x96
> [  164.098200]  [<ffffffff8103aae8>] warn_slowpath_fmt+0x41/0x43
> [  164.098203]  [<ffffffff812cbec7>] gen6_gt_check_fifodbg.isra.6+0x31/0x43
> [  164.098207]  [<ffffffff812cc13b>] __gen6_gt_force_wake_put+0x19/0x1b
> [  164.098210]  [<ffffffff812cc3cf>] i915_read32+0x66/0x9d
> [  164.098213]  [<ffffffff812ce4fa>] i915_update_gfx_val+0x61/0xb9
> [  164.098218]  [<ffffffff812e989f>] intel_idle_update+0x47/0x18d
> [  164.098222]  [<ffffffff810520d7>] process_one_work+0x1b5/0x340
> [  164.098225]  [<ffffffff8105203a>] ? process_one_work+0x118/0x340
> [  164.098228]  [<ffffffff812e9858>] ? intel_disable_plane+0x60/0x60
> [  164.098231]  [<ffffffff81052c63>] worker_thread+0xce/0x152
> [  164.098234]  [<ffffffff81052b95>] ? manage_workers.isra.22+0x16a/0x16a
> [  164.098237]  [<ffffffff810567c6>] kthread+0xa1/0xa9
> [  164.098242]  [<ffffffff81080ea1>] ? trace_hardirqs_on+0xd/0xf
> [  164.098246]  [<ffffffff8145d374>] kernel_thread_helper+0x4/0x10
> [  164.098250]  [<ffffffff81456970>] ? retint_restore_args+0x13/0x13
> [  164.098253]  [<ffffffff81056725>] ? __init_kthread_worker+0x55/0x55
> [  164.098256]  [<ffffffff8145d370>] ? gs_change+0x13/0x13
> [  164.098257] ---[ end trace 97bd0b679d161c3e ]---
> [  164.098827] ------------[ cut here ]------------
> [  164.098830] WARNING: at drivers/gpu/drm/i915/i915_drv.c:398 
> gen6_gt_check_fifodbg.isra.6+0x31/0x43()
> [  164.098832] Hardware name: 1141ALG
> [  164.098833] MMIO read or write has been dropped ffffffff
> [  164.098834] Modules linked in: xt_tcpudp xt_limit xt_state iptable_filter 
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables bnep rfcomm 
> bluetooth uinput fuse loop sha256_generic aes_x86_64 aes_generic cbc dm_crypt 
> dm_mod uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev 
> usbhid hid media snd_hda_codec_hdmi snd_hda_codec_conexant arc4 iwlwifi 
> mac80211 thinkpad_acpi cfg80211 coretemp nvram snd_hda_intel snd_hda_codec 
> snd_hwdep snd_pcm snd_page_alloc snd_seq ehci_hcd sdhci_pci crc32c_intel 
> iTCO_wdt iTCO_vendor_support ghash_clmulni_intel snd_seq_device cryptd 
> snd_timer microcode snd acpi_cpufreq mperf usbcore psmouse sdhci r8169 
> mmc_core mii ac rfkill i2c_i801 soundcore mei(C) serio_raw pcspkr thermal 
> battery power_supply wmi usb_common evdev processor
> [  164.098877] Pid: 4684, comm: kworker/u:9 Tainted: G        WC   3.4.0-rc3 
> #1
> [  164.098878] Call Trace:
> [  164.098881]  [<ffffffff8103aa3c>] warn_slowpath_common+0x7e/0x96
> [  164.098884]  [<ffffffff8103aae8>] warn_slowpath_fmt+0x41/0x43
> [  164.098888]  [<ffffffff812cbec7>] gen6_gt_check_fifodbg.isra.6+0x31/0x43
> [  164.098891]  [<ffffffff812cc13b>] __gen6_gt_force_wake_put+0x19/0x1b
> [  164.098894]  [<ffffffff812cc3cf>] i915_read32+0x66/0x9d
> [  164.098896]  [<ffffffff812e98f7>] intel_idle_update+0x9f/0x18d
> [  164.098899]  [<ffffffff810520d7>] process_one_work+0x1b5/0x340
> [  164.098902]  [<ffffffff8105203a>] ? process_one_work+0x118/0x340
> [  164.098904]  [<ffffffff812e9858>] ? intel_disable_plane+0x60/0x60
> [  164.098907]  [<ffffffff81052c63>] worker_thread+0xce/0x152
> [  164.098910]  [<ffffffff81052b95>] ? manage_workers.isra.22+0x16a/0x16a
> [  164.098913]  [<ffffffff810567c6>] kthread+0xa1/0xa9
> [  164.098916]  [<ffffffff81080ea1>] ? trace_hardirqs_on+0xd/0xf
> [  164.098918]  [<ffffffff8145d374>] kernel_thread_helper+0x4/0x10
> [  164.098921]  [<ffffffff81456970>] ? retint_restore_args+0x13/0x13
> [  164.098925]  [<ffffffff81056725>] ? __init_kthread_worker+0x55/0x55
> [  164.098927]  [<ffffffff8145d370>] ? gs_change+0x13/0x13
> [  164.098928] ---[ end trace 97bd0b679d161c3f ]---
> 
> I found similar report in:
> https://bugzilla.redhat.com/show_bug.cgi?id=809773
> 
> Dmesg, config and lspci:
> http://mrutecki.pl/download/kernel/3.4-rc3/dri_intel/

Can you please take these files and create a bug report at
bugs.freedesktop.org. Also, is there anything going wrong besides these
error message while you do a suspend cycle?

I'm asking because we newly added this error message to catch potential
issues, but without anything else going wrong it's not a regression.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
