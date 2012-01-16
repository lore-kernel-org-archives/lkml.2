Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2APSp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:45:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54946 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831Ab2APSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:45:57 -0500
X-Sasl-enc: 0LCvIclXfDXA4Rht8XgYZdu1xSV8kM5eEbblGahVD+ni 1326739556
Date: Mon, 16 Jan 2012 10:45:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/48] 3.1.10-stable review
Message-ID: <20120116184527.GA11972@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this is the LAST 3.1.y stable release.  Everyone should move to
the 3.2 kernel series now.

This is the start of the stable review cycle for the 3.1.10 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, January 18, 2012, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/virtual/kvm/api.txt           |    7 ++
 Makefile                                    |    4 +-
 arch/x86/include/asm/amd_nb.h               |    2 +
 arch/x86/kernel/amd_nb.c                    |   31 +++++++++
 arch/x86/kernel/kvmclock.c                  |    5 +-
 arch/x86/kvm/i8254.c                        |   10 ++-
 arch/x86/mm/mmap.c                          |    4 +-
 arch/x86/pci/Makefile                       |    3 +-
 arch/x86/pci/acpi.c                         |   18 +++++-
 arch/x86/pci/amd_bus.c                      |   42 +++---------
 drivers/gpu/drm/radeon/r100.c               |    5 +-
 drivers/gpu/drm/radeon/r600_hdmi.c          |    7 ++
 drivers/gpu/drm/radeon/radeon_device.c      |    5 +-
 drivers/gpu/drm/radeon/rs600.c              |    4 +-
 drivers/hid/Kconfig                         |    1 +
 drivers/hid/hid-core.c                      |    2 +-
 drivers/md/raid1.c                          |   11 +++-
 drivers/mtd/mtd_blkdevs.c                   |    3 +-
 drivers/mtd/mtdoops.c                       |    5 +-
 drivers/mtd/tests/mtd_stresstest.c          |    7 ++
 drivers/mtd/ubi/eba.c                       |    6 +-
 drivers/mtd/ubi/ubi.h                       |    2 +
 drivers/mtd/ubi/wl.c                        |   12 ++-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c |    4 +
 drivers/pci/msi.c                           |   10 +++
 drivers/platform/x86/ideapad-laptop.c       |    2 +
 drivers/pnp/quirks.c                        |   42 ++++++++++++
 drivers/rtc/interface.c                     |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   83 ++++++++----------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   11 ++--
 drivers/xen/xenbus/xenbus_xs.c              |    6 ++
 fs/ext4/super.c                             |    7 +-
 fs/nfs/callback_proc.c                      |    2 +-
 fs/nfs/file.c                               |    4 +-
 fs/nfs/nfs4proc.c                           |   96 ++++++++++++++++-----------
 fs/nfs/nfs4xdr.c                            |   31 +++++++--
 fs/nfs/super.c                              |   43 +++++-------
 include/linux/memcontrol.h                  |    6 ++
 include/linux/nfs_xdr.h                     |    5 ++
 include/linux/pci_regs.h                    |    2 +-
 include/linux/sunrpc/xdr.h                  |    2 +
 include/xen/interface/io/xs_wire.h          |    3 +
 init/do_mounts.c                            |   35 +++++++++-
 mm/filemap.c                                |   18 +-----
 mm/memcontrol.c                             |   44 ++++++++++++
 mm/slub.c                                   |    5 ++
 net/mac80211/wpa.c                          |    2 +-
 net/sunrpc/xdr.c                            |    3 +-
 security/integrity/ima/ima_api.c            |    4 +-
 security/integrity/ima/ima_queue.c          |   17 ++++--
 sound/pci/hda/hda_local.h                   |    7 ++-
 sound/pci/hda/hda_proc.c                    |    2 +
 sound/pci/hda/patch_cirrus.c                |   27 ++------
 sound/pci/hda/patch_conexant.c              |    2 -
 sound/pci/hda/patch_sigmatel.c              |   36 +++++++----
 sound/pci/hda/patch_via.c                   |    5 +-
 sound/pci/ice1712/amp.c                     |    7 ++-
 sound/usb/usx2y/usb_stream.c                |    6 +-
 virt/kvm/assigned-dev.c                     |   93 +++++++++++++++++++++++---
 59 files changed, 591 insertions(+), 281 deletions(-)

