Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2FTRak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:30:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab2FTRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:30:38 -0400
Date: Wed, 20 Jun 2012 10:30:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/61] 3.4.4-stable review
Message-ID: <20120620173033.GA5634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.4 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun 22 17:30:18 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                          |    4 +-
 arch/arm/mach-imx/crm-regs-imx5.h                 |    2 +-
 arch/arm/mach-imx/hotplug.c                       |   42 ++++++++-
 arch/arm/mach-imx/mach-mx21ads.c                  |    2 +-
 arch/powerpc/include/asm/hw_irq.h                 |    3 +
 arch/x86/xen/enlighten.c                          |    8 ++
 drivers/char/hw_random/atmel-rng.c                |    2 +-
 drivers/edac/i7core_edac.c                        |   15 +---
 drivers/edac/sb_edac.c                            |   10 +--
 drivers/gpu/drm/i915/intel_dp.c                   |    7 +-
 drivers/gpu/drm/radeon/evergreen.c                |    3 +
 drivers/gpu/drm/radeon/evergreend.h               |    1 +
 drivers/gpu/drm/radeon/r600.c                     |    1 +
 drivers/gpu/drm/radeon/r600d.h                    |    1 +
 drivers/gpu/drm/radeon/rv770.c                    |    5 +-
 drivers/gpu/drm/radeon/rv770d.h                   |    3 +
 drivers/gpu/drm/sis/sis_drv.c                     |    2 +-
 drivers/gpu/drm/udl/udl_drv.c                     |   15 +++-
 drivers/gpu/drm/via/via_map.c                     |    3 +-
 drivers/net/ethernet/intel/e1000e/82571.c         |    3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c        |    8 --
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   23 ++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   18 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   20 +++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4 +-
 drivers/pci/pci.c                                 |    5 ++
 drivers/pci/quirks.c                              |   26 ++++++
 drivers/remoteproc/omap_remoteproc.c              |    2 +-
 drivers/remoteproc/remoteproc_core.c              |   10 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.c               |    2 +-
 drivers/target/target_core_alua.c                 |    8 +-
 drivers/tty/hvc/hvc_xen.c                         |   31 ++++---
 drivers/usb/class/cdc-acm.c                       |    8 ++
 drivers/usb/class/cdc-wdm.c                       |    9 ++
 drivers/usb/core/hcd-pci.c                        |    9 --
 drivers/usb/core/message.c                        |    3 +-
 drivers/usb/host/ehci-hcd.c                       |    2 +
 drivers/usb/host/ehci-pci.c                       |    8 --
 drivers/usb/host/xhci-mem.c                       |   74 ++++++----------
 drivers/usb/host/xhci.c                           |    8 +-
 drivers/usb/musb/davinci.c                        |    1 +
 drivers/usb/musb/davinci.h                        |    4 +-
 drivers/usb/musb/musb_gadget.c                    |    1 +
 drivers/usb/serial/cp210x.c                       |    1 +
 drivers/usb/serial/ftdi_sio.c                     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                 |    1 +
 drivers/usb/serial/mct_u232.c                     |   13 +--
 drivers/usb/serial/mos7840.c                      |    2 +-
 drivers/usb/serial/option.c                       |   96 ++++++++++-----------
 drivers/usb/serial/qcserial.c                     |    6 ++
 drivers/usb/serial/sierra.c                       |    4 +
 drivers/usb/serial/usb-serial.c                   |    6 +-
 drivers/usb/storage/unusual_devs.h                |    7 ++
 fs/hfsplus/ioctl.c                                |    9 +-
 fs/hfsplus/wrapper.c                              |    2 +-
 fs/nfs/nfs4proc.c                                 |    1 +
 fs/nfsd/nfs4state.c                               |    4 +-
 include/linux/pci.h                               |    2 +
 include/linux/swapops.h                           |    8 +-
 include/linux/usb/hcd.h                           |    2 -
 kernel/panic.c                                    |    4 +-
 kernel/time/ntp.c                                 |    2 +-
 kernel/trace/trace.c                              |    2 +-
 mm/swapfile.c                                     |   12 +--
 net/9p/trans_virtio.c                             |    2 +-
 net/sunrpc/rpc_pipe.c                             |   12 +--
 net/sunrpc/svc.c                                  |    3 +-
 sound/soc/codecs/wm8904.c                         |   13 +--
 69 files changed, 385 insertions(+), 248 deletions(-)

