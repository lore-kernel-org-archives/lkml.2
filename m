Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2LNW0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:26:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:38014 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab2LNW0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:26:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/22] 3.0.57-stable review
Date: Fri, 14 Dec 2012 14:25:45 -0800
Message-Id: <20121214222249.889051473@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.57 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec 16 22:16:57 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.57-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.57-rc1

Anton Blanchard <anton@samba.org>
    powerpc: Keep thread.dscr and thread.dscr_inherit in sync

Anton Blanchard <anton@samba.org>
    powerpc: Update DSCR on all CPUs when writing sysfs dscr_default

Dan Carpenter <dan.carpenter@oracle.com>
    ftrace: Clear bits properly in reset_iter_read()

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Extend Fresco Logic MSI quirk.

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: workaround for hardware bug: retired TDs not added to the Done Queue

Zhang Rui <rui.zhang@intel.com>
    ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PNP: Do not crash due to stale pointer use during system resume

Kamil Iskra <kamil@iskra.name>
    ACPI / battery: Correct battery capacity values on Thinkpads

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: mark uas driver as BROKEN

Markus Becker <mab@comnets.uni-bremen.de>
    USB: cp210x: add Virtenio Preon32 device id

Peter Korsgaard <jacmet@sunsite.dk>
    usb: ftdi_sio: fixup BeagleBone A5+ quirk

Martin Teichmann <lkb.teichmann@gmail.com>
    USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on Huawei E173

li.rui27@zte.com.cn <li.rui27@zte.com.cn>
    USB: add new zte 3g-dongle's pid to option.c

Jan Beulich <JBeulich@suse.com>
    x86: hpet: Fix masking of MSI interrupts

Mel Gorman <mgorman@suse.de>
    tmpfs: fix shared mempolicy leak

Dan Carpenter <dan.carpenter@oracle.com>
    telephony: ijx: buffer overflow in ixj_write_cid()

Boris Ostrovsky <boris.ostrovsky@amd.com>
    x86,AMD: Power driver support for AMD's family 16h processors

Marek Szyprowski <m.szyprowski@samsung.com>
    mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Tejun Heo <tj@kernel.org>
    workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/ptrace: Fix build with gcc 4.6

Paul Walmsley <paul@pwsan.com>
    ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and CONFIG_VFPv3 set


-------------

Diffstat:

 Makefile                          |  4 +-
 arch/arm/include/asm/hwcap.h      |  3 +-
 arch/arm/include/asm/vfpmacros.h  | 12 +++---
 arch/arm/vfp/vfpmodule.c          |  9 +++--
 arch/powerpc/kernel/ptrace.c      | 18 +++++++--
 arch/powerpc/kernel/sysfs.c       | 10 +++++
 arch/powerpc/kernel/traps.c       |  3 +-
 arch/x86/kernel/hpet.c            |  4 +-
 drivers/acpi/battery.c            | 77 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/video.c              | 14 +++++++
 drivers/hwmon/fam15h_power.c      |  4 ++
 drivers/pnp/pnpacpi/core.c        |  3 ++
 drivers/telephony/ixj.c           | 24 ++++++------
 drivers/usb/host/ohci-q.c         | 19 ++++++++++
 drivers/usb/host/xhci-pci.c       |  7 +++-
 drivers/usb/serial/cp210x.c       |  1 +
 drivers/usb/serial/ftdi_sio.c     |  3 +-
 drivers/usb/serial/ftdi_sio_ids.h |  6 +++
 drivers/usb/serial/option.c       | 25 +++++++++++++
 drivers/usb/storage/Kconfig       |  2 +-
 include/linux/mempolicy.h         | 16 --------
 kernel/trace/ftrace.c             |  2 +-
 kernel/workqueue.c                |  4 +-
 mm/dmapool.c                      | 31 ++++------------
 mm/mempolicy.c                    | 22 -----------
 mm/shmem.c                        | 22 ++++++-----
 26 files changed, 236 insertions(+), 109 deletions(-)


