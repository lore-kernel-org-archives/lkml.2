Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1BPBtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:49:06 -0500
Received: from kroah.org ([198.145.64.141]:48691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab1BPBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:48:59 -0500
Date: Tue, 15 Feb 2011 17:47:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/115] 2.6.32.29-longterm review
Message-ID: <20110216014741.GA24678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.29 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, Feb 18, 2011 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.29-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/kernel-parameters.txt        |    5 +
 Makefile                                   |    2 +-
 arch/ia64/include/asm/system.h             |    4 -
 arch/parisc/kernel/firmware.c              |   13 +-
 arch/powerpc/include/asm/system.h          |    4 -
 arch/powerpc/kernel/cpu_setup_6xx.S        |   40 ++--
 arch/powerpc/sysdev/fsl_rio.c              |    1 -
 arch/s390/include/asm/system.h             |    1 -
 arch/s390/include/asm/vdso.h               |    2 +-
 arch/x86/Kconfig                           |   11 +
 arch/x86/include/asm/mmu_context.h         |    5 +-
 arch/x86/kernel/cpu/mtrr/main.c            |   10 +-
 arch/x86/kernel/tsc.c                      |    8 +
 drivers/ata/pata_mpc52xx.c                 |    2 +-
 drivers/char/hvc_iucv.c                    |    6 +-
 drivers/char/tpm/tpm.c                     |   28 ++-
 drivers/char/tpm/tpm.h                     |    2 +
 drivers/char/tpm/tpm_tis.c                 |    4 +-
 drivers/gpu/drm/Kconfig                    |    3 +
 drivers/gpu/drm/i915/intel_lvds.c          |    8 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   16 +-
 drivers/gpu/drm/radeon/radeon_display.c    |    4 +
 drivers/hwmon/via686a.c                    |   14 +-
 drivers/i2c/i2c-core.c                     |   14 +-
 drivers/input/mouse/bcm5974.c              |   40 +++
 drivers/input/serio/i8042-x86ia64io.h      |   21 ++
 drivers/input/serio/i8042.c                |    6 +-
 drivers/md/dm-mpath.c                      |   12 -
 drivers/md/dm.c                            |    5 +-
 drivers/md/md.c                            |    5 +-
 drivers/media/radio/radio-aimslab.c        |   23 +--
 drivers/media/video/em28xx/em28xx-cards.c  |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h     |    4 +-
 drivers/net/wireless/hostap/hostap_cs.c    |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   15 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 +
 drivers/net/wireless/p54/txrx.c            |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |    1 +
 drivers/pci/pci-stub.c                     |    3 +
 drivers/power/ds2760_battery.c             |    2 +-
 drivers/rtc/rtc-cmos.c                     |   16 +-
 drivers/scsi/libsas/sas_scsi_host.c        |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   19 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |    3 -
 drivers/scsi/sd.c                          |    9 +-
 drivers/serial/8250.c                      |    3 +-
 drivers/staging/comedi/drivers/jr3_pci.c   |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c  |    3 +-
 drivers/staging/hv/blkvsc_drv.c            |    1 +
 drivers/staging/hv/netvsc_drv.c            |    1 +
 drivers/staging/usbip/vhci_hcd.c           |   14 -
 drivers/usb/class/cdc-acm.c                |    1 +
 drivers/usb/core/hub.c                     |   26 ++
 drivers/usb/gadget/printer.c               |   14 +-
 drivers/usb/host/ehci-hcd.c                |   27 ++-
 drivers/usb/host/ehci-pci.c                |   39 +++
 drivers/usb/host/ehci-sched.c              |   79 ++++++
 drivers/usb/host/ehci.h                    |    1 +
 drivers/usb/serial/ch341.c                 |   10 +
 drivers/usb/serial/cp210x.c                |   16 +-
 drivers/usb/serial/digi_acceleport.c       |   10 -
 drivers/usb/serial/ftdi_sio.c              |   39 +++-
 drivers/usb/serial/ftdi_sio_ids.h          |   32 ++-
 drivers/usb/serial/generic.c               |   20 ++
 drivers/usb/serial/io_edgeport.c           |    4 +-
 drivers/usb/serial/keyspan_pda.c           |   17 --
 drivers/usb/serial/option.c                |   23 ++-
 drivers/usb/serial/pl2303.c                |   13 +
 drivers/usb/serial/pl2303.h                |    2 +
 drivers/usb/serial/spcp8x5.c               |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.c      |    2 +-
 drivers/usb/storage/unusual_cypress.h      |    5 +
 drivers/usb/storage/unusual_devs.h         |   32 +++
 drivers/virtio/virtio_pci.c                |   20 +--
 fs/nfs/direct.c                            |   34 ++-
 include/drm/drm_pciids.h                   |    1 -
 include/linux/hardirq.h                    |    9 +-
 include/linux/ieee80211.h                  |    2 +-
 include/linux/klist.h                      |    2 +-
 include/linux/sched.h                      |   39 ++--
 include/linux/usb/serial.h                 |    3 +
 init/Kconfig                               |   80 ++----
 init/calibrate.c                           |    6 +-
 kernel/capability.c                        |    1 -
 kernel/cred-internals.h                    |   21 --
 kernel/cred.c                              |    3 -
 kernel/exit.c                              |    1 -
 kernel/ksysfs.c                            |    8 -
 kernel/ptrace.c                            |    2 +-
 kernel/sched.c                             |  392 +++++++++++++++++----------
 kernel/sched_debug.c                       |    5 -
 kernel/sched_fair.c                        |   56 +++-
 kernel/sched_features.h                    |    5 +
 kernel/sched_rt.c                          |   34 ++-
 kernel/smp.c                               |   30 +++
 kernel/softirq.c                           |   64 +++--
 kernel/sys.c                               |    5 -
 kernel/user.c                              |  318 +----------------------
 net/sched/cls_cgroup.c                     |    2 +-
 security/selinux/hooks.c                   |    5 +-
 security/selinux/nlmsgtab.c                |    2 +
 sound/core/hrtimer.c                       |    5 +-
 sound/pci/au88x0/au88x0_pcm.c              |   24 ++-
 sound/pci/hda/hda_eld.c                    |    2 +-
 sound/pci/hda/patch_conexant.c             |    8 +-
 sound/soc/blackfin/bf5xx-ac97.c            |    4 +-
 sound/soc/codecs/wm8990.c                  |   10 +-
 sound/usb/usx2y/us122l.c                   |   41 ++--
 108 files changed, 1189 insertions(+), 916 deletions(-)
