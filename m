Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1IXVqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 17:46:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1IXVq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 17:46:29 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.1.0-rc5-00039-g79016f6: suspends to ram and resumes immediately [ 3.1.0-rc7-00041-gb172e38, too]
Date: Sat, 24 Sep 2011 23:46:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc7-00041-gb172e38-dirty; KDE/4.7.1; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
References: <201109101037.11507.a.miskiewicz@gmail.com>
In-Reply-To: <201109101037.11507.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109242346.21882.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 of September 2011, Arkadiusz Miśkiewicz wrote:
> For some time (not sure when it started) sometimes when trying
> to suspend to ram it starts suspending and immediately resumes.
> Then I make second try and it suspends permamently.
> 
> Sometimes it suspends fine at first try. Sometimes only at second
> try. Never had to retry more than once.
> 
> 3.1.0-rc5-00039-g79016f6
> 
> dmesg from suspend which resummed immediately - no idea why

3.1.0-rc7-00041-gb172e38 isn't any better:

[32755.040994] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[32755.040996] PM: Device 00:0a failed to resume: error -19

so which device is that? Second try succeeds.

Googling gives some hints about itpm option for tpm_tis... while trying to 
rmmod/modprobe it I got problem below. Anyway that shouldn't be itpm issue 
since:
[    7.088318] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[    7.088320] tpm_tis 00:0a: Intel iTPM workaround enabled
so it is enabled already.

[33272.625173] BUG: scheduling while atomic: rmmod/12735/0x00000002
[33272.625179] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack iptable_filter ip_tables x_tables tun rfcomm bnep 
sch_sfq ipv6 ext2 mbcache md_mod acpi_cpufreq mperf ecb btusb bluetooth crc16 
hid_logitech_dj usbhid hid cdc_ether usbnet mii cdc_acm cdc_wdm joydev 
uvcvideo videodev v4l2_compat_ioctl32 media snd_hda_codec_conexant arc4 pcmcia 
sr_mod thinkpad_acpi uhci_hcd cdrom sg nvram battery ac tpm_tis(-) tpm 
tpm_bios iwlagn wmi mac80211 firewire_ohci sdhci_pci sdhci evdev yenta_socket 
thermal firewire_core mmc_core pcmcia_rsrc psmouse crc_itu_t serio_raw 
pcmcia_core cfg80211 rfkill processor snd_hda_intel snd_hda_codec i2c_i801 
snd_hwdep snd_pcm e1000e pcspkr iTCO_wdt ehci_hcd snd_timer 
iTCO_vendor_support snd usbcore soundcore snd_page_alloc xfs sd_mod crc_t10dif 
cbc cryptd aes_x86_64 aes_generic dm_crypt dm_mod ahci libahci libata scsi_mod 
[last unloaded: scsi_wait_scan]
[33272.625350] Pid: 12735, comm: rmmod Not tainted 3.1.0-rc7-00041-gb172e38-
dirty #109
[33272.625356] Call Trace:
[33272.625371]  [<ffffffff814070df>] __schedule_bug+0x55/0x5a
[33272.625380]  [<ffffffff8140c68d>] __schedule+0xa2/0x9b7
[33272.625392]  [<ffffffff8102ab35>] ? finish_task_switch+0x50/0xb8
[33272.625400]  [<ffffffff8140cf00>] ? __schedule+0x915/0x9b7
[33272.625409]  [<ffffffff81032c65>] ? ttwu_do_wakeup+0x81/0xf7
[33272.625422]  [<ffffffff810344eb>] schedule+0x55/0x57
[33272.625425]  [<ffffffff8140d3e4>] schedule_timeout+0x28/0x29a
[33272.625427]  [<ffffffff8140c42f>] ? wait_for_common+0x12f/0x141
[33272.625430]  [<ffffffff8140c3c3>] wait_for_common+0xc3/0x141
[33272.625433]  [<ffffffff81033dbf>] ? try_to_wake_up+0x250/0x250
[33272.625435]  [<ffffffff8140c459>] wait_for_completion+0x18/0x1a
[33272.625439]  [<ffffffff8108bd5f>] synchronize_rcu+0x49/0x4b
[33272.625443]  [<ffffffff810529b4>] ? find_ge_pid+0x3d/0x3d
[33272.625448]  [<ffffffffa0271187>] tpm_remove_hardware+0x6d/0xa3 [tpm]
[33272.625454]  [<ffffffffa02dc2b1>] cleanup_tis+0x3f/0xd8e [tpm_tis]
[33272.625458]  [<ffffffff8106a779>] sys_delete_module+0x1bf/0x21f
[33272.625462]  [<ffffffff81082d27>] ? audit_syscall_entry+0x179/0x1a5
[33272.625466]  [<ffffffff8140f7fb>] system_call_fastpath+0x16/0x1b
[33272.636109] BUG: scheduling while atomic: rmmod/12735/0x00000002
[33272.636112] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack iptable_filter ip_tables x_tables tun rfcomm bnep 
sch_sfq ipv6 ext2 mbcache md_mod acpi_cpufreq mperf ecb btusb bluetooth crc16 
hid_logitech_dj usbhid hid cdc_ether usbnet mii cdc_acm cdc_wdm joydev 
uvcvideo videodev v4l2_compat_ioctl32 media snd_hda_codec_conexant arc4 pcmcia 
sr_mod thinkpad_acpi uhci_hcd cdrom sg nvram battery ac tpm_tis(-) tpm 
tpm_bios iwlagn wmi mac80211 firewire_ohci sdhci_pci sdhci evdev yenta_socket 
thermal firewire_core mmc_core pcmcia_rsrc psmouse crc_itu_t serio_raw 
pcmcia_core cfg80211 rfkill processor snd_hda_intel snd_hda_codec i2c_i801 
snd_hwdep snd_pcm e1000e pcspkr iTCO_wdt ehci_hcd snd_timer 
iTCO_vendor_support snd usbcore soundcore snd_page_alloc xfs sd_mod crc_t10dif 
cbc cryptd aes_x86_64 aes_generic dm_crypt dm_mod ahci libahci libata scsi_mod 
[last unloaded: scsi_wait_scan]
[33272.636251] Pid: 12735, comm: rmmod Not tainted 3.1.0-rc7-00041-gb172e38-
dirty #109
[33272.636256] Call Trace:
[33272.636270]  [<ffffffff814070df>] __schedule_bug+0x55/0x5a
[33272.636279]  [<ffffffff8140c68d>] __schedule+0xa2/0x9b7
[33272.636290]  [<ffffffff8102ab35>] ? finish_task_switch+0x50/0xb8
[33272.636299]  [<ffffffff81409e5d>] ? __slab_free+0x28a/0x32b
[33272.636307]  [<ffffffff8140cf00>] ? __schedule+0x915/0x9b7
[33272.636316]  [<ffffffff810344eb>] schedule+0x55/0x57
[33272.636324]  [<ffffffff8140d3e4>] schedule_timeout+0x28/0x29a
[33272.636333]  [<ffffffff8140c3c3>] wait_for_common+0xc3/0x141
[33272.636342]  [<ffffffff81033dbf>] ? try_to_wake_up+0x250/0x250
[33272.636350]  [<ffffffff8140c459>] wait_for_completion+0x18/0x1a
[33272.636360]  [<ffffffff8133be34>] devtmpfs_delete_node+0xa2/0xb7
[33272.636371]  [<ffffffff81335a99>] device_del+0x69/0x180
[33272.636379]  [<ffffffff81335bf3>] device_unregister+0x43/0x4f
[33272.636388]  [<ffffffff81335c35>] device_destroy+0x36/0x3d
[33272.636398]  [<ffffffff8121155b>] misc_deregister+0x86/0xa6
[33272.636413]  [<ffffffffa0271193>] tpm_remove_hardware+0x79/0xa3 [tpm]
[33272.636428]  [<ffffffffa02dc2b1>] cleanup_tis+0x3f/0xd8e [tpm_tis]
[33272.636440]  [<ffffffff8106a779>] sys_delete_module+0x1bf/0x21f
[33272.636449]  [<ffffffff81082d27>] ? audit_syscall_entry+0x179/0x1a5
[33272.636460]  [<ffffffff8140f7fb>] system_call_fastpath+0x16/0x1b
[33275.324080] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[33275.324083] tpm_tis 00:0a: Intel iTPM workaround enabled



and here is a log from first try to suspend (before tpm testing):

[32752.666270] PM: Syncing filesystems ... done.
[32753.448253] Freezing user space processes ... (elapsed 0.01 seconds) done.
[32753.464085] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) 
done.
[32753.480164] Suspending console(s) (use no_console_suspend to debug)
[32753.496076] e1000e 0000:00:19.0: BAR 0: set to [mem 0xfc000000-0xfc01ffff] 
(PCI address [0xfc000000-0xfc01ffff])
[32753.496084] e1000e 0000:00:19.0: BAR 1: set to [mem 0xfc025000-0xfc025fff] 
(PCI address [0xfc025000-0xfc025fff])
[32753.496092] e1000e 0000:00:19.0: BAR 2: set to [io  0x1840-0x185f] (PCI 
address [0x1840-0x185f])
[32753.496138] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[32753.496164] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 
0x100000, writing 0x100107)
[32753.496198] e1000e 0000:00:19.0: PME# disabled
[32753.496280] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[32753.753940] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[32753.754011] sd 0:0:0:0: [sda] Stopping disk
[32753.837289] ACPI handle has no context!
[32753.837309] sdhci-pci 0000:15:00.2: PCI INT C disabled
[32753.837321] ACPI handle has no context!
[32753.837407] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[32753.837426] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[32753.837444] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[32753.837460] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[32753.837627] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[32753.837646] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[32753.837668] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[32753.837684] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[32753.844089] ACPI handle has no context!
[32753.852093] i915 0000:00:02.0: power state changed by ACPI to D3
[32753.940381] snd_hda_intel 0000:00:1b.0: PCI INT B disabled
[32753.956089] PM: suspend of devices complete after 362.621 msecs
[32753.988047] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[32753.988200] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[32754.004045] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[32754.004109] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D3
[32754.024045] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[32754.024174] PM: late suspend of devices complete after 68.075 msecs
[32754.026241] ACPI: Preparing to enter system sleep state S3
[32754.184091] PM: Saving platform NVS memory
[32754.194456] Disabling non-boot CPUs ...
[32754.194883] Broke affinity for irq 9
[32754.194894] Broke affinity for irq 12
[32754.194913] Broke affinity for irq 17
[32754.296043] CPU 1 is now offline
[32754.296921] Extended CMOS year: 2000
[32754.296921] ACPI: Low-level resume complete
[32754.296921] PM: Restoring platform NVS memory
[32754.296921] Extended CMOS year: 2000
[32754.296921] Enabling non-boot CPUs ...
[32754.305098] Booting Node 0 Processor 1 APIC 0x1
[32754.305099] smpboot cpu 1: start_ip = 99000
[32754.195998] Calibrating delay loop (skipped) already calibrated this CPU
[32754.195998] Disabled fast string operations
[32754.320119] Switched to NOHz mode on CPU #1
[32754.352561] CPU1 is up
[32754.354423] ACPI: Waking up from system sleep state S3
[32754.960228] i915 0000:00:02.0: restoring config space at offset 0x1 (was 
0x900007, writing 0x900407)
[32754.960287] pci 0000:00:02.1: restoring config space at offset 0x1 (was 
0x900000, writing 0x900007)
[32754.960313] pci 0000:00:03.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[32754.960339] pci 0000:00:03.0: restoring config space at offset 0x1 (was 
0x100006, writing 0x180006)
[32754.988044] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32754.988054] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32754.988101] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.988125] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32754.988132] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32754.988181] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.988207] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32754.988214] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32754.988260] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.988281] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32754.988288] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32754.988347] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[32754.988379] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[32754.988389] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[32754.988451] snd_hda_intel 0000:00:1b.0: restoring config space at offset 
0x1 (was 0x100106, writing 0x100102)
[32754.988515] pcieport 0000:00:1c.0: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc051c041)
[32754.988527] pcieport 0000:00:1c.0: restoring config space at offset 0x8 
(was 0xfff0, writing 0xc030c020)
[32754.988538] pcieport 0000:00:1c.0: restoring config space at offset 0x7 
(was 0xf0, writing 0x9090)
[32754.988560] pcieport 0000:00:1c.0: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[32754.988652] pcieport 0000:00:1c.1: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc011c001)
[32754.988665] pcieport 0000:00:1c.1: restoring config space at offset 0x7 
(was 0x200000f0, writing 0x8080)
[32754.988687] pcieport 0000:00:1c.1: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[32754.988794] pcieport 0000:00:1c.3: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[32754.988900] pcieport 0000:00:1c.4: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[32754.988960] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32754.988968] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32754.989014] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.989035] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32754.989042] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32754.989091] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.989154] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[32754.989227] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[32754.989259] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[32754.989268] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[32754.989449] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 
0x2b00007, writing 0x2b00407)
[32755.004054] firewire_ohci 0000:15:00.1: BAR 0: set to [mem 
0xf4801000-0xf48017ff] (PCI address [0xf4801000-0xf48017ff])
[32755.004107] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x3 (was 0x800000, writing 0x802010)
[32755.004122] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x1 (was 0x2100000, writing 0x2100106)
[32755.020048] sdhci-pci 0000:15:00.2: BAR 0: set to [mem 
0xf4801800-0xf48018ff] (PCI address [0xf4801800-0xf48018ff])
[32755.020100] sdhci-pci 0000:15:00.2: restoring config space at offset 0x3 
(was 0x800000, writing 0x802010)
[32755.020115] sdhci-pci 0000:15:00.2: restoring config space at offset 0x1 
(was 0x2100000, writing 0x2100106)
[32755.021112] PM: early resume of devices complete after 61.034 msecs
[32755.021301] i915 0000:00:02.0: power state changed by ACPI to D0
[32755.021314] i915 0000:00:02.0: power state changed by ACPI to D0
[32755.021333] i915 0000:00:02.0: setting latency timer to 64
[32755.021409] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[32755.023684] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32755.023692] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32755.023708] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[32755.023721] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[32755.023758] usb usb3: root hub lost power or was reset
[32755.023784] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[32755.023796] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[32755.023830] usb usb4: root hub lost power or was reset
[32755.023850] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32755.023857] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32755.023867] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[32755.023879] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[32755.023913] usb usb5: root hub lost power or was reset
[32755.023934] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[32755.023944] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[32755.023957] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[32755.023969] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[32755.024100] snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> 
IRQ 17
[32755.024113] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[32755.024176] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[32755.024340] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32755.024348] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32755.024360] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[32755.024372] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[32755.024407] usb usb6: root hub lost power or was reset
[32755.024440] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[32755.024452] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[32755.024487] usb usb7: root hub lost power or was reset
[32755.024516] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[32755.024528] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[32755.024564] usb usb8: root hub lost power or was reset
[32755.024593] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[32755.024603] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[32755.024616] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[32755.024628] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[32755.024743] pci 0000:00:1e.0: setting latency timer to 64
[32755.024783] ahci 0000:00:1f.2: setting latency timer to 64
[32755.025383] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[32755.025391] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[32755.026471] sd 0:0:0:0: [sda] Starting disk
[32755.040994] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[32755.040996] PM: Device 00:0a failed to resume: error -19
[32755.090456] firewire_core: skipped bus generations, destroying all nodes
[32755.151223] Extended CMOS year: 2000
[32755.344095] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[32755.344139] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32755.346965] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[32755.348084] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[32755.348094] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[32755.352577] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[32755.353679] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[32755.353688] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[32755.354835] ata2.00: configured for UDMA/100
[32755.388131] usb 1-6: reset high speed USB device number 4 using ehci_hcd
[32755.588161] firewire_core: rediscovered device fw0
[32755.600923] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[32755.600933] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[32755.600942] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[32755.632138] usb 4-2: reset full speed USB device number 2 using uhci_hcd
[32755.743029] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[32755.743039] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[32755.743048] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[32755.776358] btusb 4-2:1.0: no reset_resume for driver btusb?
[32755.776365] btusb 4-2:1.1: no reset_resume for driver btusb?
[32755.803032] ata1.00: configured for UDMA/133
[32755.991395] thinkpad_acpi: restoring fan level to 0x07
[32755.991680] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[32755.994676] iwlagn 0000:03:00.0: Radio type=0x0-0x1-0x0
[32756.048470] PM: resume of devices complete after 1027.241 msecs
[32756.049724] Restarting tasks ... 
[32756.049941] usb 2-4: USB disconnect, device number 2
[32756.051617] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' 
usb-0000:00:1d.7-4, Mobile Broadband Network Device
[32756.067371] usb 3-1: USB disconnect, device number 3
[32756.068297] done.
[32756.068306] video LNXVIDEO:00: Restoring backlight state
[32756.480061] usb 3-1: new full speed USB device number 4 using uhci_hcd
[32756.670681] usb 3-1: New USB device found, idVendor=046d, idProduct=c52b
[32756.670684] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[32756.670686] usb 3-1: Product: USB Receiver
[32756.670688] usb 3-1: Manufacturer: Logitech
[32756.683019] logitech-djreceiver 0003:046D:C52B.000B: hiddev0,hidraw0: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input2
[32756.688067] input: Logitech Unifying Device. Wireless PID:1028 as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.2/0003:046D:C52B.000B/input/input16
[32756.688608] logitech-djdevice 0003:046D:C52B.000C: input,hidraw1: USB HID 
v1.11 Mouse [Logitech Unifying Device. Wireless PID:1028] on 
usb-0000:00:1a.0-1:1
[32757.144554] e1000e 0000:00:19.0: PME# enabled
[32760.060117] usb 2-4: new high speed USB device number 3 using ehci_hcd
[32760.977968] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[32760.977977] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[32760.977984] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard 
Composite Device
[32760.977991] usb 2-4: Manufacturer: Ericsson
[32760.977996] usb 2-4: SerialNumber: 3541430228088360
[32761.002694] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[32761.027856] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[32761.047831] cdc_wdm 2-4:1.5: cdc-wdm-175: USB WDM device
[32761.061310] cdc_wdm 2-4:1.6: cdc-wdm-174: USB WDM device
[32761.081401] cdc_ether 2-4:1.7: wwan0: register 'cdc_ether' at 
usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[32761.131203] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[32770.296774] iwlagn 0000:03:00.0: Tx aggregation enabled on ra = 
e0:46:9a:4e:93:25 tid = 0



-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
