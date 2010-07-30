Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab0G3ReR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:17 -0400
Received: from kroah.org ([198.145.64.141]:35416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759226Ab0G3Rdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:50 -0400
Date: Fri, 30 Jul 2010 10:32:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/140] 2.6.33.7-rc1 stable review
Message-ID: <20100730173205.GA22581@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this is the LAST .33 -stable release.

This is the start of the stable review cycle for the 2.6.33.7 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by August 1, 2010, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                        |    2 +-
 arch/arm/kernel/kprobes-decode.c                |    5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   17 ++-
 arch/arm/mach-realview/Kconfig                  |    2 +
 arch/arm/mach-realview/include/mach/barriers.h  |    8 +
 arch/ia64/mm/tlb.c                              |    2 +-
 arch/mips/include/asm/mipsregs.h                |    9 +-
 arch/mips/math-emu/cp1emu.c                     |   15 ++-
 arch/powerpc/include/asm/cpm.h                  |   24 ++++
 arch/powerpc/kernel/irq.c                       |    5 +-
 arch/powerpc/sysdev/micropatch.c                |   12 ++-
 arch/sparc/include/asm/stat.h                   |    4 +-
 arch/x86/include/asm/msr-index.h                |    1 +
 arch/x86/include/asm/suspend_32.h               |    2 +
 arch/x86/include/asm/suspend_64.h               |    2 +
 arch/x86/include/asm/system.h                   |    2 +-
 arch/x86/kernel/acpi/cstate.c                   |    9 ++
 arch/x86/kernel/acpi/sleep.c                    |    2 -
 arch/x86/kernel/apic/apic.c                     |    2 +-
 arch/x86/kernel/hpet.c                          |    2 +-
 arch/x86/kernel/pci-calgary_64.c                |   17 ++-
 arch/x86/kernel/traps.c                         |   11 ++-
 arch/x86/kvm/mmu.c                              |    5 +
 arch/x86/kvm/svm.c                              |   96 ++++++++++++++-
 arch/x86/power/cpu.c                            |    4 +
 block/cfq-iosched.c                             |   13 ++-
 drivers/acpi/processor_idle.c                   |    2 +-
 drivers/acpi/sleep.c                            |  157 +----------------------
 drivers/ata/ahci.c                              |   10 ++
 drivers/ata/ata_generic.c                       |    6 +
 drivers/base/firmware_class.c                   |   26 +++-
 drivers/char/agp/amd64-agp.c                    |   27 ++--
 drivers/char/tpm/tpm.h                          |    1 +
 drivers/char/tpm/tpm_tis.c                      |    9 +-
 drivers/cpufreq/cpufreq.c                       |   11 +--
 drivers/edac/Kconfig                            |    2 +-
 drivers/edac/amd64_edac.c                       |   24 ++--
 drivers/gpu/drm/i915/i915_drv.c                 |    1 +
 drivers/gpu/drm/i915/i915_gem.c                 |   13 ++-
 drivers/gpu/drm/i915/i915_reg.h                 |   64 +++++++++
 drivers/gpu/drm/i915/intel_display.c            |    4 +-
 drivers/gpu/drm/radeon/r100.c                   |   61 +++++----
 drivers/gpu/drm/radeon/r200.c                   |    5 +
 drivers/gpu/drm/radeon/r300.c                   |    5 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   20 +++-
 drivers/gpu/drm/radeon/radeon_connectors.c      |   27 ++--
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_tv.c       |    4 +-
 drivers/hwmon/coretemp.c                        |   32 +++++-
 drivers/hwmon/it87.c                            |   22 +++
 drivers/hwmon/k10temp.c                         |   14 ++-
 drivers/hwmon/k8temp.c                          |   12 +-
 drivers/ide/cmd640.c                            |    6 +-
 drivers/ide/ide-taskfile.c                      |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |    4 +-
 drivers/input/keyboard/twl4030_keypad.c         |   17 ++-
 drivers/input/serio/i8042-x86ia64io.h           |    7 +
 drivers/md/raid10.c                             |   12 +-
 drivers/media/dvb/dvb-core/dvb_net.c            |   12 ++-
 drivers/media/dvb/ttpci/Kconfig                 |    5 +-
 drivers/media/video/cx23885/cx23885-i2c.c       |   12 ++-
 drivers/media/video/cx88/cx88-i2c.c             |   16 ++-
 drivers/media/video/uvc/uvc_driver.c            |   30 ++++-
 drivers/media/video/uvc/uvcvideo.h              |    7 +-
 drivers/mmc/host/sdhci-s3c.c                    |   20 +++
 drivers/net/3c503.c                             |   42 +++++--
 drivers/net/cpmac.c                             |    3 +-
 drivers/net/cxgb3/ael1002.c                     |    2 +-
 drivers/net/dm9000.c                            |   38 ++++--
 drivers/net/forcedeth.c                         |    2 +-
 drivers/net/r8169.c                             |   11 ++
 drivers/net/sky2.c                              |   19 ++-
 drivers/net/usb/pegasus.h                       |    2 +-
 drivers/net/veth.c                              |    1 -
 drivers/net/wireless/ath/ath5k/attach.c         |    1 +
 drivers/net/wireless/ath/ath5k/base.c           |    7 +-
 drivers/net/wireless/ath/ath9k/initvals.h       |    8 +-
 drivers/net/wireless/hostap/hostap_cs.c         |   15 ++-
 drivers/net/wireless/hostap/hostap_hw.c         |   13 ++
 drivers/net/wireless/hostap/hostap_wlan.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    5 +
 drivers/net/wireless/libertas/if_sdio.c         |   22 +++
 drivers/net/wireless/p54/p54pci.c               |    2 +
 drivers/rtc/rtc-ds1307.c                        |    4 +-
 drivers/scsi/aacraid/commctrl.c                 |    4 +-
 drivers/serial/cpm_uart/cpm_uart_core.c         |  143 ++++++++++++---------
 drivers/spi/spi_mpc8xxx.c                       |   22 ---
 drivers/ssb/driver_chipcommon.c                 |    3 +
 drivers/ssb/driver_chipcommon_pmu.c             |   17 +--
 drivers/ssb/pci.c                               |   46 ++++++-
 drivers/ssb/sprom.c                             |   15 ++
 drivers/staging/rtl8192su/r8192U_core.c         |    1 +
 drivers/usb/core/driver.c                       |   15 +--
 drivers/usb/core/quirks.c                       |    7 +
 drivers/usb/gadget/u_serial.c                   |   16 +--
 drivers/usb/host/ehci-mxc.c                     |   13 ++-
 drivers/usb/misc/sisusbvga/sisusb.c             |    5 +-
 drivers/usb/serial/ftdi_sio.c                   |    9 ++
 drivers/usb/serial/ftdi_sio_ids.h               |   15 ++
 drivers/usb/serial/option.c                     |    4 +
 drivers/usb/serial/sierra.c                     |    1 +
 fs/btrfs/ioctl.c                                |    4 +-
 fs/cifs/cifsfs.c                                |    6 +-
 fs/cifs/dns_resolve.c                           |   69 ++++++++++
 fs/cifs/dns_resolve.h                           |    4 +-
 fs/cifs/inode.c                                 |    4 +
 fs/cifs/sess.c                                  |   10 +--
 fs/ecryptfs/messaging.c                         |   17 ++-
 fs/nfs/nfs4xdr.c                                |    4 +-
 fs/nfs/super.c                                  |   22 +++-
 include/acpi/processor.h                        |    3 +-
 include/linux/acpi.h                            |    1 -
 include/linux/ethtool.h                         |    2 +
 include/linux/fb.h                              |    4 +-
 include/linux/firmware.h                        |    1 +
 include/linux/ieee80211.h                       |    2 +
 include/linux/mmc/sdio.h                        |    2 +
 include/linux/pci_ids.h                         |    1 +
 include/linux/ssb/ssb.h                         |    1 +
 include/linux/ssb/ssb_driver_chipcommon.h       |    2 +
 include/linux/ssb/ssb_regs.h                    |    3 +-
 include/math-emu/op-common.h                    |    2 +-
 include/net/sock.h                              |    7 +-
 kernel/futex.c                                  |   17 +--
 kernel/irq/manage.c                             |    3 +
 kernel/module.c                                 |    4 +-
 kernel/sched.c                                  |    9 +-
 net/bridge/br_fdb.c                             |    6 +-
 net/core/dev.c                                  |   17 +--
 net/core/ethtool.c                              |   43 +++++--
 net/core/neighbour.c                            |    5 +-
 net/core/skbuff.c                               |    1 +
 net/dccp/input.c                                |    6 +-
 net/ipv4/arp.c                                  |    6 +-
 net/ipv4/syncookies.c                           |    2 +-
 net/ipv4/tcp_output.c                           |   12 +-
 net/ipv6/af_inet6.c                             |    2 +-
 net/ipv6/ndisc.c                                |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c                |    6 +-
 net/llc/llc_sap.c                               |    2 +-
 net/mac80211/mlme.c                             |   17 ++-
 net/mac80211/rx.c                               |    5 +
 net/mac80211/scan.c                             |   21 ++--
 net/netfilter/ipvs/ip_vs_conn.c                 |    4 +
 net/sunrpc/xprtsock.c                           |   38 +++---
 scripts/mod/modpost.c                           |    2 +-
 sound/pci/echoaudio/echoaudio.c                 |    4 +-
 sound/pci/hda/patch_realtek.c                   |    1 +
 sound/soc/codecs/wm8776.c                       |    1 -
 tools/perf/util/callchain.h                     |    3 +
 virt/kvm/ioapic.c                               |    3 +-
 152 files changed, 1298 insertions(+), 638 deletions(-)
