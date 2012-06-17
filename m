Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab2FQSkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:40:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850Ab2FQSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:00 -0400
Message-Id: <20120617175941.281333656@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/69] 3.2.21-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.21 release.
There are 69 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jun 19 21:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.20 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Makefile                                      |    4 +-
 arch/arm/mach-imx/hotplug.c                   |   42 +++++++++-
 arch/arm/mach-imx/mach-mx21ads.c              |    2 +-
 arch/arm/mach-mx5/crm_regs.h                  |    2 +-
 arch/powerpc/kernel/module_32.c               |   11 ++-
 arch/x86/crypto/aesni-intel_asm.S             |    6 +-
 arch/x86/include/asm/uv/uv_bau.h              |    1 -
 arch/x86/kernel/cpu/amd.c                     |   18 +++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c          |   55 ++++++++++---
 arch/x86/platform/uv/tlb_uv.c                 |    1 -
 arch/x86/xen/enlighten.c                      |    8 ++
 drivers/char/agp/intel-agp.c                  |    1 +
 drivers/char/agp/intel-agp.h                  |    1 +
 drivers/char/hw_random/atmel-rng.c            |    7 ++
 drivers/gpu/drm/i915/i915_drv.c               |    6 +-
 drivers/gpu/drm/i915/i915_drv.h               |    3 +
 drivers/gpu/drm/i915/i915_reg.h               |    8 ++
 drivers/gpu/drm/i915/intel_display.c          |   69 ++++++++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   20 ++++-
 drivers/gpu/drm/nouveau/nouveau_connector.c   |   55 +++++++++++++
 drivers/gpu/drm/radeon/evergreen.c            |    3 +
 drivers/gpu/drm/radeon/evergreend.h           |    1 +
 drivers/gpu/drm/radeon/r600.c                 |    1 +
 drivers/gpu/drm/radeon/r600d.h                |    1 +
 drivers/gpu/drm/radeon/rv770.c                |    5 +-
 drivers/gpu/drm/radeon/rv770d.h               |    3 +
 drivers/hwmon/fam15h_power.c                  |    8 +-
 drivers/net/can/c_can/c_can.c                 |   16 ++--
 drivers/net/can/c_can/c_can.h                 |    1 +
 drivers/net/usb/sierra_net.c                  |   14 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   22 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 ++
 drivers/net/wireless/rt2x00/rt2x00.h          |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |    1 -
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   13 ++-
 drivers/pci/pci.c                             |    5 ++
 drivers/pci/quirks.c                          |   26 ++++++
 drivers/scsi/mpt2sas/mpt2sas_base.c           |    2 +-
 drivers/target/target_core_alua.c             |    8 +-
 drivers/usb/class/cdc-acm.c                   |    8 ++
 drivers/usb/class/cdc-wdm.c                   |   25 ++++++
 drivers/usb/core/hcd-pci.c                    |    9 ---
 drivers/usb/core/message.c                    |    3 +-
 drivers/usb/host/ehci-hcd.c                   |    3 +
 drivers/usb/host/ehci-pci.c                   |    8 --
 drivers/usb/host/xhci-mem.c                   |   74 ++++++-----------
 drivers/usb/host/xhci.c                       |    8 +-
 drivers/usb/musb/musb_gadget.c                |    1 +
 drivers/usb/serial/cp210x.c                   |    1 +
 drivers/usb/serial/ftdi_sio.c                 |    1 +
 drivers/usb/serial/ftdi_sio_ids.h             |    1 +
 drivers/usb/serial/mct_u232.c                 |   13 +--
 drivers/usb/serial/option.c                   |   96 +++++++++++-----------
 drivers/usb/serial/qcserial.c                 |    6 ++
 drivers/usb/serial/sierra.c                   |    4 +
 drivers/usb/serial/usb-serial.c               |    6 +-
 drivers/usb/storage/unusual_devs.h            |    7 ++
 fs/fuse/dir.c                                 |    1 +
 fs/fuse/fuse_i.h                              |    3 +
 fs/fuse/inode.c                               |   17 +++-
 fs/nfs/nfs4proc.c                             |    1 +
 include/linux/pci.h                           |    2 +
 include/linux/swapops.h                       |    8 +-
 include/linux/usb/hcd.h                       |    2 -
 kernel/sched.c                                |    9 +--
 mm/swapfile.c                                 |   12 +--
 net/mac80211/iface.c                          |   12 +++
 net/mac80211/offchannel.c                     |   16 ++++
 net/sunrpc/svc.c                              |    3 +-
 net/wireless/util.c                           |   19 ++++-
 sound/pci/hda/hda_codec.h                     |    1 +
 sound/pci/hda/hda_local.h                     |    2 +
 sound/pci/hda/patch_realtek.c                 |   52 ++++++++++--
 sound/soc/codecs/wm8994.c                     |  105 ++++++++++++++++---------
 77 files changed, 728 insertions(+), 275 deletions(-)

-- 
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

