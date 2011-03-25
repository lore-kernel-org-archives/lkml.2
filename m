Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1CYXvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:51:23 -0400
Received: from kroah.org ([198.145.64.141]:44130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab1CYXvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:51:12 -0400
Date: Fri, 25 Mar 2011 16:48:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/55] 2.6.37.6-stable review
Message-ID: <20110325234853.GA21145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.37.6 release.

Note, this is the LAST 2.6.37 kernel release, after this one it is
"end-of-life" or whatever your favorite term is for "not being updated
anymore and you shouldn't be using it unless someone else is in charge
of maintaining it for you."

There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by @date (day, month date, time)@ UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                   |    2 +-
 arch/sh/kernel/ptrace_32.c                 |    8 ++
 arch/sh/kernel/ptrace_64.c                 |    6 +
 arch/x86/include/asm/msr-index.h           |    5 +
 arch/x86/kernel/head64.c                   |    3 -
 arch/x86/kernel/setup.c                    |    5 +
 arch/x86/mm/init.c                         |   19 ----
 arch/x86/mm/init_64.c                      |   11 +-
 arch/x86/xen/mmu.c                         |   13 ++-
 drivers/firmware/dcdbas.c                  |    4 +-
 drivers/gpu/drm/drm_crtc.c                 |   51 +++++++++
 drivers/gpu/drm/drm_gem.c                  |    5 +-
 drivers/gpu/drm/i915/i915_gem.c            |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c     |    6 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |   21 +++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   30 +++++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 drivers/idle/intel_idle.c                  |   24 +++++
 drivers/input/xen-kbdfront.c               |   45 +++++----
 drivers/media/video/uvc/uvc_driver.c       |    8 ++
 drivers/media/video/uvc/uvc_video.c        |   14 ++-
 drivers/pci/hotplug/acpiphp_glue.c         |    1 +
 drivers/usb/class/cdc-acm.c                |    7 +-
 drivers/usb/class/cdc-wdm.c                |    2 +-
 drivers/usb/core/devio.c                   |    2 +-
 drivers/usb/host/ehci-q.c                  |   12 --
 drivers/usb/misc/uss720.c                  |    7 +-
 drivers/video/console/tileblit.c           |    2 +-
 fs/aio.c                                   |    4 +-
 fs/dcache.c                                |    3 +
 fs/ext3/super.c                            |    7 ++
 fs/ext4/super.c                            |    8 ++
 fs/nfs/write.c                             |   31 ++++--
 fs/nfsd/nfs4proc.c                         |    4 +-
 fs/nfsd/nfs4state.c                        |  155 +++++++++++++++-------------
 fs/nfsd/nfs4xdr.c                          |    5 +-
 fs/proc/array.c                            |    4 +-
 fs/proc/task_mmu.c                         |    4 +-
 fs/super.c                                 |    2 +
 fs/sync.c                                  |    4 +-
 include/linux/ethtool.h                    |   34 ++++++
 kernel/cgroup.c                            |   14 +--
 kernel/perf_event.c                        |   13 ++-
 kernel/signal.c                            |   16 ++-
 kernel/sysctl.c                            |   18 +++-
 mm/backing-dev.c                           |    2 +-
 mm/oom_kill.c                              |   50 ++++++----
 mm/shmem.c                                 |    1 +
 mm/slab.c                                  |    8 +-
 mm/swapfile.c                              |    7 +-
 net/socket.c                               |  114 +++++++++++++++++++--
 net/sunrpc/xprtsock.c                      |    2 +
 sound/pci/hda/patch_sigmatel.c             |   18 +++
 sound/pci/hda/patch_via.c                  |   53 ++++++++--
 54 files changed, 646 insertions(+), 255 deletions(-)
