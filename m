Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0EXXTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:19:00 -0400
Received: from kroah.org ([198.145.64.141]:33897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab0EXXS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:18:59 -0400
Date: Mon, 24 May 2010 16:18:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/39] 2.6.33.5-stable review
Message-ID: <20100524231840.GA17857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---- NOTE ----
I have only included patches that were released in kernels up to the
2.6.34 release.  Nothing that was requested to be in a stable release
that showed up in Linus's tree _after_ 2.6.34 has been included here, I
had to draw the line somewhere.
--------------

This is the start of the stable review cycle for the 2.6.33.5
release.  There are 39 patches in this series, all will be posted as a
response to this one.  If anyone has any issues with these being
applied, please let us know.  If anyone is a maintainer of the proper
subsystem, and wants to add a Signed-off-by: line to the patch, please
respond with it.

Responses should be made by Wed May 26, 22:00:00 UTC 2010
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/filesystems/proc.txt        |    3 +-
 Makefile                                  |    2 +-
 arch/powerpc/include/asm/hw_irq.h         |   38 --------
 arch/powerpc/kernel/asm-offsets.c         |    1 -
 arch/powerpc/kernel/entry_64.S            |    9 --
 arch/powerpc/kernel/irq.c                 |    6 -
 arch/powerpc/kernel/time.c                |   60 ++++++++++---
 arch/s390/kernel/ptrace.c                 |    5 +-
 arch/x86/include/asm/k8.h                 |    5 +
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 +
 arch/x86/kernel/process.c                 |   12 ++-
 crypto/authenc.c                          |   16 ++-
 drivers/acpi/sleep.c                      |   90 +------------------
 drivers/char/tty_io.c                     |    1 +
 drivers/gpu/drm/i915/i915_drv.c           |    4 +-
 drivers/gpu/drm/i915/i915_drv.h           |    4 +
 drivers/gpu/drm/i915/i915_gem.c           |  145 ++++++++++++++++++++++++++---
 drivers/gpu/drm/i915/i915_irq.c           |    8 +-
 drivers/gpu/drm/i915/i915_reg.h           |   11 ++
 drivers/gpu/drm/i915/intel_display.c      |    2 +-
 drivers/hwmon/hp_accel.c                  |    2 +-
 drivers/mmc/host/atmel-mci.c              |   14 ++-
 drivers/net/wireless/ath/ath9k/xmit.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    5 +
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    5 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   15 +++-
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   18 +++-
 drivers/s390/block/dasd.c                 |   17 ++--
 drivers/serial/imx.c                      |   10 ++-
 drivers/video/bfin-t350mcqb-fb.c          |   15 ++--
 fs/btrfs/ioctl.c                          |    5 +
 fs/cachefiles/security.c                  |    4 +
 fs/cifs/cifsglob.h                        |    1 +
 fs/cifs/inode.c                           |   21 ++++-
 fs/compat.c                               |    2 -
 fs/exec.c                                 |    2 -
 fs/nilfs2/super.c                         |    1 +
 fs/notify/inotify/inotify_fsnotify.c      |    2 +
 fs/notify/inotify/inotify_user.c          |    9 +-
 fs/proc/array.c                           |    3 +-
 fs/proc/task_mmu.c                        |   19 ----
 include/asm-generic/dma-mapping-common.h  |    4 +-
 include/linux/sched.h                     |    1 -
 kernel/fork.c                             |    2 -
 kernel/profile.c                          |    4 +-
 mm/hugetlb.c                              |    2 +-
 net/ipv4/udp.c                            |    6 +-
 security/min_addr.c                       |    2 +-
 sound/pci/hda/hda_intel.c                 |    1 +
 sound/pci/hda/patch_conexant.c            |    7 +-
 sound/pci/hda/patch_realtek.c             |    1 -
 sound/pci/hda/patch_sigmatel.c            |    6 +-
 sound/pci/ice1712/maya44.c                |    6 +-
 sound/pci/oxygen/xonar_cs43xx.c           |    3 +
 54 files changed, 372 insertions(+), 273 deletions(-)
