Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1HIM2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:28:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10571 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1HIM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:27:58 -0400
Date: Tue, 9 Aug 2011 14:27:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
In-Reply-To: <alpine.LNX.2.00.1108061049510.4163@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1108091426090.17636@swampdragon.chaosbits.net>
References: <Pine.LNX.4.44L0.1108051641040.2055-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108061049510.4163@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Aug 2011, Jesper Juhl wrote:

> On Fri, 5 Aug 2011, Alan Stern wrote:
> 
> > On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:
> > 
> > > > You're right, sorry.  System suspend was not involved, so the problem
> > > > was triggerend by runtime suspend alone, resulting from unplugging the
> > > > Ethernet cable.
> > > > 
> > > > It looks like the crash started in pci_disable_msi().
> > > 
> > > OTOH, I'm not sure how pci_legacy_suspend_late() was called.
> > > In theory it is only called by the system suspend code and it surely
> > > is not called for e1000e.
> > 
> > The ? indicates that pci_legacy_suspend_late() wasn't necessarily on
> > the task's call stack; it may simply have been a leftover pointer from
> > some other operation, sitting somewhere in the middle of the stack
> > page.
> > 
> 
> Not sure if it helps, but I've been trying to reproduce the crash and 
> although I've not succeeded doing that yet, I've got something else.
> 
> While trying to reproduce by unplugging/replugging ethernet and 
> resuming/suspending a lot I found the following in dmesg after one of the 
> resumes - the system seems to be working fine though and network works 
> as well, so it's not the same complete crash but it looks 
> potentially related :
> 
> [ 6564.921192] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100107)
> [ 6564.921222] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
> [ 6564.921240] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2828000)
> [ 6564.921247] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
> [ 6564.937545] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 6564.937554] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 6564.937708] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
> [ 6564.937805] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
> [ 6564.937815] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
> [ 6564.937820] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf250f250)
> [ 6564.937824] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
> [ 6564.937832] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 6564.937838] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> [ 6564.937872] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
> [ 6564.937890] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2828400)
> [ 6564.937897] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
> [ 6564.937915] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 6564.937918] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 6564.938019] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
> [ 6564.938085] intel ips 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40b)
> [ 6564.938107] intel ips 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
> [ 6564.938674] PM: early resume of devices complete after 17.784 msecs[ 6564.939048] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 6564.939053] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
> [ 6564.939118] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6564.942219] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 6564.942229] pci 0000:00:1e.0: setting latency timer to 64
> [ 6564.942236] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 6564.942246] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 6564.942253] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [ 6564.942261] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 6564.942265] ahci 0000:00:1f.2: setting latency timer to 64
> [ 6564.942276] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [ 6564.942344] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [ 6564.942360] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
> [ 6564.942436] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 6564.942444] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 6564.942452] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 6564.942456] sd 0:0:0:0: [sda] Starting disk
> [ 6564.942458] i915 0000:00:02.0: power state changed by ACPI to D0
> [ 6564.942463] i915 0000:00:02.0: power state changed by ACPI to D0
> [ 6564.942466] i915 0000:00:02.0: setting latency timer to 64
> [ 6564.997449] firewire_ohci 0000:0d:00.3: irq 45 for MSI/MSI-X
> [ 6564.997785] firewire_core: skipped bus generations, destroying all nodes
> [ 6565.123881] usb 2-1.1: reset full speed USB device number 3 using ehci_hcd
> [ 6565.256738] ata6: SATA link down (SStatus 0 SControl 300)
> [ 6565.256782] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 6565.259348] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [ 6565.259563] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [ 6565.263747] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [ 6565.263990] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [ 6565.265544] ata2.00: configured for UDMA/66
> [ 6565.276723] ata5: SATA link down (SStatus 0 SControl 300)
> [ 6565.439619] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
> [ 6565.439631] sdhci-pci 0000:0d:00.0: setting latency timer to 64
> [ 6565.463009] usb 1-1.2: reset low speed USB device number 3 using ehci_hcd
> [ 6565.496163] firewire_core: rediscovered device fw0
> [ 6565.802321] usb 1-1.3: reset full speed USB device number 4 using ehci_hcd
> [ 6565.951782] usb 1-1.6: reset high speed USB device number 6 using ehci_hcd
> [ 6566.014871] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 6566.021871] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 6566.021877] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 6566.022178] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 6566.022183] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [ 6566.024813] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 6566.024819] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 6566.025080] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 6566.025085] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [ 6566.026327] ata1.00: configured for UDMA/100
> [ 6566.104911] usb 2-1.1.4: reset full speed USB device number 4 using ehci_hcd
> [ 6566.190354] PM: resume of devices complete after 1254.565 msecs
> [ 6566.191321] PM: Finishing wakeup.
> [ 6566.191323] Restarting tasks ... done.
> [ 6566.199706] video LNXVIDEO:00: Restoring backlight state
> [ 6566.661832] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
> [ 6566.661839] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> [ 6566.662160] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [ 6568.525731] e1000e 0000:00:19.0: PME# enabled
> [ 6568.551863] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf2600000-0xf261ffff] (PCI address [0xf2600000-0xf261ffff])
> [ 6568.551876] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf2625000-0xf2625fff] (PCI address [0xf2625000-0xf2625fff])
> [ 6568.551886] e1000e 0000:00:19.0: BAR 2: set to [io  0x1820-0x183f] (PCI address [0x1820-0x183f])
> [ 6568.551909] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [ 6568.551936] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> [ 6568.551999] e1000e 0000:00:19.0: PME# disabled
> [ 6568.645183] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6568.698271] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6568.699163] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 6568.814811] e1000e 0000:00:19.0: PME# enabled
> [ 6568.844535] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf2600000-0xf261ffff] (PCI address [0xf2600000-0xf261ffff])
> [ 6568.844548] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf2625000-0xf2625fff] (PCI address [0xf2625000-0xf2625fff])
> [ 6568.844558] e1000e 0000:00:19.0: BAR 2: set to [io  0x1820-0x183f] (PCI address [0x1820-0x183f])
> [ 6568.844580] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [ 6568.844607] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
> [ 6568.844668] e1000e 0000:00:19.0: PME# disabled
> [ 6568.937809] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6568.990871] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6568.991756] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 6569.991674] ------------[ cut here ]------------
> [ 6569.991694] WARNING: at drivers/net/e1000e/netdev.c:5221 __e1000_shutdown+0x43f/0x4c0 [e1000e]()
> [ 6569.991698] Hardware name: 4384GJG
> [ 6569.991699] Modules linked in: snd_seq snd_seq_device aesni_intel cryptd aes_x86_64 aes_generic ipv6 uvcvideo videodev media v4l2_compat_ioctl32 usbhid hid snd_hda_codec_hdmi btusb bluetooth snd_hda_codec_conexant arc4 ecb snd_hda_intel snd_hda_codec snd_hwdep e1000e i915 snd_pcm iwlagn ehci_hcd snd_timer drm_kms_helper usbcore snd_page_alloc sdhci_pci sdhci pcspkr mmc_core sg drm vboxnetadp vboxnetflt evdev tpm_tis i2c_algo_bit mac80211 serio_raw psmouse iTCO_wdt vboxdrv firewire_ohci firewire_core i2c_i801 crc_itu_t i2c_core iTCO_vendor_support cfg80211 battery thermal intel_ips wmi tpm intel_agp video ac tpm_bios button intel_gtt cpufreq_ondemand msr acpi_cpufreq freq_table processor mperf thinkpad_acpi rfkill snd soundcore nvram ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ahci libahci libata scsi_mod
> [ 6569.991778] Pid: 7847, comm: kworker/1:0 Not tainted 2.6.39-ARCH #1
> [ 6569.991781] Call Trace:
> [ 6569.991792]  [<ffffffff8105b90f>] warn_slowpath_common+0x7f/0xc0
> [ 6569.991797]  [<ffffffff8105b96a>] warn_slowpath_null+0x1a/0x20
> [ 6569.991804]  [<ffffffffa064df7f>] __e1000_shutdown+0x43f/0x4c0 [e1000e]
> [ 6569.991816]  [<ffffffff81012fc9>] ? sched_clock+0x9/0x10
> [ 6569.991819]  [<ffffffffa064e039>] e1000_runtime_suspend+0x39/0x50 [e1000e]
> [ 6569.991823]  [<ffffffff8100a6cf>] ? __switch_to+0xbf/0x2f0
> [ 6569.991828]  [<ffffffff812392dd>] pci_pm_runtime_suspend+0x4d/0x100
> [ 6569.991830]  [<ffffffff81239290>] ? pci_legacy_suspend_late+0x100/0x100
> [ 6569.991834]  [<ffffffff812e7d52>] rpm_callback+0x42/0x80
> [ 6569.991837]  [<ffffffff813e4faf>] ? schedule+0x33f/0xad0
> [ 6569.991839]  [<ffffffff812e82fa>] rpm_suspend+0x1da/0x3f0
> [ 6569.991843]  [<ffffffff8107701c>] ? queue_delayed_work_on+0xbc/0x150
> [ 6569.991846]  [<ffffffff812e9380>] ? pm_schedule_suspend+0xe0/0xe0
> [ 6569.991848]  [<ffffffff812e941a>] pm_runtime_work+0x9a/0xc0
> [ 6569.991850]  [<ffffffff81077f6e>] process_one_work+0x11e/0x4c0
> [ 6569.991852]  [<ffffffff810788ff>] worker_thread+0x15f/0x350
> [ 6569.991854]  [<ffffffff810787a0>] ? manage_workers.isra.29+0x230/0x230
> [ 6569.991857]  [<ffffffff8107d6ec>] kthread+0x8c/0xa0
> [ 6569.991860]  [<ffffffff813e9fe4>] kernel_thread_helper+0x4/0x10
> [ 6569.991862]  [<ffffffff8107d660>] ? kthread_worker_fn+0x190/0x190
> [ 6569.991864]  [<ffffffff813e9fe0>] ? gs_change+0x13/0x13
> [ 6569.991865] ---[ end trace c54917cde5791882 ]---
> [ 6570.221032] e1000e 0000:00:19.0: PME# enabled
> [ 6570.464118] EXT4-fs (sda3): re-mounted. Opts: commit=0
> [ 6570.466279] EXT4-fs (sda1): re-mounted. Opts: commit=0
> [ 6570.644945] EXT4-fs (sda4): re-mounted. Opts: commit=0
> [ 6571.823780] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf2600000-0xf261ffff] (PCI address [0xf2600000-0xf261ffff])
> [ 6571.823791] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf2625000-0xf2625fff] (PCI address [0xf2625000-0xf2625fff])
> [ 6571.823800] e1000e 0000:00:19.0: BAR 2: set to [io  0x1820-0x183f] (PCI address [0x1820-0x183f])
> [ 6571.823821] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [ 6571.823847] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> [ 6571.823885] e1000e 0000:00:19.0: PME# disabled
> [ 6571.823965] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
> [ 6571.826445] e1000e 0000:00:19.0: eth0: PHY Wakeup cause - Link Status  Change
> [ 6573.521494] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
> [ 6573.521500] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> [ 6573.521814] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> The kernel is still the same 2.6.39.3
> 
> Hope that helps.
> 
> I'll keep trying to reproduce the crash - will probably build a 3.0.1 with 
> lots of debug options enabled and try to reproduce with that.
> 
> 

Just happened again, this time with 3.0.1 :

[30377.372749] ------------[ cut here ]------------
[30377.372779] WARNING: at drivers/net/e1000e/netdev.c:5235 __e1000_shutdown+0x43f/0x4c0 [e1000e]()
[30377.372783] Hardware name: 4384GJG
[30377.372786] Modules linked in: vboxnetadp vboxnetflt vboxdrv appletalk ipx p8022 psnap llc p8023 ipv6 snd_hda_codec_hdmi snd_hda_codec_conexant uvcvideo videodev media v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cpufreq_ondemand serio_raw arc4 snd_timer snd_page_alloc psmouse i915 drm_kms_helper sg msr drm acpi_cpufreq iwlagn i2c_algo_bit mac80211 freq_table video evdev e1000e firewire_ohci i2c_i801 battery mxm_wmi i2c_core cfg80211 mei(C) tpm_tis firewire_core iTCO_wdt ac iTCO_vendor_support tpm intel_agp crc_itu_t sdhci_pci sdhci mmc_core intel_ips intel_gtt tpm_bios thermal pcspkr wmi mperf processor button thinkpad_acpi rfkill snd soundcore nvram ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod usbhid hid ahci libahci libata ehci_hcd scsi_mod usbcore [last unloaded: vboxdrv]
[30377.372876] Pid: 17558, comm: kworker/1:0 Tainted: G         C  3.0-ARCH #1
[30377.372879] Call Trace:
[30377.372895]  [<ffffffff8105c7bf>] warn_slowpath_common+0x7f/0xc0
[30377.372898]  [<ffffffff8105c81a>] warn_slowpath_null+0x1a/0x20
[30377.372902]  [<ffffffffa02603cf>] __e1000_shutdown+0x43f/0x4c0 [e1000e]
[30377.372906]  [<ffffffffa0260489>] e1000_runtime_suspend+0x39/0x50 [e1000e]
[30377.372911]  [<ffffffff81240b9d>] pci_pm_runtime_suspend+0x4d/0x100
[30377.372913]  [<ffffffff81240b50>] ? pci_legacy_suspend_late+0x100/0x100
[30377.372918]  [<ffffffff812f26e2>] rpm_callback+0x42/0x80
[30377.372920]  [<ffffffff812f2c7c>] rpm_suspend+0x1cc/0x3e0
[30377.372922]  [<ffffffff812f3c80>] ? pm_schedule_suspend+0xe0/0xe0
[30377.372925]  [<ffffffff812f3d1a>] pm_runtime_work+0x9a/0xc0
[30377.372929]  [<ffffffff81079576>] process_one_work+0x116/0x4d0
[30377.372932]  [<ffffffff81079f1f>] worker_thread+0x15f/0x350
[30377.372934]  [<ffffffff81079dc0>] ? manage_workers.isra.29+0x230/0x230
[30377.372936]  [<ffffffff8107ed2c>] kthread+0x8c/0xa0
[30377.372940]  [<ffffffff813f4ea4>] kernel_thread_helper+0x4/0x10
[30377.372942]  [<ffffffff8107eca0>] ? kthread_worker_fn+0x190/0x190
[30377.372947]  [<ffffffff813f4ea0>] ? gs_change+0x13/0x13
[30377.372949] ---[ end trace 91bf31e3c70d5224 ]---
[30377.672896] e1000e 0000:00:19.0: PME# enabled
[30379.316301] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf2600000-0xf261ffff] (PCI address [0xf2600000-0xf261ffff])
[30379.316308] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf2625000-0xf2625fff] (PCI address [0xf2625000-0xf2625fff])
[30379.316313] e1000e 0000:00:19.0: BAR 2: set to [io  0x1820-0x183f] (PCI address [0x1820-0x183f])
[30379.316337] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[30379.316358] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[30379.316391] e1000e 0000:00:19.0: PME# disabled
[30379.316463] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[30379.318956] e1000e 0000:00:19.0: eth0: PHY Wakeup cause - Link Status  Change

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

