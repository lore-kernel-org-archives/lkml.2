Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab1LPTsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:48:16 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49026 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759843Ab1LPTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:07 -0500
X-Sasl-enc: HFusRuqDMhGM4VqopMv+qrR7Dl07nLaA6ghf26/mGPxr 1324064886
Date: Fri, 16 Dec 2011 11:46:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/53] 3.1.6-stable review
Message-ID: <20111216194613.GA18395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.1.6 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by December 19, 2011, 18:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.X-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                   |    4 +-
 arch/arm/kernel/setup.c                    |   12 ++--
 arch/arm/mach-at91/at91rm9200_devices.c    |    2 +-
 arch/arm/mach-at91/at91sam9260.c           |    6 +-
 arch/arm/mach-at91/at91sam9260_devices.c   |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c   |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c   |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c    |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c   |    6 +-
 arch/arm/mach-mxs/include/mach/mxs.h       |    1 +
 arch/x86/include/asm/system.h              |    1 +
 arch/x86/kernel/hpet.c                     |   21 ++++++---
 arch/x86/kernel/process.c                  |    8 +++
 arch/x86/mm/gup.c                          |    2 +
 arch/x86/xen/setup.c                       |   20 ++++++--
 drivers/firmware/iscsi_ibft.c              |   42 ++++++++++++++++-
 drivers/firmware/iscsi_ibft_find.c         |   26 +---------
 drivers/gpu/drm/radeon/atombios_crtc.c     |   53 +++++++-------------
 drivers/gpu/drm/radeon/atombios_dp.c       |    9 +++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   16 +++----
 drivers/gpu/drm/radeon/radeon_display.c    |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c   |   11 ++--
 drivers/gpu/drm/radeon/radeon_mode.h       |    4 +-
 drivers/hwmon/jz4740-hwmon.c               |    2 +-
 drivers/mmc/host/mxcmmc.c                  |    1 +
 drivers/ptp/ptp_clock.c                    |    4 +-
 drivers/rtc/rtc-s3c.c                      |    2 +-
 drivers/staging/rtl8712/usb_intf.c         |    1 +
 drivers/target/iscsi/iscsi_target.c        |   11 +++--
 drivers/target/iscsi/iscsi_target_core.h   |    1 -
 drivers/target/target_core_cdb.c           |    2 +-
 drivers/target/target_core_file.c          |   12 ++--
 drivers/target/target_core_transport.c     |   21 +++++++-
 drivers/usb/class/cdc-acm.c                |   10 ++++
 drivers/usb/serial/option.c                |    7 ++-
 fs/cifs/readdir.c                          |   10 +++-
 fs/dcache.c                                |   71 +++++++++++++++++-----------
 fs/ext4/inode.c                            |   13 +++--
 fs/ext4/page-io.c                          |   12 +++++
 fs/ext4/super.c                            |   17 +++----
 fs/fuse/dev.c                              |    3 +-
 fs/fuse/file.c                             |    2 +-
 fs/hfs/btree.c                             |   20 ++++++--
 fs/jbd/journal.c                           |    8 +++
 fs/jbd2/journal.c                          |    8 +++
 fs/namespace.c                             |   20 ++++----
 fs/proc/meminfo.c                          |    7 ++-
 fs/seq_file.c                              |    6 +-
 include/drm/drm_pciids.h                   |   10 ++++
 include/linux/dcache.h                     |    3 +-
 include/linux/fs.h                         |    1 +
 include/linux/log2.h                       |    1 -
 kernel/lockdep.c                           |    8 +++-
 kernel/time/alarmtimer.c                   |    2 +-
 mm/hugetlb.c                               |    1 +
 mm/page_alloc.c                            |   10 +++-
 mm/percpu-vm.c                             |   12 ++--
 mm/percpu.c                                |   34 ++++++++------
 mm/vmalloc.c                               |    2 +
 security/apparmor/path.c                   |   65 +++++++++++++++-----------
 security/tomoyo/realpath.c                 |   13 ++++-
 sound/pci/hda/patch_realtek.c              |    2 +
 sound/pci/hda/patch_sigmatel.c             |   45 +++++++++--------
 sound/pci/sis7019.c                        |   64 +++++++++++++++++++++----
 sound/soc/soc-utils.c                      |   31 ++++++++++++-
 65 files changed, 549 insertions(+), 281 deletions(-)
