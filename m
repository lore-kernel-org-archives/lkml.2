Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab2EDUnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:43:06 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:41314 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2EDUnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:43:03 -0400
Date: Fri, 4 May 2012 13:42:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/75] 3.3.5-stable review
Message-ID: <20120504204258.GA12552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.5 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May  6 20:42:22 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                    |    4 +-
 arch/arm/Kconfig                            |    9 +
 arch/arm/include/asm/tls.h                  |    4 +
 arch/arm/kernel/irq.c                       |    6 +-
 arch/arm/mm/abort-ev6.S                     |   17 +-
 arch/mips/ath79/dev-wmac.c                  |    2 +-
 arch/powerpc/platforms/85xx/common.c        |    6 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c   |   11 +-
 arch/powerpc/platforms/85xx/p1022_ds.c      |   13 +-
 arch/x86/boot/Makefile                      |    3 +-
 arch/x86/boot/compressed/Makefile           |    1 +
 arch/x86/boot/compressed/eboot.c            |    8 +-
 arch/x86/boot/compressed/head_32.S          |   14 +-
 arch/x86/boot/compressed/head_64.S          |   22 ++-
 arch/x86/boot/compressed/mkpiggy.c          |   11 +-
 arch/x86/boot/tools/build.c                 |   42 ++--
 arch/x86/include/asm/x86_init.h             |    1 -
 arch/x86/kernel/apic/apic.c                 |   34 ++--
 arch/x86/kernel/apic/apic_numachip.c        |    7 +-
 arch/x86/kernel/cpu/amd.c                   |    7 +-
 arch/x86/kernel/cpu/common.c                |    9 -
 arch/x86/kernel/i387.c                      |    1 +
 arch/x86/kernel/microcode_amd.c             |   12 +-
 arch/x86/kernel/microcode_core.c            |   10 +-
 arch/x86/kernel/x86_init.c                  |    1 -
 arch/x86/xen/smp.c                          |   15 ++
 arch/x86/xen/xen-asm.S                      |    2 +-
 drivers/ata/libata-eh.c                     |    3 +-
 drivers/crypto/talitos.c                    |   20 +-
 drivers/dma/at_hdmac.c                      |    4 -
 drivers/firmware/efivars.c                  |  196 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c  |    8 +-
 drivers/gpu/drm/i915/i915_reg.h             |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    8 +
 drivers/gpu/drm/i915/intel_sdvo.c           |   34 ++--
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    4 +-
 drivers/hwmon/coretemp.c                    |    6 +-
 drivers/hwmon/fam15h_power.c                |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                |    3 +-
 drivers/input/mouse/synaptics.c             |    3 +-
 drivers/md/raid5.c                          |    4 +-
 drivers/net/wireless/b43/main.c             |   10 +-
 drivers/net/wireless/ipw2x00/ipw2200.c      |   13 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   16 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   27 ++-
 drivers/net/wireless/rtlwifi/pci.c          |    1 +
 drivers/net/wireless/wl1251/main.c          |    1 +
 drivers/net/wireless/wl1251/sdio.c          |    2 +-
 drivers/platform/x86/dell-laptop.c          |    1 +
 drivers/scsi/libsas/sas_expander.c          |   26 ++-
 drivers/usb/class/cdc-wdm.c                 |    7 +-
 drivers/usb/core/hcd-pci.c                  |    9 +
 drivers/usb/gadget/dummy_hcd.c              |    1 -
 drivers/usb/gadget/f_mass_storage.c         |    2 +-
 drivers/usb/gadget/file_storage.c           |    2 +-
 drivers/usb/gadget/uvc.h                    |    2 +-
 drivers/usb/gadget/uvc_v4l2.c               |    2 +-
 drivers/usb/host/ehci-pci.c                 |    8 +
 drivers/usb/host/ehci-tegra.c               |    1 -
 fs/autofs4/autofs_i.h                       |   12 +-
 fs/autofs4/dev-ioctl.c                      |    3 +-
 fs/autofs4/inode.c                          |    4 +-
 fs/autofs4/waitq.c                          |   20 +-
 fs/exec.c                                   |    3 +
 fs/nfs/nfs4proc.c                           |   23 ++-
 fs/nfs/read.c                               |    2 +-
 fs/nfs/super.c                              |    8 +-
 fs/nfs/write.c                              |    2 +-
 fs/pipe.c                                   |   31 ++-
 include/linux/efi.h                         |   13 +-
 include/linux/pipe_fs_i.h                   |    1 +
 include/linux/usb/hcd.h                     |    2 +
 kernel/exit.c                               |   19 --
 kernel/power/swap.c                         |   28 ++-
 kernel/sched/core.c                         |   75 ++++----
 kernel/signal.c                             |    9 +
 kernel/trace/trace_output.c                 |    5 +
 net/mac80211/tx.c                           |    3 +-
 net/wireless/nl80211.c                      |   29 +--
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/soc/codecs/wm8994.c                   |  276 +++++++++++++++++++++------
 sound/soc/soc-dapm.c                        |    2 +
 89 files changed, 1022 insertions(+), 356 deletions(-)

