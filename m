Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab1KOTVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:21:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55497 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab1KOTVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <201111152305.09451.sftp.mtuci@gmail.com>
References: <201111152305.09451.sftp.mtuci@gmail.com>
Date: Tue, 15 Nov 2011 14:21:10 -0500
Message-ID: <CADnq5_Mu4pLxTpdOYDBaqf2d3XsZC1bH-pBVZ_dA0WGj6EtwAg@mail.gmail.com>
Subject: Re: radeon/kms: black screen when loading radeon with modeset=1
From: Alex Deucher <alexdeucher@gmail.com>
To: "Sergey V." <sftp.mtuci@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 2:05 PM, Sergey V. <sftp.mtuci@gmail.com> wrote:
> Kernel from Linus tree, HEAD at 7f80850d3f9fd8fda23a317044aef3a6bafab06b
>
> Loading radeon module with modeset=1 causes black screen.
>
> Usually it happens at boot time, but if run kernel with radeon.modeset=0 then
> `rmmod radeon; modprobe radeon modeset=1` I can get dmesg over ssh (thanks to
> glisse from #radeon for help).

Fixed with this patch:
http://lists.freedesktop.org/archives/dri-devel/2011-November/016498.html

Alex

>
> Backtrace below:
>
> [   89.905890] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> [   89.906016] IP: [<ffffffffa05998ed>]
> radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
> [   89.906016] PGD 6a0e1067 PUD 6a09d067 PMD 0
> [   89.906016] Oops: 0002 [#1] SMP
> [   89.906016] CPU 0
> [   89.906016] Modules linked in: radeon(+) snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs
> cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse
> snd_hda_codec_hdmi snd_hda_codec_realtek processor ttm drm_kms_helper drm
> thermal i2c_piix4 joydev agpgart video snd_hda_intel r8169 thermal_sys
> i2c_algo_bit i2c_core k8temp battery sdhci_pci snd_hda_codec evdev hwmon mii
> button ac shpchp sdhci snd_hwdep snd_pcm psmouse serio_raw mmc_core snd_timer
> sg snd soundcore snd_page_alloc [last unloaded: radeon]
> [   89.906016]
> [   89.906016] Pid: 2189, comm: modprobe Tainted: G        W    3.2.0-rc1+ #4
> Micro-Star International PR210/MS-1222
> [   89.906016] RIP: 0010:[<ffffffffa05998ed>]  [<ffffffffa05998ed>]
> radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
> [   89.906016] RSP: 0018:ffff880075959948  EFLAGS: 00010246
> [   89.906016] RAX: 0000000000000000 RBX: ffff880075b72000 RCX:
> 0000000000000000
> [   89.906016] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> ffff880076c73c00
> [   89.906016] RBP: ffff880075959a98 R08: 0000000000000000 R09:
> ffff880076c73a00
> [   89.906016] R10: ffff8800758a0000 R11: 0000000000000006 R12:
> ffff8800758aadde
> [   89.906016] R13: ffff8800758aadde R14: 0000000000000000 R15:
> 0000000000000000
> [   89.906016] FS:  00007f57d0b27720(0000) GS:ffff88007bc00000(0000)
> knlGS:00000000f702a6d0
> [   89.906016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   89.906016] CR2: 0000000000000008 CR3: 000000006a0a6000 CR4:
> 00000000000006f0
> [   89.906016] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   89.906016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [   89.906016] Process modprobe (pid: 2189, threadinfo ffff880075958000, task
> ffff880075abc6d0)
> [   89.906016] Stack:
> [   89.906016]  ffff88000000ffff ffff8800768f400a ffff880000000000
> 00ffffff00000000
> [   89.906016]  ffff880037653663 ffff880075b73158 ffff880075b73174
> 0000000675959acf
> [   89.906016]  ffffffff81b6112c ffff880075959a38 ffffffff81b6112e
> ffff880075959ad5
> [   89.906016] Call Trace:
> [   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
> [   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
> [   89.906016]  [<ffffffff81076511>] ? up+0x31/0x50
> [   89.906016]  [<ffffffff81050494>] ? console_unlock+0x1c4/0x230
> [   89.906016]  [<ffffffffa059cb98>]
> radeon_atombios_get_power_modes+0x228/0x8e0 [radeon]
> [   89.906016]  [<ffffffffa05e7e01>] radeon_pm_init+0x3b1/0x590 [radeon]
> [   89.906016]  [<ffffffffa05d0039>] ? rs600_irq_set+0x109/0x180 [radeon]
> [   89.906016]  [<ffffffffa05b7ca9>] radeon_modeset_init+0x4c9/0x8a0 [radeon]
> [   89.906016]  [<ffffffffa05fb3dc>] ? radeon_acpi_init+0x8c/0xbc [radeon]
> [   89.906016]  [<ffffffffa0598760>] radeon_driver_load_kms+0x120/0x170
> [radeon]
> [   89.906016]  [<ffffffffa024d82e>] drm_get_pci_dev+0x18e/0x2c0 [drm]
> [   89.906016]  [<ffffffffa05fb4b9>] radeon_pci_probe+0xad/0xb5 [radeon]
> [   89.906016]  [<ffffffff812a8edf>] local_pci_probe+0x5f/0xd0
> [   89.906016]  [<ffffffff812a97b8>] pci_device_probe+0x88/0xb0
> [   89.906016]  [<ffffffff81331bca>] ? driver_sysfs_add+0x7a/0xb0
> [   89.906016]  [<ffffffff81331ed6>] driver_probe_device+0x96/0x1b0
> [   89.906016]  [<ffffffff81332093>] __driver_attach+0xa3/0xb0
> [   89.906016]  [<ffffffff81331ff0>] ? driver_probe_device+0x1b0/0x1b0
> [   89.906016]  [<ffffffff81330e9e>] bus_for_each_dev+0x5e/0x90
> [   89.906016]  [<ffffffff81331b4e>] driver_attach+0x1e/0x20
> [   89.906016]  [<ffffffff81331745>] bus_add_driver+0x155/0x280
> [   89.906016]  [<ffffffff81332676>] driver_register+0x76/0x140
> [   89.906016]  [<ffffffff812a9a45>] __pci_register_driver+0x55/0xd0
> [   89.906016]  [<ffffffffa024da71>] drm_pci_init+0x111/0x120 [drm]
> [   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
> [   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
> [   89.906016]  [<ffffffffa06390ec>] radeon_init+0xec/0xee [radeon]
> [   89.906016]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
> [   89.906016]  [<ffffffff8108c332>] sys_init_module+0x92/0x1e0
> [   89.906016]  [<ffffffff817fba6b>] system_call_fastpath+0x16/0x1b
> [   89.906016] Code: 16 44 3b b5 ec fe ff ff 0f 8d 40 01 00 00 48 8b 83 58 11
> 00 00 49 63 cf 48 89 ca 48 c1 e1 06 48 c1 e2 04 48 29 d1 48 8b 44 08 08 <c7>
> 40 08 00 00 00 00 0f b6 45 8f 3c 02 75 ac 4c 8b 83 58 11 00
> [   89.906016] RIP  [<ffffffffa05998ed>]
> radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
> [   89.906016]  RSP <ffff880075959948>
> [   89.906016] CR2: 0000000000000008
> [   89.918682] ---[ end trace 758728fd12807b58 ]---
>
> Whole dmesg output attached.
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
