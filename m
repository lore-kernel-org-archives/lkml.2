Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2LNW2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:28:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:38451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2LNW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:28:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/28] 3.4.24-stable review
Date: Fri, 14 Dec 2012 14:26:17 -0800
Message-Id: <20121214222250.501309822@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.24 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec 16 22:16:59 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.24-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.24-rc1

Eric Dumazet <edumazet@google.com>
    rcu: Fix batch-limit size problem

Zheng Liu <gnehzuil.liu@gmail.com>
    perf test: fix a build error on builtin-test

Dan Williams <dcbw@redhat.com>
    cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)

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

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.

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

Dan Carpenter <dan.carpenter@oracle.com>
    telephony: ijx: buffer overflow in ixj_write_cid()

Boris Ostrovsky <boris.ostrovsky@amd.com>
    x86,AMD: Power driver support for AMD's family 16h processors

Marek Szyprowski <m.szyprowski@samsung.com>
    mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Jani Nikula <jani.nikula@intel.com>
    drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jani Nikula <jani.nikula@intel.com>
    drm/i915: do not ignore eDP bpc settings from vbt

Tejun Heo <tj@kernel.org>
    workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: dmaengine: Correct Makefile when sound is built as module

Paul Walmsley <paul@pwsan.com>
    ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and CONFIG_VFPv3 set

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    mmc: sh-mmcif: avoid oops on spurious interrupts (second try)

Chris Ball <cjb@laptop.org>
    Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Mel Gorman <mgorman@suse.de>
    tmpfs: fix shared mempolicy leak


-------------

Diffstat:

 Makefile                             |  4 +-
 arch/arm/include/asm/hwcap.h         |  3 +-
 arch/arm/include/asm/vfpmacros.h     | 12 +++---
 arch/arm/vfp/vfpmodule.c             |  9 +++--
 arch/x86/kernel/hpet.c               |  4 +-
 drivers/acpi/battery.c               | 77 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/sleep.c                 |  8 ++++
 drivers/acpi/video.c                 | 14 +++++++
 drivers/gpu/drm/i915/intel_bios.c    | 11 +-----
 drivers/gpu/drm/i915/intel_display.c | 11 ++++++
 drivers/hwmon/fam15h_power.c         |  4 ++
 drivers/mmc/host/sh_mmcif.c          |  8 +---
 drivers/pnp/pnpacpi/core.c           |  3 ++
 drivers/staging/telephony/ixj.c      | 24 +++++------
 drivers/usb/class/cdc-acm.c          | 38 ++++++++++++++++++
 drivers/usb/host/ohci-q.c            | 19 +++++++++
 drivers/usb/host/xhci-pci.c          |  7 +++-
 drivers/usb/serial/cp210x.c          |  1 +
 drivers/usb/serial/ftdi_sio.c        |  3 +-
 drivers/usb/serial/ftdi_sio_ids.h    |  6 +++
 drivers/usb/serial/option.c          | 25 ++++++++++++
 drivers/usb/storage/Kconfig          |  2 +-
 include/linux/mempolicy.h            | 16 --------
 kernel/rcutree.c                     | 14 +++----
 kernel/trace/ftrace.c                |  2 +-
 kernel/workqueue.c                   |  4 +-
 mm/dmapool.c                         | 31 ++++-----------
 mm/mempolicy.c                       | 22 -----------
 mm/shmem.c                           | 26 +++++++-----
 sound/soc/Makefile                   |  5 ++-
 tools/perf/builtin-test.c            | 38 ++++++------------
 31 files changed, 296 insertions(+), 155 deletions(-)


