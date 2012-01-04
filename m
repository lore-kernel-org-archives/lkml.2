Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2ADNJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 08:09:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49830 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2ADNJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 08:09:43 -0500
MIME-Version: 1.0
From: =?UTF-8?B?TnVtYW4gREVNxLBSRMOWxJ5FTg==?= <numand46@gmail.com>
Date: Wed, 4 Jan 2012 15:09:20 +0200
Message-ID: <CAHa016cp4uNZqCvJW0RZgEXST-VqpVWjYSXGE+RhThXXo6nzCA@mail.gmail.com>
Subject: WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x9b/0xd0()
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been getting this message since I started to use 3.0 series'
kernels. I found this (https://lkml.org/lkml/2011/5/4/516) topic
related to this warning.
Best regards,
  Numan.
---
ver_linux output:

Linux arch 3.1.6-1-ARCH #1 SMP PREEMPT Thu Dec 22 08:52:33 UTC 2011
i686 Intel(R) Pentium(R) M processor 1.73GHz GenuineIntel GNU/Linux
Gnu C                  4.6.2
Gnu make               3.82
binutils               Binutils
util-linux             fdformat
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
xfsprogs               3.1.7
Linux C Library        > libc.2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.16
Procps                 3.2.8
Kbd                    1.15.3
Sh-utils               8.14
Modules Loaded         michael_mic arc4 ecb lib80211_crypt_tkip pcmcia
radeon ttm sdhci_pci sdhci firewire_ohci firewire_core ipw2200 libipw
yenta_socket cfg80211 iTCO_wdt r8169 intel_agp snd_hda_codec_si3054
rfkill pcmcia_rsrc snd_hda_codec_analog psmouse pcmcia_core mmc_core
intel_gtt i2c_i801 mii iTCO_vendor_support crc_itu_t drm_kms_helper
evdev lib80211 battery ac video snd_hda_intel snd_hda_codec drm
snd_hwdep snd_pcm agpgart tifm_7xx1 tifm_core i2c_algo_bit i2c_core
snd_timer snd soundcore snd_page_alloc thermal button cpufreq_ondemand
acpi_cpufreq freq_table processor mperf ext4 mbcache jbd2 crc16 usbhid
hid sr_mod cdrom sd_mod pata_acpi uhci_hcd ahci libahci ata_piix
libata ehci_hcd scsi_mod usbcore

dmesg excerpt:

sdhci-pci 0000:06:09.4: SDHCI controller found [104c:8034] (rev 0)
sdhci-pci 0000:06:09.4: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 _regulator_get: 0000:06:09.4 supply vmmc not found, using dummy regulator
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:06:09.4] using PIO
_regulator_get: 0000:06:09.4 supply vmmc not found, using dummy regulator
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x9b/0xd0()
Hardware name: AMILO Pro V2045
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:06:09.4/microamps_requested_0000:06:09.4-vmmc'
Modules linked in: pcmcia radeon ttm sdhci_pci(+) sdhci firewire_ohci
firewire_core ipw2200 libipw yenta_socket cfg80211 iTCO_wdt r8169
intel_agp snd_hda_codec_si3054 rfkill pcmcia_rsrc snd_hda_codec_analog
psmouse pcmcia_core mmc_core intel_gtt i2c_i801 mii
iTCO_vendor_support crc_itu_t drm_kms_helper evdev lib80211 battery ac
video snd_hda_intel snd_hda_codec drm snd_hwdep snd_pcm agpgart
tifm_7xx1 tifm_core i2c_algo_bit i2c_core snd_timer snd soundcore
snd_page_alloc thermal button cpufreq_ondemand acpi_cpufreq freq_table
processor mperf ext4 mbcache jbd2 crc16 usbhid hid sr_mod cdrom sd_mod
pata_acpi uhci_hcd ahci libahci ata_piix libata ehci_hcd scsi_mod
usbcore
Pid: 315, comm: modprobe Not tainted 3.1.6-1-ARCH #1
Call Trace:
[<c0147182>] warn_slowpath_common+0x72/0xa0
[<c02780db>] ? sysfs_add_one+0x9b/0xd0
[<c02780db>] ? sysfs_add_one+0x9b/0xd0
[<c0147253>] warn_slowpath_fmt+0x33/0x40
[<c02780db>] sysfs_add_one+0x9b/0xd0
[<c02773c9>] sysfs_add_file_mode+0x49/0x90
[<c0277428>] sysfs_add_file+0x18/0x20
[<c02774e1>] sysfs_create_file+0x21/0x30
[<c036ddc8>] device_create_file+0x18/0x20
[<c0341f5f>] create_regulator+0xdf/0x320
[<c0342384>] _regulator_get+0x1e4/0x2a0
[<e26803d0>] ? sdhci_timeout_timer+0xd0/0xd0 [sdhci]
[<c034246f>] regulator_get+0xf/0x20
[<e267e64a>] sdhci_add_host+0x5ea/0xa80 [sdhci]
[<e268ce47>] sdhci_pci_probe+0x31a/0x3d3 [sdhci_pci]
[<c02e782d>] pci_device_probe+0x8d/0x120
[<c0278a27>] ? sysfs_create_link+0x17/0x20
[<c0370da8>] driver_probe_device+0x68/0x170
[<c0370f41>] __driver_attach+0x91/0xa0
[<c0370eb0>] ? driver_probe_device+0x170/0x170
[<c0370009>] bus_for_each_dev+0x49/0x70
[<c0370ac1>] driver_attach+0x21/0x30
[<c0370eb0>] ? driver_probe_device+0x170/0x170
[<c037079f>] bus_add_driver+0x17f/0x260
[<c02e7690>] ? pci_dev_put+0x20/0x20
[<c03713f6>] driver_register+0x66/0x110
[<c02e85c3>] __pci_register_driver+0x43/0xc0
[<e268f017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[<c0101125>] do_one_initcall+0x35/0x170
[<e268f000>] ? 0xe268efff
[<c0180ca5>] sys_init_module+0x905/0x1ac0
[<c046325f>] sysenter_do_call+0x12/0x28
---[ end trace 1b4ccae14fe3a3a3 ]---
create_regulator: dummy: could not add regulator_dev requested
microamps sysfs entry
mmc1: no vmmc regulator found
Registered led device: mmc1::
mmc1: SDHCI controller on PCI [0000:06:09.4] using PIO
_regulator_get: 0000:06:09.4 supply vmmc not found, using dummy regulator
