Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab0COQTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:19:22 -0400
Received: from kroah.org ([198.145.64.141]:34699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965349Ab0COQS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:18:59 -0400
Date: Mon, 15 Mar 2010 09:18:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.1
Message-ID: <20100315161835.GC22091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.1 kernel.

All users of the 2.6.33 kernel series should upgrade.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt     |    7 
 Documentation/laptops/thinkpad-acpi.txt |    4 
 Makefile                                |    2 
 arch/Kconfig                            |    2 
 arch/x86/ia32/ia32_aout.c               |    1 
 arch/x86/include/asm/io_apic.h          |    1 
 arch/x86/include/asm/pgalloc.h          |    5 
 arch/x86/include/asm/uv/uv_hub.h        |    3 
 arch/x86/include/asm/vmx.h              |    1 
 arch/x86/kernel/acpi/boot.c             |    9 
 arch/x86/kernel/apic/io_apic.c          |   68 +-
 arch/x86/kernel/reboot.c                |    8 
 arch/x86/kvm/emulate.c                  |   55 +
 arch/x86/kvm/vmx.c                      |   10 
 arch/x86/mm/pgtable.c                   |   31 -
 arch/x86/oprofile/nmi_int.c             |   17 
 arch/x86/oprofile/op_model_amd.c        |   42 -
 arch/x86/oprofile/op_model_p4.c         |    6 
 arch/x86/oprofile/op_model_ppro.c       |    6 
 arch/x86/pci/mmconfig-shared.c          |   17 
 arch/x86/xen/enlighten.c                |    7 
 arch/x86/xen/mmu.c                      |   11 
 drivers/ata/ahci.c                      |   12 
 drivers/ata/pata_hpt3x2n.c              |   20 
 drivers/base/core.c                     |   13 
 drivers/base/devtmpfs.c                 |   13 
 drivers/char/tty_ldisc.c                |   50 +
 drivers/clocksource/sh_cmt.c            |   32 -
 drivers/clocksource/sh_mtu2.c           |    6 
 drivers/clocksource/sh_tmu.c            |    6 
 drivers/gpio/cs5535-gpio.c              |    4 
 drivers/gpio/wm831x-gpio.c              |   22 
 drivers/gpu/drm/i915/intel_lvds.c       |    7 
 drivers/gpu/drm/i915/intel_sdvo.c       |   23 
 drivers/gpu/drm/radeon/atom.c           |    4 
 drivers/gpu/drm/ttm/ttm_tt.c            |   18 
 drivers/hid/hid-core.c                  |    2 
 drivers/hid/hid-ids.h                   |    4 
 drivers/hid/usbhid/hid-core.c           |   28 
 drivers/hid/usbhid/usbhid.h             |    2 
 drivers/hwmon/ams/ams-core.c            |   11 
 drivers/hwmon/ams/ams-i2c.c             |    2 
 drivers/hwmon/ams/ams-pmu.c             |    2 
 drivers/hwmon/ams/ams.h                 |    1 
 drivers/hwmon/fschmd.c                  |   15 
 drivers/hwmon/tmp401.c                  |    7 
 drivers/hwmon/tmp421.c                  |   24 
 drivers/macintosh/therm_adt746x.c       |   34 -
 drivers/md/dm-ioctl.c                   |    9 
 drivers/md/dm.c                         |    4 
 drivers/media/dvb/dvb-core/dvb_net.c    |    1 
 drivers/media/video/gspca/mr97310a.c    |    6 
 drivers/media/video/soc_mediabus.c      |    3 
 drivers/mmc/host/s3cmci.c               |    4 
 drivers/net/wireless/airo.c             |   34 -
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 
 drivers/net/wireless/ath/ath5k/base.c   |   26 
 drivers/net/wireless/ath/ath9k/beacon.c |    9 
 drivers/net/wireless/ath/ath9k/hw.c     |   10 
 drivers/net/wireless/ath/ath9k/main.c   |    6 
 drivers/net/wireless/ath/ath9k/phy.h    |    3 
 drivers/net/wireless/ath/ath9k/rc.c     |   15 
 drivers/net/wireless/b43/main.c         |    3 
 drivers/net/wireless/b43legacy/main.c   |    2 
 drivers/net/wireless/p54/p54pci.c       |   18 
 drivers/net/wireless/p54/p54usb.c       |    1 
 drivers/pci/hotplug/ibmphp_ebda.c       |   13 
 drivers/platform/x86/Kconfig            |   10 
 drivers/platform/x86/eeepc-laptop.c     |    3 
 drivers/platform/x86/thinkpad_acpi.c    |  116 ++--
 drivers/rtc/class.c                     |    1 
 drivers/rtc/rtc-coh901331.c             |    5 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c    |   17 
 drivers/scsi/qla1280.c                  |    4 
 drivers/serial/imx.c                    |    6 
 drivers/staging/Kconfig                 |    2 
 drivers/staging/Makefile                |    1 
 drivers/staging/hv/vmbus_drv.c          |   30 +
 drivers/staging/mimio/Kconfig           |   10 
 drivers/staging/mimio/Makefile          |    1 
 drivers/staging/mimio/mimio.c           |  914 --------------------------------
 drivers/staging/pohmelfs/inode.c        |   20 
 drivers/staging/pohmelfs/netfs.h        |    3 
 drivers/staging/wlan-ng/Kconfig         |    1 
 drivers/usb/core/driver.c               |    4 
 drivers/usb/core/hcd.c                  |    2 
 drivers/usb/core/hcd.h                  |    2 
 drivers/usb/core/hub.c                  |   12 
 drivers/usb/core/usb.c                  |    3 
 drivers/usb/gadget/f_mass_storage.c     |    1 
 drivers/usb/host/ohci-pnx4008.c         |    6 
 drivers/usb/host/uhci-hcd.c             |    1 
 drivers/usb/host/xhci-ext-caps.h        |    7 
 drivers/usb/serial/cp210x.c             |    3 
 drivers/usb/serial/ftdi_sio.c           |    5 
 drivers/usb/serial/ftdi_sio_ids.h       |   15 
 drivers/usb/serial/sierra.c             |   19 
 drivers/usb/storage/unusual_devs.h      |   88 +++
 drivers/video/sunxvr500.c               |    1 
 fs/file_table.c                         |    2 
 fs/nfs/dns_resolve.c                    |   18 
 fs/nfsd/nfs4state.c                     |    2 
 fs/ocfs2/aops.c                         |    5 
 fs/sysfs/dir.c                          |   82 ++
 include/linux/fs.h                      |    3 
 include/linux/irq.h                     |    2 
 include/linux/netdevice.h               |    2 
 include/linux/perf_event.h              |    5 
 include/linux/sched.h                   |    5 
 include/linux/skbuff.h                  |   13 
 include/linux/syscalls.h                |    6 
 include/trace/ftrace.h                  |    3 
 kernel/irq/chip.c                       |   52 +
 kernel/perf_event.c                     |  134 +++-
 kernel/power/snapshot.c                 |    2 
 kernel/sched.c                          |   21 
 kernel/trace/trace.h                    |    3 
 mm/fadvise.c                            |   10 
 mm/readahead.c                          |    6 
 mm/slab.c                               |    6 
 net/core/scm.c                          |    2 
 net/mac80211/agg-tx.c                   |    3 
 net/mac80211/rx.c                       |    8 
 net/mac80211/tx.c                       |    5 
 net/netfilter/xt_recent.c               |    4 
 net/sunrpc/svc_xprt.c                   |    5 
 net/sunrpc/xprtsock.c                   |    5 
 scripts/get_maintainer.pl               |    4 
 security/integrity/ima/ima_iint.c       |    3 
 security/selinux/ss/ebitmap.c           |    2 
 sound/core/pcm_native.c                 |    8 
 sound/pci/hda/hda_intel.c               |    3 
 sound/pci/hda/patch_analog.c            |    2 
 sound/pci/via82xx.c                     |    6 
 sound/soc/codecs/ak4104.c               |    6 
 sound/usb/usbaudio.c                    |   32 +
 sound/usb/usbmidi.c                     |   24 
 sound/usb/usbquirks.h                   |   27 
 tools/perf/util/symbol.c                |    2 
 139 files changed, 1281 insertions(+), 1408 deletions(-)

Aaro Koskinen (1):
      rtc-core: fix memory leak

Alan Cox (2):
      tty: Fix the ldisc hangup race
      USB: cp210x: Add 81E8 (Zephyr Bioharness)

Alan Jenkins (1):
      eeepc-laptop: disable wireless hotplug for 1005PE

Alan Stern (2):
      USB: fix the idProduct value for USB-3.0 root hubs
      USB: remove debugging message for uevent constructions

Alex Deucher (1):
      drm/radeon/kms/atom: fix shr/shl ops

Andrew Morton (1):
      PCI hotplug: check ioremap() return value in ibmphp_ebda.c

Ang Way Chuang (1):
      dvb-core: Fix DoS bug in ULE decapsulation code that can be triggered by an invalid Payload Pointer

Baruch Siach (2):
      V4L/DVB: v4l: soc_camera: fix bound checking of mbus_fmt[] index
      serial: imx: fix NULL dereference Oops when pdata == NULL

Ben Gardner (1):
      gpio: cs5535-gpio: fix input direction

Ben Hutchings (2):
      SCSI: qla1280: Drop host_lock while requesting firmware
      sunxvr500: Additional PCI id for sunxvr500 driver

Bob Copeland (1):
      ath5k: use correct packet type when transmitting

Brandon Phiilps (1):
      x86: Avoid race condition in pci_enable_msix()

Chandru (1):
      PCI hotplug: ibmphp: read the length of ebda and map entire ebda region

Christian Lamparter (1):
      p54pci: handle dma mapping errors

Clemens Ladisch (2):
      ALSA: via82xx: add quirk for D1289 motherboard
      ALSA: usb-audio: reduce MIDI packet size to work around broken firmware

Daniel Mack (1):
      ASoC: fix ak4104 register array access

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Daniel T Chen (3):
      ALSA: hda: Use 3stack quirk for Toshiba Satellite L40-10Q
      ALSA: hda: Use LPIB for Dell Latitude 131L
      ALSA: hda: Use LPIB for a Biostar Microtech board

Edward Shao (1):
      USB: xhci: Fix finding extended capabilities registers

Elina Pasheva (1):
      USB: serial: sierra driver indat_callback fix

Eric W. Biederman (2):
      sysfs: Cache the last sysfs_dirent to improve readdir scalability v2
      scm: Only support SCM_RIGHTS on unix domain sockets.

Felix Fietkau (5):
      skbuff: align sk_buff::cb to 64 bit and close some potential holes
      ath9k: fix beacon timer restart after a card reset
      ath9k: fix rate control fallback rate selection
      ath9k: disable RIFS search for AR91xx based chips
      mac80211: do not transmit frames on unconfigured 4-addr vlan interfaces

Gleb Natapov (4):
      KVM: x86 emulator: Add group8 instruction decoding
      KVM: x86 emulator: Forbid modifying CS segment register by mov instruction
      KVM: x86 emulator: Add group9 instruction decoding
      KVM: x86 emulator: Check CPL level during privilege instruction emulation

Greg Kroah-Hartman (4):
      Staging: hv: add a pci device table
      Staging: hv: match on DMI values to know if we should run.
      Staging: mimio: remove the mimio driver
      Linux 2.6.33.1

Haicheng Li (1):
      slab: initialize unused alien cache entry as NULL at alloc_alien_cache().

Henrique de Moraes Holschuh (7):
      thinkpad-acpi: fix ALSA callback return status
      thinkpad-acpi: fix poll thread auto-start
      thinkpad-acpi: R52 brightness_mode has been confirmed
      thinkpad-acpi: document HKEY event 3006
      thinkpad-acpi: make driver events work in NVRAM poll mode
      thinkpad-acpi: fix bluetooth/wwan resume
      thinkpad-acpi: lock down video output state access

Herbert Xu (1):
      USB: Move hcd free_dev call into usb_disconnect to fix oops

Ian Campbell (2):
      x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
      x86, mm: Allow highmem user page tables to be disabled at boot time

Jack Steiner (1):
      x86, uv: uv_global_gru_mmr_address() macro fix

James Hogan (1):
      rtc-coh901331: fix braces in resume code

Jan Dumon (1):
      USB: unusual_devs: Add support for multiple Option 3G sticks

Jaroslav Kysela (1):
      ALSA: pcm core - fix fifo_size channels interval check

Jean Delvare (5):
      macintosh/therm_adt746x: Fix sysfs attributes lifetime
      macintosh/hwmon/ams: Fix device removal sequence
      hwmon: (tmp421) Fix temperature conversions
      hwmon: (tmp421) Restore missing inputs
      hwmon: Fix off-by-one kind values

Jean-François Moine (1):
      p54usb: Add the USB ID for Belkin (Accton) FD7050E ver 1010ec

Jeff Mahoney (1):
      tracing: Fix ftrace_event_call alignment for use with gcc 4.5

Jens Axboe (1):
      Staging: Fixed pohmelfs regression because of per-bdi writeback.

Jesse Barnes (1):
      drm/i915: give up on 8xx lid status

Jiri Kosina (1):
      HID: remove TENX iBuddy from blacklist

Jiri Slaby (1):
      x86, ia32_aout: do not kill argument mapping

Joe Perches (1):
      scripts/get_maintainer.pl: fix possible infinite loop

John W. Linville (1):
      netdevice.h: check for CONFIG_WLAN instead of CONFIG_WLAN_80211

Joshua Roys (1):
      netlabel: fix export of SELinux categories > 127

Justin P. Mattock (1):
      x86: Add iMac9,1 to pci_reboot_dmi_table

Kashyap, Desai (1):
      mpt2sas: Delete volume before HBA detach.

Kay Sievers (1):
      Driver-Core: devtmpfs - reset inode permissions before unlinking

Larry Finger (1):
      b43/b43legacy: Wake queues in wireless_core_start

Lars-Peter Clausen (2):
      s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
      s3cmci: initialize default platform data no_wprotect and no_detect with 1

Luis R. Rodriguez (1):
      ath9k: re-enable ps by default for new single chip families

Luotao Fu (1):
      USB: fix I2C API usage in ohci-pnx4008.

Maarten Maathuis (1):
      drm/ttm: handle OOM in ttm_tt_swapout

Mark Brown (1):
      gpiolib: Actually set output state in wm831x_gpio_direction_output()

Mike Snitzer (1):
      dm ioctl: only issue uevent on resume if state changed

Mikulas Patocka (1):
      dm: free dm_io before bio_endio not after

Ming Lei (1):
      ath9k: fix keycache leak in split tkip case

Mitchell Solomon (1):
      USB: add new ftdi_sio device ids

Neil Brown (1):
      sunrpc: remove unnecessary svc_xprt_put

Oliver Neukum (1):
      HID: usbhid: introduce timeout for stuck ctrl/out URBs

Paul Menzel (1):
      ALSA: hda-intel: Add position_fix quirk for ASUS M2V-MX SE.

Paul Mundt (1):
      clocksource: Fix up a registration/IRQ race in the sh drivers.

Pete Zaitcev (1):
      USB: fix crash in uhci_scan_schedule

Peter Huewe (1):
      Staging: wlan-ng: Add select WEXT_PRIV to Kconfig to prevent build failure

Peter Korsgaard (1):
      USB: f_mass_storage: fix crash on bind() error

Peter Zijlstra (2):
      perf_event: Fix preempt warning in perf_clock()
      perf: Reimplement frequency driven sampling

Rafael J. Wysocki (1):
      PM / Hibernate: Fix preallocating of memory

Robert Hancock (1):
      ahci: disable FPDMA auto-activate optimization on NVIDIA AHCI

Robert Richter (5):
      oprofile/x86: fix perfctr nmi reservation for mulitplexing
      oprofile: remove tracing build dependency
      oprofile/x86: remove node check in AMD IBS initialization
      oprofile/x86: use kzalloc() instead of kmalloc()
      oprofile/x86: fix msr access to reserved counters

Sebastien Alaiwan (1):
      ALSA: USB MIDI support for Access Music VirusTI

Sergei Shtylyov (1):
      pata_hpt3x2n: always stretch UltraDMA timing

Sheng Yang (1):
      KVM: VMX: Trap and invalid MWAIT/MONITOR instruction

Stanislaw Gruszka (1):
      airo: fix setting zero length WEP key

Suresh Siddha (1):
      sched: Fix SMT scheduler regression in find_busiest_queue()

Tao Ma (1):
      ocfs2: Only bug out in direct io write for reflinked extent.

Tejun Heo (1):
      driver-core: fix race condition in get_device_parent()

Theodore Kilgore (1):
      V4L/DVB (13991): gspca_mr973010a: Fix cif type 1 cameras not streaming on UHCI controllers

Thomas Gleixner (2):
      x86/PCI: Prevent mmconfig memory corruption
      sched: Don't use possibly stale sched_class

Tim Gardner (2):
      netfilter: xt_recent: fix buffer overflow
      netfilter: xt_recent: fix false match

Trond Myklebust (2):
      SUNRPC: Handle EINVAL error returns from the TCP connect operation
      NFS: Fix an allocation-under-spinlock bug

Vaidyanathan Srinivasan (1):
      sched: Fix sched_mv_power_savings for !SMT

Vivek Natarajan (1):
      mac80211: Reset dynamic ps timer in Rx path.

Wu Fengguang (2):
      readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
      vfs: take f_lock on modifying f_mode after open time

Xiaotian Feng (1):
      security: fix error return path in ima_inode_alloc

Yinghai Lu (1):
      x86: Fix SCI on IOAPIC != 0

Zhang, Yanmin (1):
      perf symbols: Check the right return variable

Zhao Yakui (1):
      drm/i915: Use a dmi quirk to skip a broken SDVO TV output.

Zhu Yi (1):
      mac80211: quit addba_resp_timer if Tx BA session is torn down

