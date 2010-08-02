Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0HBTE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:04:57 -0400
Received: from kroah.org ([198.145.64.141]:47009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab0HBTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:04:54 -0400
Date: Mon, 2 Aug 2010 12:04:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.7
Message-ID: <20100802190426.GE17098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.7 kernel.

All users of the 2.6.33 kernel series should upgrade.

This is the last 2.6.33 release, so everyone should be moved to the .34
kernel at this point in time, hopefully the .35 kernel instead of .34 as
.34 is not going to be maintained for much longer.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/kernel/kprobes-decode.c                |    5 
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   17 ++
 arch/arm/mach-realview/Kconfig                  |    2 
 arch/arm/mach-realview/include/mach/barriers.h  |    8 +
 arch/ia64/mm/tlb.c                              |    2 
 arch/mips/include/asm/mipsregs.h                |    9 +
 arch/mips/math-emu/cp1emu.c                     |   15 +-
 arch/powerpc/include/asm/cpm.h                  |   24 +++
 arch/powerpc/kernel/irq.c                       |    5 
 arch/powerpc/sysdev/micropatch.c                |   12 +
 arch/sparc/include/asm/stat.h                   |    4 
 arch/x86/include/asm/msr-index.h                |    1 
 arch/x86/include/asm/suspend_32.h               |    2 
 arch/x86/include/asm/suspend_64.h               |    2 
 arch/x86/include/asm/system.h                   |    2 
 arch/x86/kernel/acpi/cstate.c                   |    9 +
 arch/x86/kernel/acpi/sleep.c                    |    2 
 arch/x86/kernel/apic/apic.c                     |    2 
 arch/x86/kernel/hpet.c                          |    2 
 arch/x86/kernel/pci-calgary_64.c                |   17 +-
 arch/x86/kernel/traps.c                         |   11 +
 arch/x86/kvm/mmu.c                              |    5 
 arch/x86/kvm/svm.c                              |   96 ++++++++++++++
 arch/x86/power/cpu.c                            |    4 
 block/cfq-iosched.c                             |   13 +
 drivers/acpi/processor_idle.c                   |    2 
 drivers/acpi/sleep.c                            |  157 ------------------------
 drivers/ata/ahci.c                              |   10 +
 drivers/ata/ata_generic.c                       |    6 
 drivers/base/firmware_class.c                   |   26 +++
 drivers/char/agp/amd64-agp.c                    |   27 ++--
 drivers/char/tpm/tpm.h                          |    1 
 drivers/char/tpm/tpm_tis.c                      |    9 +
 drivers/cpufreq/cpufreq.c                       |   11 -
 drivers/edac/Kconfig                            |    2 
 drivers/edac/amd64_edac.c                       |   24 +--
 drivers/gpu/drm/i915/i915_drv.c                 |    1 
 drivers/gpu/drm/i915/i915_gem.c                 |   13 +
 drivers/gpu/drm/i915/i915_reg.h                 |   64 +++++++++
 drivers/gpu/drm/i915/intel_display.c            |    4 
 drivers/gpu/drm/radeon/r100.c                   |   61 +++++----
 drivers/gpu/drm/radeon/r200.c                   |    5 
 drivers/gpu/drm/radeon/r300.c                   |    5 
 drivers/gpu/drm/radeon/radeon_atombios.c        |   20 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c      |   27 +---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 
 drivers/gpu/drm/radeon/radeon_legacy_tv.c       |    4 
 drivers/hwmon/coretemp.c                        |   32 ++++
 drivers/hwmon/it87.c                            |   22 +++
 drivers/hwmon/k10temp.c                         |   14 +-
 drivers/hwmon/k8temp.c                          |   12 +
 drivers/ide/cmd640.c                            |    6 
 drivers/ide/ide-taskfile.c                      |    6 
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |    4 
 drivers/input/keyboard/twl4030_keypad.c         |   17 +-
 drivers/input/serio/i8042-x86ia64io.h           |    7 +
 drivers/md/raid10.c                             |   12 -
 drivers/media/dvb/dvb-core/dvb_net.c            |   12 +
 drivers/media/dvb/ttpci/Kconfig                 |    5 
 drivers/media/video/cx23885/cx23885-i2c.c       |   12 +
 drivers/media/video/cx88/cx88-i2c.c             |   16 ++
 drivers/media/video/uvc/uvc_driver.c            |   30 ++++
 drivers/media/video/uvc/uvcvideo.h              |    7 -
 drivers/mmc/host/sdhci-s3c.c                    |   20 +++
 drivers/net/3c503.c                             |   42 ++++--
 drivers/net/cpmac.c                             |    3 
 drivers/net/cxgb3/ael1002.c                     |    2 
 drivers/net/dm9000.c                            |   38 ++++-
 drivers/net/forcedeth.c                         |    2 
 drivers/net/r8169.c                             |   11 +
 drivers/net/sky2.c                              |   19 ++
 drivers/net/usb/pegasus.h                       |    2 
 drivers/net/veth.c                              |    1 
 drivers/net/wireless/ath/ath5k/attach.c         |    1 
 drivers/net/wireless/ath/ath5k/base.c           |    7 -
 drivers/net/wireless/ath/ath9k/initvals.h       |    8 -
 drivers/net/wireless/hostap/hostap_cs.c         |   15 +-
 drivers/net/wireless/hostap/hostap_hw.c         |   13 +
 drivers/net/wireless/hostap/hostap_wlan.h       |    2 
 drivers/net/wireless/iwlwifi/iwl-scan.c         |    1 
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    5 
 drivers/net/wireless/libertas/if_sdio.c         |   22 +++
 drivers/net/wireless/p54/p54pci.c               |    2 
 drivers/rtc/rtc-ds1307.c                        |    4 
 drivers/scsi/aacraid/commctrl.c                 |    4 
 drivers/serial/cpm_uart/cpm_uart_core.c         |  143 ++++++++++++---------
 drivers/spi/spi_mpc8xxx.c                       |   22 ---
 drivers/ssb/driver_chipcommon.c                 |    3 
 drivers/ssb/driver_chipcommon_pmu.c             |   17 +-
 drivers/ssb/pci.c                               |   46 ++++++-
 drivers/ssb/sprom.c                             |   15 ++
 drivers/staging/rtl8192su/r8192U_core.c         |    1 
 drivers/usb/core/driver.c                       |   15 --
 drivers/usb/core/quirks.c                       |    7 +
 drivers/usb/gadget/u_serial.c                   |   16 --
 drivers/usb/host/ehci-mxc.c                     |   13 +
 drivers/usb/misc/sisusbvga/sisusb.c             |    5 
 drivers/usb/serial/ftdi_sio.c                   |    9 +
 drivers/usb/serial/ftdi_sio_ids.h               |   15 ++
 drivers/usb/serial/option.c                     |    4 
 drivers/usb/serial/sierra.c                     |    1 
 fs/btrfs/ioctl.c                                |    4 
 fs/cifs/cifsfs.c                                |    6 
 fs/cifs/dns_resolve.c                           |   69 ++++++++++
 fs/cifs/dns_resolve.h                           |    4 
 fs/cifs/inode.c                                 |    4 
 fs/cifs/sess.c                                  |   10 -
 fs/ecryptfs/messaging.c                         |   17 +-
 fs/nfs/nfs4xdr.c                                |    4 
 fs/nfs/super.c                                  |   22 ++-
 include/acpi/processor.h                        |    3 
 include/linux/acpi.h                            |    1 
 include/linux/ethtool.h                         |    2 
 include/linux/fb.h                              |    4 
 include/linux/firmware.h                        |    1 
 include/linux/ieee80211.h                       |    2 
 include/linux/mmc/sdio.h                        |    2 
 include/linux/pci_ids.h                         |    1 
 include/linux/ssb/ssb.h                         |    1 
 include/linux/ssb/ssb_driver_chipcommon.h       |    2 
 include/linux/ssb/ssb_regs.h                    |    3 
 include/math-emu/op-common.h                    |    2 
 include/net/sock.h                              |    7 -
 kernel/futex.c                                  |   17 --
 kernel/irq/manage.c                             |    3 
 kernel/module.c                                 |    4 
 kernel/sched.c                                  |    9 -
 net/bridge/br_fdb.c                             |    6 
 net/core/dev.c                                  |   17 +-
 net/core/ethtool.c                              |   43 ++++--
 net/core/neighbour.c                            |    5 
 net/core/skbuff.c                               |    1 
 net/dccp/input.c                                |    6 
 net/ipv4/arp.c                                  |    6 
 net/ipv4/syncookies.c                           |    2 
 net/ipv4/tcp_output.c                           |   12 +
 net/ipv6/af_inet6.c                             |    2 
 net/ipv6/ndisc.c                                |    2 
 net/ipv6/netfilter/ip6t_REJECT.c                |    6 
 net/llc/llc_sap.c                               |    2 
 net/mac80211/mlme.c                             |   17 +-
 net/mac80211/rx.c                               |    5 
 net/mac80211/scan.c                             |   21 +--
 net/netfilter/ipvs/ip_vs_conn.c                 |    4 
 net/sunrpc/xprtsock.c                           |   38 +++--
 scripts/mod/modpost.c                           |    2 
 sound/pci/echoaudio/echoaudio.c                 |    4 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/soc/codecs/wm8776.c                       |    1 
 tools/perf/util/callchain.h                     |    3 
 virt/kvm/ioapic.c                               |    3 
 152 files changed, 1298 insertions(+), 638 deletions(-)

Adam Jackson (1):
      drm/i915: Make G4X-style PLL search more permissive

Alan Stern (1):
      USB: obey the sysfs power/wakeup setting

Alex Deucher (6):
      drm/radeon/kms: fix shared ddc handling
      drm/radeon/kms: fix shared ddc harder
      drm/radeon/kms: add quirk for ASUS HD 3600 board
      drm/radeon/kms: fix possible mis-detection of sideport on rs690/rs740
      drm/radeon/kms: fix legacy LVDS dpms sequence
      drm/radeon/kms: fix legacy tv-out pal mode

Alex,Shi (1):
      sched: Fix over-scheduling bug

Andi Kleen (1):
      x86: Fix vsyscall on gcc 4.5 with -Os

Andre Osterhues (1):
      ecryptfs: Bugfix for error related to ecryptfs_hash_buckets

Andreas Herrmann (1):
      hwmon: (k8temp) Fix temperature reporting for ASB1 processor revisions

Andrej Gelenberg (1):
      revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"

Ang Way Chuang (1):
      V4L/DVB: dvb-core: Fix ULE decapsulation bug

Anton Vorontsov (3):
      powerpc/cpm: Reintroduce global spi_pram struct (fixes build issue)
      powerpc/cpm1: Fix build with various CONFIG_*_UCODE_PATCH combinations
      edac: mpc85xx: fix MPC85xx dependency

Avi Kivity (1):
      KVM: MMU: Remove user access when allowing kernel access to gpte.w=0 page

Ayaz Abdulla (1):
      forcedeth: fix tx limit2 flag check

Baruch Siach (1):
      dm9000: fix "BUG: spinlock recursion"

Ben Hutchings (5):
      amd64-agp: Probe unknown AGP devices the right way
      ethtool: Fix potential kernel buffer overflow in ETHTOOL_GRXCLSRLALL
      ethtool: Fix potential user buffer overflow for ETHTOOL_{G, S}RXFH
      V4L/DVB: budget: Select correct frontends
      3c503: Fix IRQ probing

Bob Copeland (1):
      ath5k: initialize ah->ah_current_channel

Borislav Petkov (1):
      amd64_edac: Fix syndrome calculation on K8

Brandon Philips (1):
      sky2: enable rx/tx in sky2_phy_reinit()

Catalin Marinas (1):
      ARM: 6201/1: RealView: Do not use outer_sync() on ARM11MPCore boards with L220

Christoph Fritz (1):
      ssb: Handle Netbook devices where the SPROM address is changed

Colin Leitner (1):
      USB: ftdi_sio: support for Signalyzer tools based on FTDI chips

Corey Minyard (1):
      USB: FTDI: Add support for the RT System VX-7 radio programming cable

Dan Rosenberg (1):
      Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE

Daniel J Blueman (1):
      i915: fix lock imbalance on error path...

Daniel Mack (1):
      libertas/sdio: 8686: set ECSI bit for 1-bit transfers

Daniel Ritz (1):
      V4L/DVB (13830): uvcvideo: add another YUYV format GUID for iSight cameras

Darrick J. Wong (2):
      x86, Calgary: Increase max PHB number
      x86, Calgary: Limit the max PHB number to 256

Dave Airlie (2):
      fb: fix colliding defines for fb flags.
      drm/i915: enable low power render writes on GEN3 hardware.

David Howells (1):
      CIFS: Fix a malicious redirect problem in the DNS lookup code

David S. Miller (2):
      ipv6: Fix default multicast hops setting.
      net: Fix FDDI and TR config checks in ipv4 arp and LLC.

David Woodhouse (1):
      firmware_class: fix memory leak - free allocated pages

Dennis Jansen (1):
      USB: option: Add support for AMOI Skypephone S2

Dmitry Torokhov (2):
      Input: twl40300-keypad - fix handling of "all ground" rows
      Input: RX51 keymap - fix recent compile breakage

Dongdong Deng (1):
      serial: cpm_uart: implement the cpm_uart_early_write() function for console poll

Doug Kehn (1):
      net/core: neighbour update Oops

Eric Dumazet (4):
      tcp: tcp_synack_options() fix
      tcp: use correct net ns in cookie_v4_check()
      veth: Dont kfree_skb() after dev_forward_skb()
      netfilter: ip6t_REJECT: fix a dst leak in ipv6 REJECT

Florian Fainelli (1):
      cpmac: do not leak struct net_device on phy_connect errors

Frederic Weisbecker (2):
      perf: Resurrect flat callchains
      x86: Send a SIGTRAP for user icebp traps

Giuliano Pochini (1):
      ALSA: Echoaudio, fix Guru Meditation #00000005.48454C50

Greg Kroah-Hartman (1):
      Linux 2.6.33.7

Herbert Xu (1):
      gro: Fix bogus gso_size on the first fraglist entry

Hiroshi Shimamoto (1):
      cxgb3: fix linkup issue

Ilpo Järvinen (1):
      tcp: fix crash in tcp_xmit_retransmit_queue

Jason Baron (1):
      dynamic debug: move ddebug_remove_module() down into free_module()

Javier Cardona (1):
      mac80211: Handle mesh action frames in ieee80211_rx_h_action

Jean Delvare (6):
      hwmon: (k8temp) Bypass core swapping on single-core processors
      hwmon: (k10temp) Do not blacklist known working CPU models
      hwmon: (coretemp) Properly label the sensors
      hwmon: (coretemp) Skip duplicate CPU entries
      hwmon: (it87) Fix in7 on IT8720F
      V4L/DVB: FusionHDTV: Use quick reads for I2C IR device probing

Jeff Layton (2):
      cifs: remove bogus first_time check in NTLMv2 session setup code
      cifs: don't attempt busy-file rename unless it's in same directory

Jeff Moyer (1):
      cfq: Don't allow queue merges for queues that have no process references

Joakim Tjernlund (1):
      rtc: fix ds1388 time corruption

Joerg Albert (1):
      p54pci: add Symbol AP-300 minipci adapters pciid

Joerg Roedel (2):
      KVM: SVM: Handle MCEs early in the vmexit process
      KVM: SVM: Implement workaround for Erratum 383

Johannes Berg (1):
      powerpc: Fix logic error in fixup_irqs

John W. Linville (1):
      iwlwifi: cancel scan watchdog in iwl_bg_abort_scan

Jon Povey (2):
      USB: g_serial: don't set low_latency flag
      USB: g_serial: fix tty cleanup on unload

Julia Lawall (1):
      SCSI: aacraid: Eliminate use after free

Kamal Mostafa (1):
      Input: i8042 - add Gigabyte Spring Peak to dmi_noloop_table

Keith Packard (1):
      drm/i915: Define MI_ARB_STATE bits

Krzysztof Halasa (1):
      kbuild: Fix modpost segfault

Laurent Pinchart (3):
      V4L/DVB: uvcvideo: Add support for unbranded Arkmicro 18ec:3290 webcams
      V4L/DVB: uvcvideo: Add support for Packard Bell EasyNote MX52 integrated webcam
      V4L/DVB: uvcvideo: Add support for V4L2_PIX_FMT_Y16

Len Brown (1):
      ACPI: skip checking BM_STS if the BIOS doesn't ask for it

Linus Torvalds (2):
      drm/i915: fix hibernation since i915 self-reclaim fixes
      drm/i915: add 'reclaimable' to i915 self-reclaimable page allocations

Luis R. Rodriguez (1):
      ath5k: drop warning on jumbo frames

Luke Yelavich (1):
      ALSA: hda - Add Macbook 5,2 quirk

Marcelo Tosatti (2):
      KVM: MMU: invalidate and flush on spte small->large page size change
      KVM: read apic->irr with ioapic lock held

Marek Szyprowski (1):
      sdhci-s3c: add missing remove function

Mark Brown (1):
      ASoC: Remove duplicate AUX definition from WM8776

Matthew Garrett (1):
      ACPI: Unconditionally set SCI_EN on resume

Michal Hocko (1):
      futex: futex_find_get_task remove credentails check

Mikael Pettersson (1):
      math-emu: correct test for downshifting fraction in _FP_FROM_INT()

Mikulas Patocka (1):
      ide: Fix IDE taskfile with cfq scheduler

Nicolas Pitre (1):
      ARM: 6226/1: fix kprobe bug in ldr instruction emulation

Oliver Neukum (2):
      USB: sisusbvga: Fix for USB 3.0
      USB: add quirk for Broadcom BT dongle

Ondrej Zary (1):
      PM / x86: Save/restore MISC_ENABLE register

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Paul Mortier (1):
      USB: adds Artisman USB dongle to list of quirky devices

Prasanna S. Panchamukhi (1):
      md: raid10: Fix null pointer dereference in fix_read_error()

Rajiv Andrade (2):
      TPM: ReadPubEK output struct fix
      tpm_tis: fix subsequent suspend failures

Richard Airlie (1):
      staging: rtl8192su: add Support for Belkin F5D8053 v6

Rob Landley (1):
      sparc: Fix use of uid16_t and gid16_t in asm/stat.h

Roland Scheidegger (3):
      drm/radeon/r200: handle more hw tex coord types
      drm/radeon/r100/r200: fix calculation of compressed cube maps
      drm/radeon/kms: CS checker texture fixes for r1xx/r2xx/r3xx

Sergei Shtylyov (1):
      cmd640: fix kernel oops in test_irq() method

Shane McDonald (1):
      MIPS FPU emulator: allow Cause bits of FCSR to be writeable by ctc1

Shanyu Zhao (1):
      iwlagn: verify flow id in compressed BA packet

Stanislaw Gruszka (2):
      mac80211: do not wip out old supported rates
      mac80211: fix supported rates IE if AP doesn't give us it's rates

Stefano Stabellini (1):
      x86: Do not try to disable hpet if it hasn't been initialized before

Sven Wegener (1):
      ipvs: Add missing locking during connection table hashing and unhashing

Tadashi Abe (1):
      pegasus: fix USB device ID for ETX-US2

Tejun Heo (1):
      ahci,ata_generic: let ata_generic handle new MBP w/ MCP89

Thomas Gleixner (1):
      genirq: Deal with desc->set_type() changing desc->chip

Tim Gardner (1):
      hostap: Protect against initialization interrupt

Timo Teräs (2):
      r8169: fix random mdio_write failures
      r8169: fix mdio_read and update mdio_write according to hw specs

Tom Herbert (1):
      net: fix problem in reading sock TX queue

Tony Luck (1):
      Fix spinaphore down_spin()

Trond Myklebust (3):
      NFSv4: Fix an embarassing typo in encode_attrs()
      NFSv4: Ensure that /proc/self/mountinfo displays the minor version number
      SUNRPC: Fix a re-entrancy bug in xs_tcp_read_calldir()

Vivek Natarajan (1):
      ath9k: Avoid corrupt frames being forwarded to mac80211.

Will Deacon (1):
      sched: Prevent compiler from optimising the sched_avg_update() loop

Wolfram Sang (1):
      USB: ehci-mxc: bail out on transceiver problems

Yinghai Lu (1):
      x86: Fix x2apic preenabled system with kexec

Yoichi Yuasa (1):
      net/dccp: expansion of error code size

august huber (1):
      USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c

stephen hemminger (2):
      bridge: fdb cleanup runs too often
      ipv6: fix NULL reference in proxy neighbor discovery

Ömer Sezgin Ugurlu (1):
      USB: option: add support for 1da5:4518

