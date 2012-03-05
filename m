Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2CEAeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:34:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:50075 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2CEAeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:34:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/2] audit of linux/device.h users in include/*
Date: Sun,  4 Mar 2012 19:34:15 -0500
Message-Id: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly every subsystem has some kind of header with a proto like:

	void foo(struct device *dev);

and yet there is no reason for most of these guys to care about the
sub fields within the device struct.  This allows us to significantly
reduce the scope of headers including headers.  For this instance, a
reduction of about 40% is achieved by replacing the include with the
simple fact that the device is some kind of a struct.

Unlike the much larger module.h cleanup, this one is simply two
commits.  One to fix the implicit <linux/device.h> users, and then
one to delete the device.h includes from the linux/include/ dir
wherever possible.  The assumption is that this cleanup will not
go in through subsystem maintainers in a fragmented fashion, but
instead be pulled as a whole.

Paul.
---

Paul Gortmaker (2):
  device.h: cleanup users outside of linux/include (C files)
  device.h: audit and cleanup users in main include dir

 drivers/base/power/clock_ops.c        |    1 +
 drivers/base/power/common.c           |    1 +
 drivers/base/power/opp.c              |    1 +
 drivers/base/regmap/regcache-lzo.c    |    1 +
 drivers/base/regmap/regcache-rbtree.c |    1 +
 drivers/base/regmap/regcache.c        |    1 +
 drivers/base/regmap/regmap-debugfs.c  |    1 +
 drivers/base/regmap/regmap-irq.c      |    1 +
 drivers/edac/edac_stub.c              |    1 +
 drivers/edac/mce_amd_inj.c            |    1 +
 drivers/mfd/wm8994-regmap.c           |    1 +
 drivers/power/apm_power.c             |    1 +
 drivers/power/power_supply.h          |    4 ++++
 drivers/power/power_supply_leds.c     |    1 +
 drivers/power/power_supply_sysfs.c    |    1 +
 include/linux/amba/pl022.h            |    2 --
 include/linux/atmdev.h                |    2 +-
 include/linux/attribute_container.h   |    3 ++-
 include/linux/c2port.h                |    3 ++-
 include/linux/cdrom.h                 |    1 -
 include/linux/cpu.h                   |    3 ++-
 include/linux/cpufreq.h               |    1 -
 include/linux/crash_dump.h            |    1 -
 include/linux/dma-buf.h               |    2 +-
 include/linux/edac.h                  |    6 +++++-
 include/linux/fb.h                    |    1 -
 include/linux/firewire.h              |    3 ++-
 include/linux/hwmon-sysfs.h           |    2 ++
 include/linux/hwmon.h                 |    2 +-
 include/linux/hwspinlock.h            |    2 +-
 include/linux/ide.h                   |    3 ++-
 include/linux/ipmi.h                  |    2 +-
 include/linux/ipmi_smi.h              |    3 ++-
 include/linux/jz4740-adc.h            |    2 +-
 include/linux/maple.h                 |    2 +-
 include/linux/mfd/abx500.h            |    3 ++-
 include/linux/mfd/abx500/ab5500.h     |    2 +-
 include/linux/mfd/abx500/ab8500.h     |    4 +++-
 include/linux/mfd/pm8xxx/pm8921.h     |    1 -
 include/linux/mfd/stmpe.h             |    4 +++-
 include/linux/mfd/tc3589x.h           |    2 +-
 include/linux/mlx4/driver.h           |    1 -
 include/linux/mmc/card.h              |    1 +
 include/linux/mmc/core.h              |    1 -
 include/linux/mmc/host.h              |    1 +
 include/linux/netdevice.h             |    2 +-
 include/linux/of_device.h             |    3 ++-
 include/linux/opp.h                   |    1 +
 include/linux/phy.h                   |    5 +++--
 include/linux/pm_domain.h             |    2 ++
 include/linux/power_supply.h          |    3 ++-
 include/linux/regmap.h                |    2 +-
 include/linux/regulator/consumer.h    |    3 ++-
 include/linux/rfkill.h                |    2 +-
 include/linux/rio_drv.h               |    1 -
 include/linux/serial_pnx8xxx.h        |    1 -
 include/linux/spi/mmc_spi.h           |    2 +-
 include/linux/wimax/debug.h           |    2 +-
 include/media/media-device.h          |    3 ++-
 include/media/v4l2-ctrls.h            |    1 -
 include/media/v4l2-ioctl.h            |    1 -
 include/net/mac80211.h                |    3 ++-
 include/scsi/scsi_device.h            |    2 +-
 include/sound/core.h                  |    5 ++---
 include/sound/soc-dapm.h              |    3 ++-
 include/trace/events/regmap.h         |    2 +-
 include/trace/events/rpm.h            |    3 ++-
 include/trace/events/writeback.h      |    1 -
 net/rfkill/core.c                     |    1 +
 sound/core/init.c                     |    1 +
 sound/core/pcm.c                      |    1 +
 sound/core/seq/seq.c                  |    1 +
 sound/core/timer.c                    |    1 +
 73 files changed, 90 insertions(+), 52 deletions(-)

-- 
1.7.9.1

