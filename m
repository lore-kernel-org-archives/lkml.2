Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0IRTid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:38:33 -0400
Received: from kroah.org ([198.145.64.141]:43214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab0IRTOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:50 -0400
Date: Sat, 18 Sep 2010 12:13:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/129] 2.6.35.5 -stable review
Message-ID: <20100918191317.GA11386@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note, I do still have patches that people have sent me for inclusion in
the .35-stable tree in my queue, but I figured this series was already
big enough that it should go out now.  If you notice, I _did_ apply all
patches that went through Linus's tree with a stable@kernel.org marking
on it, so people might consider using that method instead...]

This is the start of the stable review cycle for the 2.6.35.5 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by @date (day, month date, time)@ UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/sound/alsa/HD-Audio-Models.txt   |    1 +
 Makefile                                       |    2 +-
 arch/arm/kernel/entry-common.S                 |    2 +
 arch/ia64/include/asm/compat.h                 |    2 +-
 arch/ia64/kernel/msi_ia64.c                    |    2 +-
 arch/ia64/sn/kernel/msi_sn.c                   |    2 +-
 arch/mips/include/asm/compat.h                 |    2 +-
 arch/parisc/include/asm/compat.h               |    2 +-
 arch/powerpc/include/asm/compat.h              |    2 +-
 arch/powerpc/kernel/time.c                     |   23 +--
 arch/s390/include/asm/compat.h                 |    2 +-
 arch/sparc/include/asm/compat.h                |    2 +-
 arch/x86/ia32/ia32entry.S                      |   22 ++-
 arch/x86/include/asm/compat.h                  |    2 +-
 arch/x86/include/asm/hpet.h                    |    1 -
 arch/x86/include/asm/tsc.h                     |    2 +
 arch/x86/kernel/apic/io_apic.c                 |    2 +-
 arch/x86/kernel/cpu/perf_event_p4.c            |    2 +
 arch/x86/kernel/early-quirks.c                 |   18 --
 arch/x86/kernel/hpet.c                         |   31 ++--
 arch/x86/kernel/tsc.c                          |   38 ++++
 arch/x86/oprofile/nmi_int.c                    |   22 ++-
 arch/x86/power/cpu.c                           |    2 +
 drivers/ata/libahci.c                          |    2 +-
 drivers/ata/libata-core.c                      |   14 ++-
 drivers/ata/libata-eh.c                        |    4 +
 drivers/ata/libata-sff.c                       |    7 +-
 drivers/ata/pata_cmd64x.c                      |    6 -
 drivers/ata/pata_via.c                         |    2 +
 drivers/ata/sata_mv.c                          |   44 ++++-
 drivers/char/agp/intel-gtt.c                   |    8 +-
 drivers/gpu/drm/drm_crtc_helper.c              |    4 +-
 drivers/gpu/drm/i915/i915_dma.c                |   36 +++--
 drivers/gpu/drm/i915/i915_gem.c                |    1 +
 drivers/gpu/drm/i915/i915_reg.h                |    9 +
 drivers/gpu/drm/i915/intel_display.c           |   11 +-
 drivers/gpu/drm/i915/intel_dp.c                |   58 +++---
 drivers/gpu/drm/i915/intel_lvds.c              |    2 -
 drivers/gpu/drm/i915/intel_ringbuffer.c        |    8 +-
 drivers/gpu/drm/radeon/atombios_crtc.c         |   23 ++-
 drivers/gpu/drm/radeon/evergreen.c             |   66 ++++++-
 drivers/gpu/drm/radeon/r600.c                  |    7 +-
 drivers/gpu/drm/radeon/radeon.h                |    6 +
 drivers/gpu/drm/radeon/rv770.c                 |   52 +++++
 drivers/hid/usbhid/hid-core.c                  |    3 +-
 drivers/hwmon/ads7871.c                        |   38 ++--
 drivers/hwmon/emc1403.c                        |    1 -
 drivers/hwmon/f75375s.c                        |    6 +-
 drivers/hwmon/hp_accel.c                       |    2 +
 drivers/hwmon/k8temp.c                         |   35 +++-
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    2 +-
 drivers/input/mouse/appletouch.c               |    6 +-
 drivers/input/serio/i8042.c                    |   67 ++++---
 drivers/mmc/core/core.c                        |   83 ++++++---
 drivers/mmc/core/host.c                        |    6 +
 drivers/mmc/host/tmio_mmc.c                    |    7 +-
 drivers/mmc/host/tmio_mmc.h                    |   13 +-
 drivers/net/wireless/ath/ath5k/base.c          |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    3 +-
 drivers/net/wireless/ath/regd.h                |    1 -
 drivers/net/wireless/p54/txrx.c                |    2 +-
 drivers/oprofile/buffer_sync.c                 |   27 ++--
 drivers/oprofile/cpu_buffer.c                  |    2 -
 drivers/pci/msi.c                              |   27 +++-
 drivers/power/apm_power.c                      |    1 +
 drivers/serial/bfin_sport_uart.c               |    2 +-
 drivers/staging/hv/netvsc_drv.c                |    3 +
 drivers/staging/hv/ring_buffer.c               |    3 +-
 drivers/staging/hv/storvsc_api.h               |    4 +-
 drivers/staging/hv/storvsc_drv.c               |   11 +-
 drivers/staging/rt2860/usb_main_dev.c          |   41 ++++-
 drivers/usb/atm/cxacru.c                       |   24 ++-
 drivers/usb/class/cdc-acm.c                    |   23 ++-
 drivers/usb/core/message.c                     |   22 +-
 drivers/usb/gadget/rndis.c                     |   10 +-
 drivers/usb/host/ehci-ppc-of.c                 |   12 +-
 drivers/usb/serial/cp210x.c                    |   10 +-
 drivers/usb/serial/ftdi_sio.c                  |    8 +
 drivers/usb/serial/ftdi_sio_ids.h              |   12 ++
 drivers/usb/serial/mos7840.c                   |   32 ++-
 drivers/xen/events.c                           |   21 ++-
 fs/binfmt_misc.c                               |    2 +-
 fs/cifs/connect.c                              |    6 +-
 fs/direct-io.c                                 |   30 ++--
 fs/ext4/ext4.h                                 |    4 +-
 fs/ext4/inode.c                                |   17 ++-
 fs/fuse/dev.c                                  |   16 ++-
 fs/minix/namei.c                               |    2 +-
 fs/nfs/client.c                                |    2 +-
 fs/nfs/super.c                                 |   10 +-
 fs/ocfs2/aops.c                                |    7 +-
 fs/ocfs2/inode.c                               |    6 +-
 fs/sysfs/file.c                                |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c                    |   24 ++-
 fs/xfs/linux-2.6/xfs_aops.h                    |    2 +
 fs/xfs/xfs_ialloc.c                            |   16 +-
 fs/xfs/xfs_inode.c                             |   49 +++---
 include/linux/compat.h                         |    3 +
 include/linux/fs.h                             |    3 +-
 include/linux/libata.h                         |    1 +
 include/linux/mmc/host.h                       |    3 +
 include/linux/msi.h                            |    2 +
 include/linux/swap.h                           |    3 +-
 kernel/compat.c                                |   21 ++
 kernel/gcov/fs.c                               |  244 +++++++++++++++++------
 kernel/groups.c                                |    5 +-
 kernel/trace/ftrace.c                          |   19 ++-
 mm/bounce.c                                    |    2 +-
 mm/compaction.c                                |    7 +-
 mm/memory_hotplug.c                            |   16 +-
 mm/page-writeback.c                            |   26 +--
 mm/swapfile.c                                  |   35 +++-
 net/ipv4/netfilter/arp_tables.c                |    3 +
 net/ipv4/netfilter/ip_tables.c                 |    3 +
 net/ipv6/netfilter/ip6_tables.c                |    3 +
 net/irda/irlan/irlan_common.c                  |    2 +-
 net/mac80211/main.c                            |    6 +
 net/sunrpc/auth_gss/auth_gss.c                 |    9 +-
 net/sunrpc/rpc_pipe.c                          |    6 +-
 net/wireless/wext-compat.c                     |    3 +
 net/wireless/wext-core.c                       |   16 ++
 security/integrity/ima/ima.h                   |    1 +
 security/integrity/ima/ima_iint.c              |    4 +-
 security/integrity/ima/ima_main.c              |    8 +-
 sound/core/seq/oss/seq_oss_init.c              |    9 +-
 sound/pci/hda/hda_codec.c                      |    2 +-
 sound/pci/hda/patch_cirrus.c                   |   50 +++++
 sound/pci/hda/patch_conexant.c                 |   58 ++++++
 sound/pci/hda/patch_nvhdmi.c                   |   61 ++++--
 sound/pci/hda/patch_realtek.c                  |   20 ++-
 sound/pci/oxygen/oxygen.h                      |    1 +
 sound/pci/oxygen/oxygen_lib.c                  |   21 ++-
 sound/pci/oxygen/virtuoso.c                    |    1 +
 sound/pci/oxygen/xonar_wm87x6.c                |   22 ++-
 sound/usb/card.c                               |   19 ++-
 sound/usb/clock.c                              |    3 +-
 sound/usb/endpoint.c                           |   11 +-
 sound/usb/format.c                             |   14 +-
 sound/usb/mixer.c                              |   10 +-
 sound/usb/pcm.c                                |    3 +-
 tools/perf/util/callchain.h                    |    1 +
 143 files changed, 1517 insertions(+), 572 deletions(-)
