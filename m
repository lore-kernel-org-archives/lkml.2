Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030990Ab2HGWpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:45:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030952Ab2HGWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:45:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/49] 3.0.40-stable review
Date: Tue,  7 Aug 2012 15:44:18 -0700
Message-Id: <20120807222026.848194739@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.0.40 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug  9 22:20:25 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.40-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/stable_kernel_rules.txt      |   19 ++++++++---
 Makefile                                   |    4 +--
 arch/arm/mach-omap2/opp.c                  |    3 +-
 arch/m68k/include/asm/entry_mm.h           |    4 +--
 arch/m68k/kernel/sys_m68k.c                |    8 +++--
 arch/powerpc/include/asm/cputime.h         |    6 ++--
 arch/powerpc/include/asm/reg.h             |    3 +-
 arch/powerpc/kernel/ftrace.c               |   12 +++----
 arch/powerpc/kernel/time.c                 |   10 +++---
 drivers/acpi/ac.c                          |    4 ++-
 drivers/gpu/drm/radeon/atombios_dp.c       |   10 ++++--
 drivers/gpu/drm/radeon/radeon_connectors.c |   35 ++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_cursor.c     |    8 ++++-
 drivers/mmc/host/sdhci-pci.c               |    1 +
 drivers/net/bnx2.c                         |    6 ++--
 drivers/net/caif/caif_serial.c             |    3 ++
 drivers/net/tun.c                          |    6 ++--
 drivers/net/usb/kaweth.c                   |    2 +-
 drivers/scsi/libsas/sas_expander.c         |   47 +++++++++----------------
 drivers/scsi/scsi_error.c                  |   14 ++++++++
 drivers/scsi/scsi_lib.c                    |   11 ++++++
 drivers/scsi/scsi_scan.c                   |    3 ++
 drivers/scsi/scsi_sysfs.c                  |   41 ++++++++++++++--------
 drivers/usb/core/devio.c                   |   10 ++++--
 drivers/usb/early/ehci-dbgp.c              |    2 +-
 drivers/usb/gadget/u_ether.c               |   12 +++----
 fs/btrfs/async-thread.c                    |    9 ++++-
 fs/ext4/balloc.c                           |    3 +-
 fs/ext4/bitmap.c                           |    8 ++---
 fs/ext4/ext4.h                             |    2 +-
 fs/ext4/ialloc.c                           |    3 +-
 fs/ext4/inode.c                            |    9 +++++
 fs/locks.c                                 |    6 ++--
 fs/nfs/file.c                              |    7 ++--
 fs/nfsd/nfs4xdr.c                          |    2 +-
 include/linux/cpu.h                        |    5 +--
 kernel/futex.c                             |   17 ++++++----
 kernel/power/hibernate.c                   |    6 ++++
 kernel/power/suspend.c                     |    3 ++
 kernel/workqueue.c                         |   38 ++++++++++++++++++++-
 net/caif/caif_dev.c                        |    2 +-
 net/core/rtnetlink.c                       |    8 ++++-
 net/ipv4/cipso_ipv4.c                      |    6 ++--
 net/ipv4/tcp.c                             |    5 ++-
 net/ipv4/tcp_input.c                       |    4 ++-
 net/sched/sch_sfb.c                        |    2 ++
 net/sctp/input.c                           |    7 ++--
 net/sctp/socket.c                          |   12 +++++--
 net/sunrpc/sched.c                         |    2 ++
 net/sunrpc/xprtrdma/transport.c            |    3 +-
 net/sunrpc/xprtsock.c                      |   10 ++++++
 net/wanrouter/wanmain.c                    |   51 +++++++++++++---------------
 sound/drivers/mpu401/mpu401_uart.c         |    1 +
 sound/pci/hda/patch_realtek.c              |    1 +
 sound/soc/codecs/wm8962.c                  |    3 ++
 sound/soc/codecs/wm8994.c                  |    2 +-
 sound/usb/clock.c                          |    3 +-
 57 files changed, 352 insertions(+), 172 deletions(-)


