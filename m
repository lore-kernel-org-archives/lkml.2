Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968034Ab2ERV1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967811Ab2ERV1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:27:00 -0400
Date: Fri, 18 May 2012 14:26:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/54] 3.0.32-stable review
Message-ID: <20120518212656.GA4992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.32 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 20 21:15:57 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.32-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/networking/ip-sysctl.txt |    4 +-
 Makefile                               |    4 +-
 arch/arm/kernel/smp.c                  |    4 +-
 arch/arm/kernel/sys_arm.c              |    2 +-
 arch/arm/mach-orion5x/mpp.h            |    4 +-
 arch/arm/mm/fault.c                    |    4 +-
 arch/sparc/kernel/central.c            |    2 +-
 arch/sparc/mm/ultra.S                  |    6 +--
 arch/tile/kernel/compat_signal.c       |   12 ++---
 arch/x86/kernel/setup_percpu.c         |   14 +++++-
 arch/x86/xen/enlighten.c               |    7 ++-
 arch/x86/xen/mmu.c                     |    7 ++-
 drivers/acpi/sleep.c                   |    8 ++++
 drivers/crypto/Kconfig                 |    1 +
 drivers/gpio/Kconfig                   |   11 +++--
 drivers/gpio/pch_gpio.c                |    1 +
 drivers/md/md.c                        |    2 +
 drivers/media/rc/ene_ir.c              |   32 ++++++-------
 drivers/media/rc/fintek-cir.c          |   20 ++++----
 drivers/media/rc/ite-cir.c             |   20 ++++----
 drivers/media/rc/nuvoton-cir.c         |   36 +++++++--------
 drivers/media/rc/winbond-cir.c         |   78 ++++++++++++++++----------------
 drivers/net/Kconfig                    |   11 +++--
 drivers/net/pch_gbe/pch_gbe_main.c     |   50 +++++++++++++++-----
 drivers/net/pch_gbe/pch_gbe_param.c    |   15 +++---
 drivers/net/sky2.c                     |   31 ++++++++-----
 drivers/net/sky2.h                     |    1 -
 drivers/net/sungem.c                   |    2 +-
 drivers/net/tg3.c                      |   18 +++++++-
 drivers/net/usb/asix.c                 |    4 +-
 drivers/net/usb/cdc_ether.c            |   30 +++++++++++-
 drivers/net/usb/smsc95xx.c             |    2 +-
 drivers/net/usb/usbnet.c               |   54 +++++++++++++++-------
 drivers/platform/x86/sony-laptop.c     |    2 +-
 drivers/regulator/max8997.c            |    2 +-
 drivers/scsi/hpsa.c                    |    4 +-
 fs/ext3/ialloc.c                       |    8 +++-
 fs/ext4/ialloc.c                       |    8 +++-
 fs/ext4/xattr.c                        |    7 +--
 fs/jffs2/gc.c                          |    2 +-
 fs/nfs/nfs4proc.c                      |    1 +
 fs/super.c                             |    2 +
 include/asm-generic/statfs.h           |    2 +-
 include/linux/seqlock.h                |    2 +-
 include/linux/usb/usbnet.h             |    3 +-
 init/do_mounts.c                       |    2 +-
 kernel/compat.c                        |   63 +++++++++++++++++++-------
 kernel/fork.c                          |    3 ++
 mm/hugetlb.c                           |    1 -
 mm/memcontrol.c                        |    6 +++
 mm/nobootmem.c                         |    3 +-
 mm/percpu.c                            |   12 +++++
 net/core/dev.c                         |   20 ++++++++
 net/ipv4/tcp.c                         |   12 ++---
 net/ipv4/tcp_input.c                   |    2 +-
 net/l2tp/l2tp_ip.c                     |    3 +-
 net/sched/sch_netem.c                  |    6 +--
 sound/pci/echoaudio/echoaudio_dsp.c    |    2 +-
 sound/pci/hda/hda_intel.c              |    6 ++-
 59 files changed, 448 insertions(+), 233 deletions(-)

