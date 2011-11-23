Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1KWPou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:44:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab1KWPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:44:46 -0500
Date: Wed, 23 Nov 2011 16:46:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>, rajesh.sankaran@intel.com,
        Keith Packard <keithp@keithp.com>, Matthew Garrett <mjg@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when
 reasonable
Message-ID: <20111123154602.GH3864@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	rajesh.sankaran@intel.com, Keith Packard <keithp@keithp.com>,
	Matthew Garrett <mjg@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <20111122201531.GD5547@srcf.ucam.org>
 <861uszfrah.fsf@sumi.keithp.com>
 <20111123102643.GB3864@phenom.ffwll.local>
 <1322056914.15493.158.camel@shinybook.infradead.org>
 <20111123143931.GE3864@phenom.ffwll.local>
 <1322060623.15493.168.camel@shinybook.infradead.org>
 <20111123153154.GF3864@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123153154.GF3864@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 04:31:54PM +0100, Daniel Vetter wrote:
> - Wait 2 minutes for the stuck-in-atomic detection logic to kick in and
>   grab the backtrace over netconsole. Notice that the kernel is stuck
>   trying to flush the dmar tlb cache (that's how I managed to track it
>   down to a dmar interaction). Backtrace almost identical to the dmar
>   issue on ilk. I've lost the backtrace, if you want I can regrab it.

Ok, I've recaptured the last words from my dying machine:

Listening for netconsole messages
[  136.897673] ------------[ cut here ]------------
[  136.897694] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
[  136.897701] Hardware name: HP EliteBook 8460p
[  136.897707] Watchdog detected hard LOCKUP on cpu 0
[  136.897713] Modules linked in: sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf snd_hda_codec_hdmi snd_hda_codec_idt arc4 iwlwifi mac80211 hp_wmi sparse_keymap ppdev uvcvideo videodev v4l2_compat_ioctl32 btusb microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq bluetooth snd_seq_device iTCO_wdt snd_pcm snd_timer snd cfg80211 serio_raw iTCO_vendor_support joydev xhci_hcd rfkill e1000e soundcore snd_page_alloc parport_pc parport tpm_infineon wmi intel_ips ipv6 firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci mmc_core i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[  136.897967] Pid: 0, comm: swapper Not tainted 3.2.0-rc2+ #162
[  136.897972] Call Trace:
[  136.897978]  <NMI>  [<ffffffff8105679a>] warn_slowpath_common+0x83/0x9b
[  136.897998]  [<ffffffff81056855>] warn_slowpath_fmt+0x46/0x48
[  136.898007]  [<ffffffff810152b1>] ? native_sched_clock+0x34/0x36
[  136.898016]  [<ffffffff810ad68b>] watchdog_overflow_callback+0x9b/0xa6
[  136.898026]  [<ffffffff810d78c3>] __perf_event_overflow+0x100/0x17f
[  136.898035]  [<ffffffff810d5f53>] ? perf_event_update_userpage+0xf/0xa2
[  136.898045]  [<ffffffff8101be7b>] ? x86_perf_event_set_period+0x107/0x113
[  136.898053]  [<ffffffff810d7efc>] perf_event_overflow+0x14/0x16
[  136.898062]  [<ffffffff8101f4bc>] intel_pmu_handle_irq+0x211/0x271
[  136.898073]  [<ffffffff81476b65>] perf_event_nmi_handler+0x19/0x1b
[  136.898082]  [<ffffffff814764f7>] nmi_handle+0x42/0x67
[  136.898091]  [<ffffffff814765a8>] do_nmi+0x8c/0x26b
[  136.898099]  [<ffffffff81475db0>] nmi+0x20/0x30
[  136.898109]  [<ffffffff81083ccc>] ? do_raw_spin_lock+0x1/0x25
[  136.898115]  <<EOE>>  <IRQ>  [<ffffffff8147547e>] ? _raw_spin_lock+0xe/0x10
[  136.898135]  [<ffffffff813b712b>] qi_submit_sync+0x30d/0x312
[  136.898143]  [<ffffffff813b7222>] qi_flush_iotlb+0x7a/0x7c
[  136.898152]  [<ffffffff813b918f>] flush_unmaps+0x72/0x131
[  136.898161]  [<ffffffff813b926d>] flush_unmaps_timeout+0x1f/0x32
[  136.898169]  [<ffffffff81062d9d>] run_timer_softirq+0x19b/0x280
[  136.898177]  [<ffffffff81014e05>] ? paravirt_read_tsc+0x9/0xd
[  136.898186]  [<ffffffff813b924e>] ? flush_unmaps+0x131/0x131
[  136.898195]  [<ffffffff8105c477>] __do_softirq+0xc9/0x1b5
[  136.898203]  [<ffffffff81014e05>] ? paravirt_read_tsc+0x9/0xd
[  136.898212]  [<ffffffff8147de6c>] call_softirq+0x1c/0x30
[  136.898222]  [<ffffffff81010add>] do_softirq+0x46/0x81
[  136.898230]  [<ffffffff8105c73f>] irq_exit+0x57/0xb1
[  136.898238]  [<ffffffff8147e7e1>] smp_apic_timer_interrupt+0x7c/0x8a
[  136.898251]  [<ffffffff8147c6de>] apic_timer_interrupt+0x6e/0x80
[  136.898256]  <EOI>  [<ffffffff81014e05>] ? paravirt_read_tsc+0x9/0xd
[  136.898271]  [<ffffffff812766b3>] ? intel_idle+0xef/0x120
[  136.898279]  [<ffffffff81276695>] ? intel_idle+0xd1/0x120
[  136.898289]  [<ffffffff8139f10b>] cpuidle_idle_call+0xe2/0x181
[  136.898297]  [<ffffffff8100e2ed>] cpu_idle+0xa9/0xf0
[  136.898306]  [<ffffffff81456a1e>] rest_init+0x72/0x74
[  136.898316]  [<ffffffff81aceb71>] start_kernel+0x3b0/0x3bd
[  136.898324]  [<ffffffff81ace2c4>] x86_64_start_reservations+0xaf/0xb3
[  136.898332]  [<ffffffff81ace140>] ? early_idt_handlers+0x140/0x140
[  136.898340]  [<ffffffff81ace3ca>] x86_64_start_kernel+0x102/0x111
[  136.898348] ---[ end trace 2d22d2d9c3bfe5c8 ]---
[  161.821354] ------------[ cut here ]------------
[  161.821365] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
[  161.821370] Hardware name: HP EliteBook 8460p
[  161.821376] Watchdog detected hard LOCKUP on cpu 1
[  161.821381] Modules linked in: sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf snd_hda_codec_hdmi snd_hda_codec_idt arc4 iwlwifi mac80211 hp_wmi sparse_keymap ppdev uvcvideo videodev v4l2_compat_ioctl32 btusb microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq bluetooth snd_seq_device iTCO_wdt snd_pcm snd_timer snd cfg80211 serio_raw iTCO_vendor_support joydev xhci_hcd rfkill e1000e soundcore snd_page_alloc parport_pc parport tpm_infineon wmi intel_ips ipv6 firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci mmc_core i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[  161.821609] Pid: 1134, comm: X Tainted: G        W    3.2.0-rc2+ #162
[  161.821615] Call Trace:
[  161.821619]  <NMI>  [<ffffffff8105679a>] warn_slowpath_common+0x83/0x9b
[  161.821633]  [<ffffffff81056855>] warn_slowpath_fmt+0x46/0x48
[  161.821640]  [<ffffffff810152b1>] ? native_sched_clock+0x34/0x36
[  161.821648]  [<ffffffff810ad68b>] watchdog_overflow_callback+0x9b/0xa6
[  161.821655]  [<ffffffff810d78c3>] __perf_event_overflow+0x100/0x17f
[  161.821663]  [<ffffffff810d5f53>] ? perf_event_update_userpage+0xf/0xa2
[  161.821669]  [<ffffffff8101be7b>] ? x86_perf_event_set_period+0x107/0x113
[  161.821677]  [<ffffffff810d7efc>] perf_event_overflow+0x14/0x16
[  161.821684]  [<ffffffff8101f4bc>] intel_pmu_handle_irq+0x211/0x271
[  161.821692]  [<ffffffff81476b65>] perf_event_nmi_handler+0x19/0x1b
[  161.821700]  [<ffffffff814764f7>] nmi_handle+0x42/0x67
[  161.821708]  [<ffffffff814765a8>] do_nmi+0x8c/0x26b
[  161.821715]  [<ffffffff81475db0>] nmi+0x20/0x30
[  161.821723]  [<ffffffff814754aa>] ? _raw_spin_lock_irqsave+0x2a/0x2f
[  161.821728]  <<EOE>>  [<ffffffff813b988f>] add_unmap+0x21/0xb8
[  161.821744]  [<ffffffff813bad66>] intel_unmap_sg+0x101/0x110
[  161.821753]  [<ffffffff811341bc>] ? __pollwait+0xcc/0xcc
[  161.821761]  [<ffffffff812df78f>] intel_gtt_unmap_memory+0x50/0x70
[  161.821784]  [<ffffffffa007dad1>] i915_gem_gtt_unbind_object+0x9c/0xc7 [i915]
[  161.821805]  [<ffffffffa0079377>] i915_gem_object_unbind+0x111/0x1cb [i915]
[  161.821822]  [<ffffffffa0079453>] i915_gem_free_object_tail+0x22/0xd3 [i915]
[  161.821839]  [<ffffffffa007b58c>] i915_gem_free_object+0x46/0x4b [i915]
[  161.821856]  [<ffffffffa001ffa1>] ? drm_gem_handle_create+0xcb/0xcb [drm]
[  161.821870]  [<ffffffffa001ffcc>] drm_gem_object_free+0x2b/0x2d [drm]
[  161.821877]  [<ffffffff8123057b>] kref_put+0x43/0x4d
[  161.821890]  [<ffffffffa001fca5>] drm_gem_object_unreference_unlocked+0x33/0x40 [drm]
[  161.821904]  [<ffffffffa001fdf8>] drm_gem_object_handle_unreference_unlocked.part.1+0x27/0x2c [drm]
[  161.821918]  [<ffffffffa001fec8>] drm_gem_handle_delete+0x84/0x92 [drm]
[  161.821933]  [<ffffffffa0020305>] drm_gem_close_ioctl+0x28/0x2a [drm]
[  161.821946]  [<ffffffffa001e7ae>] drm_ioctl+0x2c8/0x3a5 [drm]
[  161.821958]  [<ffffffffa00202dd>] ? drm_gem_destroy+0x43/0x43 [drm]
[  161.821966]  [<ffffffff810749a6>] ? __hrtimer_start_range_ns+0x2cd/0x2ed
[  161.821974]  [<ffffffff811337f4>] do_vfs_ioctl+0x45d/0x49e
[  161.821982]  [<ffffffff81124f86>] ? fsnotify_access+0x5f/0x67
[  161.821988]  [<ffffffff8113388b>] sys_ioctl+0x56/0x7b
[  161.821995]  [<ffffffff8147bc02>] system_call_fastpath+0x16/0x1b
[  161.822002] ---[ end trace 2d22d2d9c3bfe5c9 ]---
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
