Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1CUXMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:12:40 -0400
Received: from kroah.org ([198.145.64.141]:48895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1CUXMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:12:37 -0400
Date: Mon, 21 Mar 2011 16:11:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/44] 2.6.32.34-longterm review
Message-ID: <20110321231105.GA1744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.34 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, March 23, 2011, 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.34-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/i2c/instantiating-devices |    2 +-
 Makefile                                |    2 +-
 arch/mips/alchemy/mtx-1/platform.c      |    9 +++
 arch/parisc/kernel/irq.c                |    2 +-
 arch/powerpc/include/asm/kexec.h        |    4 +
 arch/powerpc/include/asm/paca.h         |    3 +-
 arch/powerpc/include/asm/reg.h          |    1 +
 arch/powerpc/kernel/asm-offsets.c       |    1 +
 arch/powerpc/kernel/crash.c             |   27 +++++++
 arch/powerpc/kernel/machine_kexec_64.c  |   48 +++++++++----
 arch/powerpc/kernel/misc_64.S           |    8 ++-
 arch/powerpc/kernel/paca.c              |    2 +
 arch/powerpc/kernel/perf_event.c        |   24 ++++++-
 arch/powerpc/kernel/rtas_flash.c        |   39 ++++++-----
 arch/x86/include/asm/pgtable-3level.h   |   11 +--
 arch/x86/kernel/e820.c                  |   10 ++-
 arch/x86/kernel/early-quirks.c          |    7 ++-
 arch/x86/kernel/entry_64.S              |    2 +-
 arch/x86/mm/fault.c                     |    7 ++
 arch/x86/mm/pgtable.c                   |    3 +-
 drivers/ata/ahci.c                      |    5 ++
 drivers/ata/libata-core.c               |   24 ++++---
 drivers/hwmon/f71882fg.c                |    2 +-
 drivers/hwmon/sht15.c                   |    4 +-
 drivers/infiniband/core/cm.c            |    1 +
 drivers/infiniband/core/cma.c           |   15 ++++
 drivers/isdn/i4l/isdn_tty.c             |    6 --
 drivers/mmc/core/sdio.c                 |    8 ++
 drivers/mtd/chips/jedec_probe.c         |   32 +++++-----
 drivers/mtd/nand/omap2.c                |    2 +-
 drivers/mtd/onenand/generic.c           |    2 +-
 drivers/mtd/onenand/omap2.c             |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    4 +-
 drivers/pci/pci-sysfs.c                 |    2 +-
 drivers/pci/quirks.c                    |  113 ++++++++++++++----------------
 drivers/usb/host/xhci-ring.c            |   14 ++++
 drivers/usb/serial/ch341.c              |    1 +
 drivers/usb/serial/kobil_sct.c          |    2 +-
 fs/ext3/namei.c                         |    2 +-
 include/linux/ftrace.h                  |    2 +
 kernel/perf_event.c                     |    2 +
 kernel/sched.c                          |    2 +-
 kernel/smp.c                            |   55 ++++++++++++---
 kernel/trace/ftrace.c                   |   52 ++++++++++++--
 net/sunrpc/sched.c                      |   14 ++--
 sound/pci/ctxfi/ctatc.c                 |    2 +-
 sound/pci/ctxfi/ctdaio.c                |    2 +
 sound/pci/ctxfi/ctmixer.c               |   19 ++----
 sound/pci/hda/patch_sigmatel.c          |   11 ++-
 49 files changed, 413 insertions(+), 201 deletions(-)
