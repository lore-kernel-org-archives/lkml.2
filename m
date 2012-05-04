Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2EDUnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:43:13 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:41314 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627Ab2EDUnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:43:10 -0400
Date: Fri, 4 May 2012 13:43:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/47] 3.0.31-stable review
Message-ID: <20120504204307.GA13761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.31 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May  6 20:42:43 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.31-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                      |    4 +-
 arch/arm/include/asm/tls.h                    |    4 +
 arch/x86/kernel/apic/apic.c                   |   34 ++--
 arch/x86/xen/smp.c                            |   15 ++
 arch/x86/xen/xen-asm.S                        |    2 +-
 drivers/ata/libata-eh.c                       |    3 +-
 drivers/dma/at_hdmac.c                        |    4 -
 drivers/firmware/efivars.c                    |  222 +++++++++++++++++++++++--
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c             |   34 ++--
 drivers/hwmon/coretemp.c                      |    6 +-
 drivers/hwmon/fam15h_power.c                  |   42 +++++
 drivers/i2c/busses/i2c-pnx.c                  |    3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c            |    3 +-
 drivers/net/wireless/ipw2x00/ipw2200.c        |   13 +-
 drivers/net/wireless/rtlwifi/pci.c            |    1 +
 drivers/net/wireless/wl1251/main.c            |    1 +
 drivers/net/wireless/wl1251/sdio.c            |    2 +-
 drivers/scsi/libsas/sas_expander.c            |   26 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    3 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    8 +
 drivers/usb/class/cdc-wdm.c                   |    7 +-
 drivers/usb/core/hcd-pci.c                    |    9 +
 drivers/usb/gadget/f_mass_storage.c           |    2 +-
 drivers/usb/gadget/file_storage.c             |    2 +-
 drivers/usb/gadget/uvc.h                      |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                 |    2 +-
 drivers/usb/host/ehci-hcd.c                   |    2 +-
 drivers/usb/host/ehci-pci.c                   |    8 +
 drivers/usb/host/fsl-mph-dr-of.c              |    1 +
 fs/autofs4/autofs_i.h                         |   12 +-
 fs/autofs4/dev-ioctl.c                        |    3 +-
 fs/autofs4/inode.c                            |    4 +-
 fs/autofs4/waitq.c                            |   20 +--
 fs/nfs/nfs4proc.c                             |   23 ++-
 fs/nfs/super.c                                |    8 +-
 fs/nfsd/nfs4proc.c                            |    7 +-
 fs/nfsd/nfs4state.c                           |   23 +--
 fs/pipe.c                                     |   31 +++-
 include/linux/efi.h                           |   13 +-
 include/linux/kvm_host.h                      |    6 +
 include/linux/pipe_fs_i.h                     |    1 +
 include/linux/usb/hcd.h                       |    2 +
 kernel/sched.c                                |   53 +++---
 net/mac80211/tx.c                             |    3 +-
 net/wireless/nl80211.c                        |   29 ++--
 scripts/mod/file2alias.c                      |    4 +
 sound/soc/soc-dapm.c                          |    2 +
 virt/kvm/iommu.c                              |   12 +-
 virt/kvm/kvm_main.c                           |    5 +-
 51 files changed, 570 insertions(+), 165 deletions(-)

