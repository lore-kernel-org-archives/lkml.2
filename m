Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1LRXfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:35:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1LRXfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:35:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Udo Steinberg <udo@hypervisor.org>
Subject: Re: PCI suspend warnings in 3.2-rc6
Date: Mon, 19 Dec 2011 00:38:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <20111218151101.083bc530@x220.fritz.box>
In-Reply-To: <20111218151101.083bc530@x220.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112190038.35760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 18, 2011, Udo Steinberg wrote:
> Hi,
> 
> When suspending to RAM, I'm getting a bunch of warnings from the PCI layer
> in Linux-3.2-rc6, which I didn't get with Linux-3.1. Please let me know if
> I should provide more information about platform, config, etc.

This is a known issue with sdhci-pci and there's a patch fixing that,
hopefully in the maintainer's tree waiting for the next merge window
(I'm not quite sure why not to push if for 3.2, but perhaps that's just me).

Thanks,
Rafael


> [ 4213.638873] PM: Syncing filesystems ... done.
> [ 4213.804067] PM: Preparing system for mem sleep
> [ 4214.475672] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 4214.491035] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 4214.507017] PM: Entering mem sleep
> [ 4214.507137] Suspending console(s) (use no_console_suspend to debug)
> [ 4214.519837] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> [ 4214.520505] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 4214.520532] sd 2:0:0:0: [sdb] Stopping disk
> [ 4214.535795] ------------[ cut here ]------------
> [ 4214.535812] WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support.clone.3+0x48/0x4c()
> [ 4214.535817] Hardware name: 4290W4H
> [ 4214.535823] Pid: 18161, comm: kworker/u:14 Not tainted 3.2.0-rc6 #1
> [ 4214.535827] Call Trace:
> [ 4214.535840]  [<ffffffff81037044>] ? warn_slowpath_common+0x73/0x87
> [ 4214.535848]  [<ffffffff81179840>] ? pci_has_legacy_pm_support.clone.3+0x48/0x4c
> [ 4214.535856]  [<ffffffff81179e53>] ? pci_pm_suspend+0x30/0xea
> [ 4214.535868]  [<ffffffff8123a8b5>] ? dpm_wait+0x35/0x35
> [ 4214.535875]  [<ffffffff8123b05f>] ? pm_op+0x88/0x148
> [ 4214.535882]  [<ffffffff8123b270>] ? __device_suspend+0xfc/0x193
> [ 4214.535890]  [<ffffffff81050f57>] ? __async_schedule+0x121/0x121
> [ 4214.535897]  [<ffffffff8123b53e>] ? async_suspend+0x19/0x83
> [ 4214.535903]  [<ffffffff81050fed>] ? async_run_entry_fn+0x96/0x141
> [ 4214.535912]  [<ffffffff81047492>] ? process_one_work+0x1c8/0x2e3
> [ 4214.535919]  [<ffffffff81046b23>] ? need_to_create_worker+0x15/0x2d
> [ 4214.535927]  [<ffffffff81048261>] ? worker_thread+0x17a/0x23a
> [ 4214.535934]  [<ffffffff810480e7>] ? manage_workers.clone.18+0x15b/0x15b
> [ 4214.535941]  [<ffffffff8104bc97>] ? kthread+0x7a/0x82
> [ 4214.535949]  [<ffffffff813e3574>] ? kernel_thread_helper+0x4/0x10
> [ 4214.535956]  [<ffffffff8104bc1d>] ? kthread_flush_work_fn+0x11/0x11
> [ 4214.535962]  [<ffffffff813e3570>] ? gs_change+0xb/0xb
> [ 4214.535972] ---[ end trace 50804e7504fa4fca ]---
> [ 4214.536061] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
> [ 4214.537252] sdhci-pci 0000:0d:00.0: PCI INT A disabled
> [ 4214.539032] ACPI handle has no context!
> [ 4214.545824] sd 0:0:0:0: [sda] Stopping disk
> [ 4214.554906] i915 0000:00:02.0: power state changed by ACPI to D3
> [ 4214.626750] ehci_hcd 0000:00:1d.0: PCI INT A disabled
> [ 4214.630739] ehci_hcd 0000:00:1a.0: PCI INT A disabled
> [ 4214.630753] e1000e 0000:00:19.0: PCI INT A disabled
> [ 4214.630766] e1000e 0000:00:19.0: PME# enabled
> [ 4214.630774] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
> [ 4214.818745] PM: suspend of devices complete after 311.805 msecs
> [ 4214.819011] xhci_hcd 0000:0e:00.0: PME# enabled
> [ 4214.819036] pcieport 0000:00:1c.6: wake-up capability enabled by ACPI
> [ 4214.834654] ------------[ cut here ]------------
> [ 4214.834673] WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support.clone.3+0x48/0x4c()
> [ 4214.834679] Hardware name: 4290W4H
> [ 4214.834686] Pid: 18148, comm: acpi_handler.sh Tainted: G        W    3.2.0-rc6 #1
> [ 4214.834690] Call Trace:
> [ 4214.834701]  [<ffffffff81037044>] ? warn_slowpath_common+0x73/0x87
> [ 4214.834710]  [<ffffffff81179840>] ? pci_has_legacy_pm_support.clone.3+0x48/0x4c
> [ 4214.834717]  [<ffffffff81179acf>] ? pci_pm_suspend_noirq+0x2e/0x10c
> [ 4214.834726]  [<ffffffff8123b67a>] ? pm_noirq_op+0xd2/0x1ad
> [ 4214.834733]  [<ffffffff8123b9a4>] ? dpm_suspend_noirq+0x9f/0x1e8
> [ 4214.834743]  [<ffffffff8105e04c>] ? suspend_devices_and_enter+0x8e/0x1ec
> [ 4214.834751]  [<ffffffff8105e2c1>] ? enter_state+0x117/0x168
> [ 4214.834757]  [<ffffffff8105d4ca>] ? state_store+0xb4/0x108
> [ 4214.834764]  [<ffffffff810f0801>] ? sysfs_write_file+0xd3/0x10f
> [ 4214.834775]  [<ffffffff810aa823>] ? vfs_write+0xaf/0x129
> [ 4214.834782]  [<ffffffff810aa950>] ? sys_write+0x45/0x6e
> [ 4214.834794]  [<ffffffff813e21fb>] ? system_call_fastpath+0x16/0x1b
> [ 4214.834799] ---[ end trace 50804e7504fa4fcb ]---
> [ 4214.850794] ehci_hcd 0000:00:1d.0: PME# enabled
> [ 4214.850814] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
> [ 4214.866576] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
> [ 4214.866677] ehci_hcd 0000:00:1a.0: PME# enabled
> [ 4214.866692] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
> [ 4214.882555] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
> [ 4214.882675] PM: late suspend of devices complete after 64.003 msecs
> [ 4214.883556] ACPI: Preparing to enter system sleep state S3
> [ 4215.054409] PM: Saving platform NVS memory
> [ 4215.064347] Disabling non-boot CPUs ...
> [ 4215.067271] CPU 1 is now offline
> [ 4215.170127] CPU 2 is now offline
> [ 4215.273993] CPU 3 is now offline
> [ 4215.274566] Extended CMOS year: 2000
> [ 4215.275541] ACPI: Low-level resume complete
> [ 4215.275577] PM: Restoring platform NVS memory
> [ 4215.276354] Extended CMOS year: 2000
> [ 4215.276372] Enabling non-boot CPUs ...
> [ 4215.284592] Booting Node 0 Processor 1 APIC 0x1
> [ 4215.284597] smpboot cpu 1: start_ip = 98000
> [ 4215.296268] Calibrating delay loop (skipped) already calibrated this CPU
> [ 4215.296280] Disabled fast string operations
> [ 4215.363838] CPU1 is up
> [ 4215.364104] Booting Node 0 Processor 2 APIC 0x2
> [ 4215.364109] smpboot cpu 2: start_ip = 98000
> [ 4215.375712] Calibrating delay loop (skipped) already calibrated this CPU
> [ 4215.375723] Disabled fast string operations
> [ 4215.491556] CPU2 is up
> [ 4215.491896] Booting Node 0 Processor 3 APIC 0x3
> [ 4215.491897] smpboot cpu 3: start_ip = 98000
> [ 4215.502909] Calibrating delay loop (skipped) already calibrated this CPU
> [ 4215.502920] Disabled fast string operations
> [ 4215.571679] CPU3 is up
> [ 4215.576087] ACPI: Waking up from system sleep state S3
> [ 4215.767262] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1 - docking
> [ 4215.775227] ACPI: Unable to dock!
> [ 4215.907164] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [ 4215.907189] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
> [ 4215.907236] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.907269] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0xfed0a004, writing 0xf2625004)
> [ 4215.907284] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
> [ 4215.907324] serial 0000:00:16.3: restoring config space at offset 0xf (was 0x200, writing 0x2ff)
> [ 4215.907354] serial 0000:00:16.3: restoring config space at offset 0x5 (was 0x0, writing 0xf262c000)
> [ 4215.907364] serial 0000:00:16.3: restoring config space at offset 0x4 (was 0x1, writing 0x50b1)
> [ 4215.907379] serial 0000:00:16.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00003)
> [ 4215.907425] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.907452] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x5081)
> [ 4215.907470] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100007)
> [ 4215.907523] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.907554] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf262a000)
> [ 4215.907570] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
> [ 4215.907617] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
> [ 4215.907626] ehci_hcd 0000:00:1a.0: PME# disabled
> [ 4215.907635] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 4215.907644] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 4215.907678] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.907709] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xf2620004)
> [ 4215.907720] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
> [ 4215.907732] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
> [ 4215.907790] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.907813] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
> [ 4215.907823] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
> [ 4215.907834] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
> [ 4215.907852] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 4215.907866] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100004)
> [ 4215.907930] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x2ff)
> [ 4215.907953] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
> [ 4215.907964] pcieport 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf250f250)
> [ 4215.907974] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
> [ 4215.907990] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 4215.908003] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [ 4215.908071] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x4ff)
> [ 4215.908094] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xf0b1f041)
> [ 4215.908104] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xf240f1d0)
> [ 4215.908114] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
> [ 4215.908132] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 4215.908146] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [ 4215.908212] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.908234] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0xf131f0c1)
> [ 4215.908245] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf1c0f150)
> [ 4215.908256] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x3030)
> [ 4215.908273] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 4215.908286] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [ 4215.908348] pcieport 0000:00:1c.6: restoring config space at offset 0xf (was 0x300, writing 0x3ff)
> [ 4215.908369] pcieport 0000:00:1c.6: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
> [ 4215.908379] pcieport 0000:00:1c.6: restoring config space at offset 0x8 (was 0x0, writing 0xf140f140)
> [ 4215.908390] pcieport 0000:00:1c.6: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
> [ 4215.908405] pcieport 0000:00:1c.6: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 4215.908418] pcieport 0000:00:1c.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [ 4215.908477] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.908508] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2629000)
> [ 4215.908523] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
> [ 4215.908556] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
> [ 4215.908565] ehci_hcd 0000:00:1d.0: PME# disabled
> [ 4215.908571] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 4215.908579] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 4215.908700] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
> [ 4215.909066] iwlwifi 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.909120] iwlwifi 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf2500004)
> [ 4215.909134] iwlwifi 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
> [ 4215.909151] iwlwifi 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
> [ 4215.909490] sdhci-pci 0000:0d:00.0: restoring config space at offset 0x3 (was 0x800010, writing 0x10)
> [ 4215.909537] sdhci-pci 0000:0d:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
> [ 4215.909604] ------------[ cut here ]------------
> [ 4215.909618] WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support.clone.3+0x48/0x4c()
> [ 4215.909623] Hardware name: 4290W4H
> [ 4215.909629] Pid: 18148, comm: acpi_handler.sh Tainted: G        W    3.2.0-rc6 #1
> [ 4215.909633] Call Trace:
> [ 4215.909646]  [<ffffffff81037044>] ? warn_slowpath_common+0x73/0x87
> [ 4215.909654]  [<ffffffff81179840>] ? pci_has_legacy_pm_support.clone.3+0x48/0x4c
> [ 4215.909661]  [<ffffffff811799c8>] ? pci_pm_resume_noirq+0x25/0x62
> [ 4215.909671]  [<ffffffff8123b696>] ? pm_noirq_op+0xee/0x1ad
> [ 4215.909677]  [<ffffffff8123b82e>] ? dpm_resume_noirq+0xd9/0x1b0
> [ 4215.909687]  [<ffffffff8105e132>] ? suspend_devices_and_enter+0x174/0x1ec
> [ 4215.909695]  [<ffffffff8105e2c1>] ? enter_state+0x117/0x168
> [ 4215.909702]  [<ffffffff8105d4ca>] ? state_store+0xb4/0x108
> [ 4215.909709]  [<ffffffff810f0801>] ? sysfs_write_file+0xd3/0x10f
> [ 4215.909719]  [<ffffffff810aa823>] ? vfs_write+0xaf/0x129
> [ 4215.909727]  [<ffffffff810aa950>] ? sys_write+0x45/0x6e
> [ 4215.909738]  [<ffffffff813e21fb>] ? system_call_fastpath+0x16/0x1b
> [ 4215.909744] ---[ end trace 50804e7504fa4fcc ]---
> [ 4215.909804] xhci_hcd 0000:0e:00.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> [ 4215.909844] xhci_hcd 0000:0e:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf1400004)
> [ 4215.909856] xhci_hcd 0000:0e:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
> [ 4215.909870] xhci_hcd 0000:0e:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100402)
> [ 4215.909934] pcieport 0000:00:1c.6: wake-up capability disabled by ACPI
> [ 4215.909944] xhci_hcd 0000:0e:00.0: PME# disabled
> [ 4215.910048] PM: early resume of devices complete after 2.971 msecs
> [ 4215.910321] ------------[ cut here ]------------
> [ 4215.910330] WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support.clone.3+0x48/0x4c()
> [ 4215.910334] Hardware name: 4290W4H
> [ 4215.910339] Pid: 18152, comm: kworker/u:5 Tainted: G        W    3.2.0-rc6 #1
> [ 4215.910343] Call Trace:
> [ 4215.910351]  [<ffffffff81037044>] ? warn_slowpath_common+0x73/0x87
> [ 4215.910362] xhci_hcd 0000:0e:00.0: setting latency timer to 64
> [ 4215.910373]  [<ffffffff81179840>] ? pci_has_legacy_pm_support.clone.3+0x48/0x4c
> [ 4215.910380]  [<ffffffff81179cca>] ? pci_pm_resume+0x3b/0x7a
> [ 4215.910387]  [<ffffffff8123b07d>] ? pm_op+0xa6/0x148
> [ 4215.910394]  [<ffffffff8123bbdf>] ? device_resume+0xa4/0x100
> [ 4215.910402]  [<ffffffff81050f57>] ? __async_schedule+0x121/0x121
> [ 4215.910409] usb usb3: root hub lost power or was reset
> [ 4215.910415] usb usb4: root hub lost power or was reset
> [ 4215.910422]  [<ffffffff8123be5d>] ? async_resume+0x14/0x38
> [ 4215.910429]  [<ffffffff81050fed>] ? async_run_entry_fn+0x96/0x141
> [ 4215.910438]  [<ffffffff81047492>] ? process_one_work+0x1c8/0x2e3
> [ 4215.910445]  [<ffffffff81048261>] ? worker_thread+0x17a/0x23a
> [ 4215.910453]  [<ffffffff810480e7>] ? manage_workers.clone.18+0x15b/0x15b
> [ 4215.910460]  [<ffffffff810480e7>] ? manage_workers.clone.18+0x15b/0x15b
> [ 4215.910466]  [<ffffffff8104bc97>] ? kthread+0x7a/0x82
> [ 4215.910473]  [<ffffffff813e3574>] ? kernel_thread_helper+0x4/0x10
> [ 4215.910480]  [<ffffffff8104bc1d>] ? kthread_flush_work_fn+0x11/0x11
> [ 4215.910486]  [<ffffffff813e3570>] ? gs_change+0xb/0xb
> [ 4215.910490] ---[ end trace 50804e7504fa4fcd ]---
> [ 4215.911008] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> [ 4215.911012] xhci_hcd 0000:0e:00.0: irq 42 for MSI/MSI-X
> [ 4215.911015] e1000e 0000:00:19.0: PME# disabled
> [ 4215.911017] xhci_hcd 0000:0e:00.0: irq 44 for MSI/MSI-X
> [ 4215.911022] xhci_hcd 0000:0e:00.0: irq 45 for MSI/MSI-X
> [ 4215.911027] xhci_hcd 0000:0e:00.0: irq 46 for MSI/MSI-X
> [ 4215.911031] xhci_hcd 0000:0e:00.0: irq 47 for MSI/MSI-X
> [ 4215.911043] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 4215.911231] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 4215.911254] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [ 4215.911262] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
> [ 4215.911358] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
> [ 4215.911377] e1000e 0000:00:19.0: irq 49 for MSI/MSI-X
> [ 4215.911414] ahci 0000:00:1f.2: setting latency timer to 64
> [ 4215.911487] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 4215.911492] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 4215.911500] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 4215.911510] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [ 4215.911534] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 4215.911542] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [ 4215.911551] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 4215.911846] i915 0000:00:02.0: power state changed by ACPI to D0
> [ 4215.911862] i915 0000:00:02.0: power state changed by ACPI to D0
> [ 4215.911876] i915 0000:00:02.0: setting latency timer to 64
> [ 4215.926937] sd 2:0:0:0: [sdb] Starting disk
> [ 4215.926952] sd 0:0:0:0: [sda] Starting disk
> 

