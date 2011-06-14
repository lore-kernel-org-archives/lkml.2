Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1FNMMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:12:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52607 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab1FNMMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=KE60Vt7gxDu5kGI3irGucQ+RlZ7dTuqeL+9MmhHwFKZ1DZpxEC2+kxwcvb1hTbqSmf
         M6N1a1DbmmJWL4dycc68oaQbdJsz9sUEcUVV7QJi2IyOo7JMEPP9R3lPnBuCyRgVZvh7
         b1VqZW/m3CDNcPYKJF2QBr7gnPcPlFoHifoWM=
From: Kan-Ru Chen <kanru@kanru.info>
To: linux-kernel@vger.kernel.org
Subject: 3.0-rc3 WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
Date: Tue, 14 Jun 2011 20:12:01 +0800
Message-ID: <874o3sd33i.fsf@isil.kanru.info>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-rc3 on X220 (Intel HD Graphics 3000) after resume from
hibernation. Got several of warnings in dmesg:

[  955.809593] ------------[ cut here ]------------
[  955.809595] WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
[  955.809596] Hardware name: 4286CTO
[  955.809597] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit acpi_cpufreq mperf tun nfsd exportfs nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext2 tp_char
intel cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod joydev snd_hda_codec_hdmi snd_hda_codec_conexant arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq s
e psmouse mac80211 tpm_tis tpm thinkpad_acpi btusb i2c_i801 pcspkr serio_raw evdev i2c_core bluetooth cfg80211 nvram snd tpm_bios battery rfkill ac button wmi video 
l_agp intel_gtt agpgart processor ext4 mbcache jbd2 crc16 sd_mod crc_t10dif ahci libahci libata sdhci_pci sdhci mmc_core scsi_mod xhci_hcd thermal thermal_sys ehci_h
ded: scsi_wait_scan]
[  955.809618] Pid: 4200, comm: kworker/u:8 Tainted: G        W   3.0.0-rc3 #10
[  955.809619] Call Trace:
[  955.809620]  [<ffffffff810487f7>] warn_slowpath_common+0x83/0x9b
[  955.809622]  [<ffffffff81048829>] warn_slowpath_null+0x1a/0x1c
[  955.809624]  [<ffffffffa04d356a>] gen6_gt_force_wake_put+0x29/0x52 [i915]
[  955.809628]  [<ffffffffa04dd815>] i915_read8+0x45/0x6d [i915]
[  955.809632]  [<ffffffffa04df96a>] i915_restore_display+0x1097/0x10bc [i915]
[  955.809635]  [<ffffffffa04dfbd0>] i915_restore_state+0x58/0x1f8 [i915]
[  955.809638]  [<ffffffffa04d30fe>] i915_drm_thaw+0x51/0xd8 [i915]
[  955.809641]  [<ffffffffa04d3365>] i915_resume+0x45/0x5c [i915]
[  955.809644]  [<ffffffffa04d3392>] i915_pm_resume+0x16/0x18 [i915]
[  955.809646]  [<ffffffff811a79da>] pci_pm_resume+0x8c/0xa1
[  955.809647]  [<ffffffff81069464>] ? async_run_entry_fn+0x11b/0x153
[  955.809649]  [<ffffffff81234975>] pm_op+0xa9/0x149
[  955.809651]  [<ffffffff81069349>] ? async_schedule+0x17/0x17
[  955.809652]  [<ffffffff81234ca5>] device_resume+0x93/0xcb
[  955.809654]  [<ffffffff8132aaf5>] ? _raw_spin_unlock_irqrestore+0x16/0x18
[  955.809656]  [<ffffffff81234cfc>] async_resume+0x1f/0x47
[  955.809658]  [<ffffffff81069464>] ? async_run_entry_fn+0x11b/0x153
[  955.809659]  [<ffffffff810693eb>] async_run_entry_fn+0xa2/0x153
[  955.809661]  [<ffffffff8105eabb>] process_one_work+0x15c/0x28f
[  955.809663]  [<ffffffff8105fb0d>] worker_thread+0xd3/0x157
[  955.809665]  [<ffffffff8105fa3a>] ? manage_workers.isra.24+0x16f/0x16f
[  955.809667]  [<ffffffff81062fa8>] kthread+0x84/0x8c
[  955.809668]  [<ffffffff8132c4e4>] kernel_thread_helper+0x4/0x10
[  955.809670]  [<ffffffff81062f24>] ? kthread_worker_fn+0x146/0x146
[  955.809671]  [<ffffffff8132c4e0>] ? gs_change+0x13/0x13
[  955.809672] ---[ end trace 3949a50701070187 ]---

-- 
Kanru
