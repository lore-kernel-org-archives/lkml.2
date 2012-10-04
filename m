Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2JDTas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:30:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58849 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2JDTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:30:46 -0400
Date: Thu, 4 Oct 2012 21:31:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: i915 problems with suspend to disk
Message-ID: <20121004193139.GJ5661@phenom.ffwll.local>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <20121004192017.GI25498@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004192017.GI25498@carfax.org.uk>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:20:17PM +0100, Hugo Mills wrote:
>    Hi,
> 
>    On 3.6, I've got a problem with my video driver after resuming from
> suspend-to-disk: the lower part of the display flickers, rapidly but
> irregularly (think of a neon sign in a bad film noir), flicking
> between the correct display and... something else, it's hard to see
> what.
> 
>    Shutting the lid of the machine (to trigger a suspend-to-ram) and
> waking it up again fixes the flicker.
> 
>    In syslogs, I have nothing obvious on suspend, and this warning on
> resume:
> 
> Oct  4 19:53:04 ruth kernel: [ 2892.184086] ------------[ cut here ]------------
> Oct  4 19:53:04 ruth kernel: [ 2892.184114] WARNING: at drivers/gpu/drm/i915/intel_display.c:1225 intel_crtc_disable+0x52/0x86 [i915]()
> Oct  4 19:53:04 ruth kernel: [ 2892.184115] Hardware name: 0196CTO
> Oct  4 19:53:04 ruth kernel: [ 2892.184117] pipe B assertion failure (expected off, current on)
> Oct  4 19:53:04 ruth kernel: [ 2892.184188] Modules linked in: cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative rfcomm bnep binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc ext4 jbd2 mbcache loop arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant coretemp i915 snd_hda_intel snd_hda_codec drm_kms_helper iwlwifi snd_hwdep snd_pcm snd_page_alloc joydev snd_seq snd_seq_device snd_timer kvm_intel drm i2c_algo_bit thinkpad_acpi acpi_cpufreq nvram btusb bluetooth kvm crc16 cfg80211 microcode psmouse evdev i2c_i801 video rfkill wmi mperf i2c_core snd battery ac processor soundcore button btrfs crc32c libcrc32c zlib_deflate sha256_generic ablk_helper cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sd_mod crc_t10dif ums_realtek usb_storage uas thermal thermal_sys ahci libahci libata uhci_hcd scsi_mod ehci_hcd r8169 mii usbcore usb_common
> Oct  4 19:53:04 ruth kernel: [ 2892.184198] Pid: 4117, comm: kworker/u:3 Not tainted 3.6.0 #14
> Oct  4 19:53:04 ruth kernel: [ 2892.184199] Call Trace:
> Oct  4 19:53:04 ruth kernel: [ 2892.184207]  [<ffffffff8102bdc5>] ? warn_slowpath_common+0x78/0x8c
> Oct  4 19:53:04 ruth kernel: [ 2892.184213]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
> Oct  4 19:53:04 ruth kernel: [ 2892.184216]  [<ffffffff8102be71>] ? warn_slowpath_fmt+0x45/0x4a
> Oct  4 19:53:04 ruth kernel: [ 2892.184221]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
> Oct  4 19:53:04 ruth kernel: [ 2892.184238]  [<ffffffffa03fdae0>] ? intel_crtc_disable+0x52/0x86 [i915]
> Oct  4 19:53:04 ruth kernel: [ 2892.184245]  [<ffffffffa0273e47>] ? drm_helper_disable_unused_functions+0xd0/0xfb [drm_kms_helper]
> Oct  4 19:53:04 ruth kernel: [ 2892.184250]  [<ffffffffa027461e>] ? drm_helper_resume_force_mode+0xf1/0xff [drm_kms_helper]
> Oct  4 19:53:04 ruth kernel: [ 2892.184254]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
> Oct  4 19:53:04 ruth kernel: [ 2892.184264]  [<ffffffffa03dc17f>] ? i915_drm_thaw+0xd4/0x10b [i915]
> Oct  4 19:53:04 ruth kernel: [ 2892.184274]  [<ffffffffa03dc4fc>] ? i915_resume+0x3b/0x50 [i915]
> Oct  4 19:53:04 ruth kernel: [ 2892.184279]  [<ffffffff81193f21>] ? pci_legacy_resume+0x39/0x39
> Oct  4 19:53:04 ruth kernel: [ 2892.184284]  [<ffffffff812196f7>] ? dpm_run_callback.isra.5+0x26/0x54
> Oct  4 19:53:04 ruth kernel: [ 2892.184289]  [<ffffffff81219fe1>] ? device_resume+0xd0/0x110
> Oct  4 19:53:04 ruth kernel: [ 2892.184292]  [<ffffffff8121a035>] ? async_resume+0x14/0x38
> Oct  4 19:53:04 ruth kernel: [ 2892.184296]  [<ffffffff8104b070>] ? async_run_entry_fn+0x9d/0x175
> Oct  4 19:53:04 ruth kernel: [ 2892.184300]  [<ffffffff81041a1a>] ? process_one_work+0x184/0x2a3
> Oct  4 19:53:04 ruth kernel: [ 2892.184304]  [<ffffffff810426f1>] ? worker_thread+0x1fe/0x29f
> Oct  4 19:53:04 ruth kernel: [ 2892.184307]  [<ffffffff810424f3>] ? manage_workers+0x223/0x223
> Oct  4 19:53:04 ruth kernel: [ 2892.184310]  [<ffffffff810424f3>] ? manage_workers+0x223/0x223
> Oct  4 19:53:04 ruth kernel: [ 2892.184315]  [<ffffffff81045adf>] ? kthread+0x67/0x6f
> Oct  4 19:53:04 ruth kernel: [ 2892.184319]  [<ffffffff812fe774>] ? kernel_thread_helper+0x4/0x10
> Oct  4 19:53:04 ruth kernel: [ 2892.184324]  [<ffffffff81045a78>] ? kthread_freezable_should_stop+0x3c/0x3c
> Oct  4 19:53:04 ruth kernel: [ 2892.184327]  [<ffffffff812fe770>] ? gs_change+0xb/0xb
> Oct  4 19:53:04 ruth kernel: [ 2892.184328] ---[ end trace 4e63ed9ed8ebc493 ]---
> 
>    Hardware is a Lenovo Thinkpad Edge13, lspci says:
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 
> aka
> 
> 00:02.0 0300: 8086:2a42 (rev 07)
> 
>    Let me know if you need more information. I can probably manage a
> bisect if necessary -- it's easily repeatable as a bug.

Before you do a bisect, can you try the drm-intel-fixes branch from
http://cgit.freedesktop.org/~danvet/drm-intel or a bit more risky, latest
upstream git? That contains a completely rewritten modeset code, which
might fix this already. To fix the breakage on 3.6 I guess we need a
bisect - at least I don't have any idea off-hand what could have gone
wrong here.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
