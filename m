Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2LGAym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:54:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2LGAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:54:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/20] 3.4.23-stable review
Date: Thu,  6 Dec 2012 16:54:15 -0800
Message-Id: <20121207005232.756641002@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.23 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  9 00:50:03 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.23-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.23-rc1

Michal Marek <mmarek@suse.cz>
    kbuild: Do not package /boot and /lib in make tar-pkg

Peng Tao <bergwolf@gmail.com>
    pnfsblock: fix partial page buffer wirte

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Calvin Walton <calvin.walton@kepstin.ca>
    i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Alan Cox <alan@linux.intel.com>
    ACPI: missing break

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/mm: have 16 byte aligned struct pages

Ariel Elior <ariele@broadcom.com>
    bnx2x: remove redundant warning log

Mike Galbraith <efault@gmx.de>
    Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Jean Delvare <jdelvare@suse.de>
    i7300_edac: Fix error flag testing

NeilBrown <neilb@suse.de>
    md/raid10: close race that lose writes lost when replacement completes.

Mike Galbraith <mgalbraith@suse.de>
    workqueue: exit rescuer_thread() as TASK_RUNNING

Vincent Palatin <vpalatin@chromium.org>
    x86, fpu: Avoid FPU lazy restore after suspend

Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    ARM: Kirkwood: Update PCI-E fixup

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: soft offline: split thp at the beginning of soft_offline_page()

Jianguo Wu <wujianguo@huawei.com>
    mm/vmemmap: fix wrong use of virt_to_page

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce4+: don't use radeon_crtc for vblank callback

Russell King - ARM Linux <linux@arm.linux.org.uk>
    Dove: Fix irq_to_pmu()

Russell King - ARM Linux <linux@arm.linux.org.uk>
    Dove: Attempt to fix PMU/RTC interrupts


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/Kconfig                                 |   1 +
 arch/arm/mach-dove/include/mach/pm.h             |   2 +-
 arch/arm/mach-dove/irq.c                         |  14 ++-
 arch/arm/mach-kirkwood/pcie.c                    |  11 ++-
 arch/s390/Kconfig                                |   1 +
 arch/x86/include/asm/fpu-internal.h              |  15 +--
 arch/x86/kernel/smpboot.c                        |   5 +
 drivers/acpi/processor_driver.c                  |   1 +
 drivers/edac/i7300_edac.c                        |   8 +-
 drivers/gpu/drm/i915/intel_lvds.c                |  16 ++++
 drivers/gpu/drm/radeon/evergreen.c               | 191 +++++++++++++++++++------------------
 drivers/gpu/drm/radeon/evergreen_reg.h           |   2 +
 drivers/gpu/drm/radeon/evergreend.h              |   7 ++
 drivers/gpu/drm/radeon/radeon_asic.h             |   1 +
 drivers/md/raid10.c                              | 100 ++++++++++---------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  11 ++-
 fs/nfs/blocklayout/blocklayout.c                 | 176 +++++++++++++++++++++++++++++++---
 fs/nfs/blocklayout/blocklayout.h                 |   1 +
 kernel/sched/auto_group.c                        |   4 -
 kernel/sched/auto_group.h                        |   5 -
 kernel/workqueue.c                               |   4 +-
 mm/memory-failure.c                              |   8 ++
 mm/sparse.c                                      |  10 +-
 scripts/package/buildtar                         |   2 +-
 25 files changed, 408 insertions(+), 192 deletions(-)


