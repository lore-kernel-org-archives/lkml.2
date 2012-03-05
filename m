Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2CEAe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:34:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:50086 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2CEAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:34:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20device=2Eh=3A=20audit=20and=20cleanup=20users=20in=20main=20include=20dir?=
Date: Sun,  4 Mar 2012 19:34:17 -0500
Message-Id: <1330907657-2156-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <linux/device.h> header includes a lot of stuff, and
it in turn gets a lot of use just for the basic "struct device"
which appears so often.

Clean up the users as follows:

1) For those headers only needing "struct device" as a pointer
in fcn args, replace the include with exactly that.

2) For headers not really using anything from device.h, simply
delete the include altogether.

3) For headers relying on getting device.h implicitly before
being included themselves, now explicitly include device.h

4) For files in which doing #1 or #2 uncovers an implicit
dependency on some other header, fix by explicitly adding
the required header(s).

Any C files that were implicitly relying on device.h to be
present have already been dealt with in advance.

Total removals from #1 and #2: 51.  Total additions coming
from #3: 9.  Total other implicit dependencies from #4: 7.

As of 3.3-rc1, there were 110, so a net removal of 42 gives
about a 38% reduction in device.h presence in include/*

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/amba/pl022.h          |    2 --
 include/linux/atmdev.h              |    2 +-
 include/linux/attribute_container.h |    3 ++-
 include/linux/c2port.h              |    3 ++-
 include/linux/cdrom.h               |    1 -
 include/linux/cpu.h                 |    3 ++-
 include/linux/cpufreq.h             |    1 -
 include/linux/crash_dump.h          |    1 -
 include/linux/dma-buf.h             |    2 +-
 include/linux/edac.h                |    6 +++++-
 include/linux/fb.h                  |    1 -
 include/linux/firewire.h            |    3 ++-
 include/linux/hwmon-sysfs.h         |    2 ++
 include/linux/hwmon.h               |    2 +-
 include/linux/hwspinlock.h          |    2 +-
 include/linux/ide.h                 |    3 ++-
 include/linux/ipmi.h                |    2 +-
 include/linux/ipmi_smi.h            |    3 ++-
 include/linux/jz4740-adc.h          |    2 +-
 include/linux/maple.h               |    2 +-
 include/linux/mfd/abx500.h          |    3 ++-
 include/linux/mfd/abx500/ab5500.h   |    2 +-
 include/linux/mfd/abx500/ab8500.h   |    4 +++-
 include/linux/mfd/pm8xxx/pm8921.h   |    1 -
 include/linux/mfd/stmpe.h           |    4 +++-
 include/linux/mfd/tc3589x.h         |    2 +-
 include/linux/mlx4/driver.h         |    1 -
 include/linux/mmc/card.h            |    1 +
 include/linux/mmc/core.h            |    1 -
 include/linux/mmc/host.h            |    1 +
 include/linux/netdevice.h           |    2 +-
 include/linux/of_device.h           |    3 ++-
 include/linux/opp.h                 |    1 +
 include/linux/phy.h                 |    5 +++--
 include/linux/pm_domain.h           |    2 ++
 include/linux/power_supply.h        |    3 ++-
 include/linux/regmap.h              |    2 +-
 include/linux/regulator/consumer.h  |    3 ++-
 include/linux/rfkill.h              |    2 +-
 include/linux/rio_drv.h             |    1 -
 include/linux/serial_pnx8xxx.h      |    1 -
 include/linux/spi/mmc_spi.h         |    2 +-
 include/linux/wimax/debug.h         |    2 +-
 include/media/media-device.h        |    3 ++-
 include/media/v4l2-ctrls.h          |    1 -
 include/media/v4l2-ioctl.h          |    1 -
 include/net/mac80211.h              |    3 ++-
 include/scsi/scsi_device.h          |    2 +-
 include/sound/core.h                |    5 ++---
 include/sound/soc-dapm.h            |    3 ++-
 include/trace/events/regmap.h       |    2 +-
 include/trace/events/rpm.h          |    3 ++-
 include/trace/events/writeback.h    |    1 -
 53 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/include/linux/amba/pl022.h b/include/linux/amba/pl022.h
index 572f637..9da37a4 100644
--- a/include/linux/amba/pl022.h
+++ b/include/linux/amba/pl022.h
@@ -25,8 +25,6 @@
 #ifndef _SSP_PL022_H
 #define _SSP_PL022_H
 
-#include <linux/device.h>
-
 /**
  * whether SSP is in loopback mode or not
  */
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index f4ff882..52c9409 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -213,7 +213,6 @@ struct atm_cirange {
 
 #ifdef __KERNEL__
 
-#include <linux/device.h>
 #include <linux/wait.h> /* wait_queue_head_t */
 #include <linux/time.h> /* struct timeval */
 #include <linux/net.h>
@@ -249,6 +248,7 @@ struct k_atm_dev_stats {
 	struct k_atm_aal_stats aal5;
 };
 
+struct device;
 
 enum {
 	ATM_VF_ADDR,		/* Address is in use. Set by anybody, cleared
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index c3ab814..896c689 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -9,10 +9,11 @@
 #ifndef _ATTRIBUTE_CONTAINER_H_
 #define _ATTRIBUTE_CONTAINER_H_
 
-#include <linux/device.h>
 #include <linux/list.h>
 #include <linux/klist.h>
 
+struct device;
+
 struct attribute_container {
 	struct list_head	node;
 	struct klist		containers;
diff --git a/include/linux/c2port.h b/include/linux/c2port.h
index a2f7d74..4efabcb 100644
--- a/include/linux/c2port.h
+++ b/include/linux/c2port.h
@@ -9,11 +9,12 @@
  * the Free Software Foundation
  */
 
-#include <linux/device.h>
 #include <linux/kmemcheck.h>
 
 #define C2PORT_NAME_LEN			32
 
+struct device;
+
 /*
  * C2 port basic structs
  */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 35eae4b..d35a12f 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -910,7 +910,6 @@ struct mode_page_header {
 
 #ifdef __KERNEL__
 #include <linux/fs.h>		/* not really needed, later.. */
-#include <linux/device.h>
 #include <linux/list.h>
 
 struct packet_command
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 1f65875..e3cdc3a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -14,11 +14,12 @@
 #ifndef _LINUX_CPU_H_
 #define _LINUX_CPU_H_
 
-#include <linux/device.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
 
+struct device;
+
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
 	int hotpluggable;	/* creates sysfs control file if hotpluggable */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6216115..fad1382 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -14,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/threads.h>
-#include <linux/device.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/completion.h>
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index b936763..37e4f8d 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_CRASH_DUMP
 #include <linux/kexec.h>
-#include <linux/device.h>
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index f8ac076..887dcd4 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -26,11 +26,11 @@
 
 #include <linux/file.h>
 #include <linux/err.h>
-#include <linux/device.h>
 #include <linux/scatterlist.h>
 #include <linux/list.h>
 #include <linux/dma-mapping.h>
 
+struct device;
 struct dma_buf;
 struct dma_buf_attachment;
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 1cd3947..ba317e2 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -13,7 +13,11 @@
 #define _LINUX_EDAC_H_
 
 #include <linux/atomic.h>
-#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+
+struct device;
 
 #define EDAC_OPSTATE_INVAL	-1
 #define EDAC_OPSTATE_POLL	0
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c18122f..9d50967 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -407,7 +407,6 @@ struct fb_cursor {
 
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/list.h>
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 84ccf8e..fba45b8 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -2,7 +2,6 @@
 #define _LINUX_FIREWIRE_H
 
 #include <linux/completion.h>
-#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -68,6 +67,8 @@
 #define CSR_MODEL		0x17
 #define CSR_DIRECTORY_ID	0x20
 
+struct device;
+
 struct fw_csr_iterator {
 	const u32 *p;
 	const u32 *end;
diff --git a/include/linux/hwmon-sysfs.h b/include/linux/hwmon-sysfs.h
index a90c09d..1c7b89a 100644
--- a/include/linux/hwmon-sysfs.h
+++ b/include/linux/hwmon-sysfs.h
@@ -20,6 +20,8 @@
 #ifndef _LINUX_HWMON_SYSFS_H
 #define _LINUX_HWMON_SYSFS_H
 
+#include <linux/device.h>
+
 struct sensor_device_attribute{
 	struct device_attribute dev_attr;
 	int index;
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 6b6ee70..82b29ae 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -14,7 +14,7 @@
 #ifndef _HWMON_H_
 #define _HWMON_H_
 
-#include <linux/device.h>
+struct device;
 
 struct device *hwmon_device_register(struct device *dev);
 
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index aad6bd4..3343298 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -20,12 +20,12 @@
 
 #include <linux/err.h>
 #include <linux/sched.h>
-#include <linux/device.h>
 
 /* hwspinlock mode argument */
 #define HWLOCK_IRQSTATE	0x01	/* Disable interrupts, save state */
 #define HWLOCK_IRQ	0x02	/* Disable interrupts, don't save state */
 
+struct device;
 struct hwspinlock;
 struct hwspinlock_device;
 struct hwspinlock_ops;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 501370b..7afe15f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/bio.h>
-#include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/completion.h>
 #include <linux/pm.h>
@@ -43,6 +42,8 @@
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
+struct device;
+
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
diff --git a/include/linux/ipmi.h b/include/linux/ipmi.h
index bbd156b..48dcba9 100644
--- a/include/linux/ipmi.h
+++ b/include/linux/ipmi.h
@@ -220,10 +220,10 @@ struct kernel_ipmi_msg {
  * The in-kernel interface.
  */
 #include <linux/list.h>
-#include <linux/device.h>
 #include <linux/proc_fs.h>
 
 struct module;
+struct device;
 
 /* Opaque type for a IPMI message user.  One of these is needed to
    send and receive messages. */
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 3ef0d8b..fcb5d44 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -36,10 +36,11 @@
 
 #include <linux/ipmi_msgdefs.h>
 #include <linux/proc_fs.h>
-#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/ipmi.h>
 
+struct device;
+
 /* This files describes the interface for IPMI system management interface
    drivers to bind into the IPMI message handler. */
 
diff --git a/include/linux/jz4740-adc.h b/include/linux/jz4740-adc.h
index 9053f95..8184578 100644
--- a/include/linux/jz4740-adc.h
+++ b/include/linux/jz4740-adc.h
@@ -2,7 +2,7 @@
 #ifndef __LINUX_JZ4740_ADC
 #define __LINUX_JZ4740_ADC
 
-#include <linux/device.h>
+struct device;
 
 /*
  * jz4740_adc_set_config - Configure a JZ4740 adc device
diff --git a/include/linux/maple.h b/include/linux/maple.h
index d9a51b9..c37288b 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -1,9 +1,9 @@
 #ifndef __LINUX_MAPLE_H
 #define __LINUX_MAPLE_H
 
-#include <linux/device.h>
 #include <mach/maple.h>
 
+struct device;
 extern struct bus_type maple_bus_type;
 
 /* Maple Bus command and response codes */
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 9970337..e20dd6e 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -14,9 +14,10 @@
  * Author: Rickard Andersson <rickard.andersson@stericsson.com>
  */
 
-#include <linux/device.h>
 #include <linux/regulator/machine.h>
 
+struct device;
+
 #ifndef MFD_ABX500_H
 #define MFD_ABX500_H
 
diff --git a/include/linux/mfd/abx500/ab5500.h b/include/linux/mfd/abx500/ab5500.h
index a720051..54f820e 100644
--- a/include/linux/mfd/abx500/ab5500.h
+++ b/include/linux/mfd/abx500/ab5500.h
@@ -6,7 +6,7 @@
 #ifndef MFD_AB5500_H
 #define MFD_AB5500_H
 
-#include <linux/device.h>
+struct device;
 
 enum ab5500_devid {
 	AB5500_DEVID_ADC,
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 838c6b4..dca9439 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -7,7 +7,9 @@
 #ifndef MFD_AB8500_H
 #define MFD_AB8500_H
 
-#include <linux/device.h>
+#include <linux/mutex.h>
+
+struct device;
 
 /*
  * AB8500 bank addresses
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
index d5517fd..00fa3de 100644
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ b/include/linux/mfd/pm8xxx/pm8921.h
@@ -18,7 +18,6 @@
 #ifndef __MFD_PM8921_H
 #define __MFD_PM8921_H
 
-#include <linux/device.h>
 #include <linux/mfd/pm8xxx/irq.h>
 
 #define PM8921_NR_IRQS		256
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index ca1d7a3..8c54de6 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -8,7 +8,9 @@
 #ifndef __LINUX_MFD_STMPE_H
 #define __LINUX_MFD_STMPE_H
 
-#include <linux/device.h>
+#include <linux/mutex.h>
+
+struct device;
 
 enum stmpe_block {
 	STMPE_BLOCK_GPIO	= 1 << 0,
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index 16c76e1..3acb3a8 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -7,7 +7,7 @@
 #ifndef __LINUX_MFD_TC3589x_H
 #define __LINUX_MFD_TC3589x_H
 
-#include <linux/device.h>
+struct device;
 
 enum tx3589x_block {
 	TC3589x_BLOCK_GPIO        = 1 << 0,
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index e1eebf7..5f1298b 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -33,7 +33,6 @@
 #ifndef MLX4_DRIVER_H
 #define MLX4_DRIVER_H
 
-#include <linux/device.h>
 #include <linux/mlx4/device.h>
 
 struct mlx4_dev;
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 9f22ba5..895978c 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -10,6 +10,7 @@
 #ifndef LINUX_MMC_CARD_H
 #define LINUX_MMC_CARD_H
 
+#include <linux/device.h>
 #include <linux/mmc/core.h>
 #include <linux/mod_devicetable.h>
 
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 87a976c..820f1ef 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -9,7 +9,6 @@
 #define LINUX_MMC_CORE_H
 
 #include <linux/interrupt.h>
-#include <linux/device.h>
 
 struct request;
 struct mmc_data;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0beba1e..68558d7 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -12,6 +12,7 @@
 
 #include <linux/leds.h>
 #include <linux/sched.h>
+#include <linux/device.h>
 #include <linux/fault-inject.h>
 
 #include <linux/mmc/core.h>
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0eac07c..fa568da 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -38,7 +38,6 @@
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 
-#include <linux/device.h>
 #include <linux/percpu.h>
 #include <linux/rculist.h>
 #include <linux/dmaengine.h>
@@ -56,6 +55,7 @@
 #include <linux/netdev_features.h>
 
 struct netpoll_info;
+struct device;
 struct phy_device;
 /* 802.11 specific */
 struct wireless_dev;
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index ae56384..b444adf 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -5,10 +5,11 @@
 #include <linux/of_platform.h> /* temporary until merge */
 
 #ifdef CONFIG_OF_DEVICE
-#include <linux/device.h>
 #include <linux/of.h>
 #include <linux/mod_devicetable.h>
 
+struct device;
+
 extern const struct of_device_id *of_match_device(
 	const struct of_device_id *matches, const struct device *dev);
 extern void of_device_make_bus_id(struct device *dev);
diff --git a/include/linux/opp.h b/include/linux/opp.h
index ee94b33..2a4e5fa 100644
--- a/include/linux/opp.h
+++ b/include/linux/opp.h
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 
 struct opp;
+struct device;
 
 enum opp_event {
 	OPP_EVENT_ADD, OPP_EVENT_ENABLE, OPP_EVENT_DISABLE,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c599f7ec..6fe0a37 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -19,7 +19,6 @@
 #define __PHY_H
 
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/timer.h>
@@ -88,6 +87,9 @@ typedef enum {
    IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
 #define MII_ADDR_C45 (1<<30)
 
+struct device;
+struct sk_buff;
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -241,7 +243,6 @@ enum phy_state {
 	PHY_RESUMING
 };
 
-struct sk_buff;
 
 /* phy_device: An instance of a PHY
  *
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index a03a0ad..fa2e20b 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -10,6 +10,8 @@
 #define _LINUX_PM_DOMAIN_H
 
 #include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/pm.h>
 #include <linux/err.h>
 
 enum gpd_status {
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index fa9b962..c38c13d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -13,10 +13,11 @@
 #ifndef __LINUX_POWER_SUPPLY_H__
 #define __LINUX_POWER_SUPPLY_H__
 
-#include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/leds.h>
 
+struct device;
+
 /*
  * All voltages, currents, charges, energies, time and temperatures in uV,
  * µA, µAh, µWh, seconds and tenths of degree Celsius unless otherwise
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index eb93921..765736c 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -13,10 +13,10 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/device.h>
 #include <linux/list.h>
 
 struct module;
+struct device;
 struct i2c_client;
 struct spi_device;
 
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f2698a0..10e0d33 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -35,7 +35,8 @@
 #ifndef __LINUX_REGULATOR_CONSUMER_H_
 #define __LINUX_REGULATOR_CONSUMER_H_
 
-#include <linux/device.h>
+struct device;
+struct notifier_block;
 
 /*
  * Regulator operating modes.
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index c6c6084..6fdf027 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -117,10 +117,10 @@ enum rfkill_user_states {
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/device.h>
 #include <linux/leds.h>
 #include <linux/err.h>
 
+struct device;
 /* this is opaque */
 struct rfkill;
 
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 229b3ca..7f07470 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -17,7 +17,6 @@
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/errno.h>
-#include <linux/device.h>
 #include <linux/string.h>
 #include <linux/rio.h>
 
diff --git a/include/linux/serial_pnx8xxx.h b/include/linux/serial_pnx8xxx.h
index de6c19c..79ad87b 100644
--- a/include/linux/serial_pnx8xxx.h
+++ b/include/linux/serial_pnx8xxx.h
@@ -20,7 +20,6 @@
 #define _LINUX_SERIAL_PNX8XXX_H
 
 #include <linux/serial_core.h>
-#include <linux/device.h>
 
 #define PNX8XXX_NR_PORTS	2
 
diff --git a/include/linux/spi/mmc_spi.h b/include/linux/spi/mmc_spi.h
index 0f4eb16..32be8db 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -1,10 +1,10 @@
 #ifndef __LINUX_SPI_MMC_SPI_H
 #define __LINUX_SPI_MMC_SPI_H
 
-#include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 
+struct device;
 struct mmc_host;
 
 /* Put this in platform_data of a device being used to manage an MMC/SD
diff --git a/include/linux/wimax/debug.h b/include/linux/wimax/debug.h
index 57031b4..aaf24ba 100644
--- a/include/linux/wimax/debug.h
+++ b/include/linux/wimax/debug.h
@@ -154,9 +154,9 @@
 #define __debug__h__
 
 #include <linux/types.h>
-#include <linux/device.h>
 #include <linux/slab.h>
 
+struct device;
 
 /* Backend stuff */
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6a27d91..eaade98 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,7 +23,6 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
-#include <linux/device.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -31,6 +30,8 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+struct device;
+
 /**
  * struct media_device - Media device
  * @dev:	Parent device
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eeb3df6..62e04dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,7 +22,6 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
-#include <linux/device.h>
 #include <linux/videodev2.h>
 
 /* forward references */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 3f5d60f..032ff21 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -11,7 +11,6 @@
 
 #include <linux/poll.h>
 #include <linux/fs.h>
-#include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/compiler.h> /* need __user */
 #include <linux/videodev2.h>
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d49928b..f0605df 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
-#include <linux/device.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
@@ -87,6 +86,8 @@
  *
  */
 
+struct device;
+
 /**
  * enum ieee80211_max_queues - maximum number of queues
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 77273f2..34dc831 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -1,7 +1,6 @@
 #ifndef _SCSI_SCSI_DEVICE_H
 #define _SCSI_SCSI_DEVICE_H
 
-#include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -9,6 +8,7 @@
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
 
+struct device;
 struct request_queue;
 struct scsi_cmnd;
 struct scsi_lun;
diff --git a/include/sound/core.h b/include/sound/core.h
index 5ab255f..a420716 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -26,7 +26,6 @@
 #include <linux/mutex.h>		/* struct mutex */
 #include <linux/rwsem.h>		/* struct rw_semaphore */
 #include <linux/pm.h>			/* pm_message_t */
-#include <linux/device.h>
 #include <linux/stringify.h>
 
 /* number of supported soundcards */
@@ -39,10 +38,10 @@
 #define CONFIG_SND_MAJOR	116	/* standard configuration */
 
 /* forward declarations */
-#ifdef CONFIG_PCI
 struct pci_dev;
-#endif
 struct module;
+struct device;
+struct device_attribute;
 
 /* device allocation stuff */
 
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index d26a9b7..ab0d84a 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -13,10 +13,11 @@
 #ifndef __LINUX_SND_SOC_DAPM_H
 #define __LINUX_SND_SOC_DAPM_H
 
-#include <linux/device.h>
 #include <linux/types.h>
 #include <sound/control.h>
 
+struct device;
+
 /* widget has no PM register bit */
 #define SND_SOC_NOPM	-1
 
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index 12fbf43..50fe9ba 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -4,10 +4,10 @@
 #if !defined(_TRACE_REGMAP_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_REGMAP_H
 
-#include <linux/device.h>
 #include <linux/ktime.h>
 #include <linux/tracepoint.h>
 
+struct device;
 struct regmap;
 
 /*
diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
index d62c558..33f85b6 100644
--- a/include/trace/events/rpm.h
+++ b/include/trace/events/rpm.h
@@ -7,7 +7,8 @@
 
 #include <linux/ktime.h>
 #include <linux/tracepoint.h>
-#include <linux/device.h>
+
+struct device;
 
 /*
  * The rpm_internal events are used for tracing some important
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 8588a89..2d0dd3e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -5,7 +5,6 @@
 #define _TRACE_WRITEBACK_H
 
 #include <linux/backing-dev.h>
-#include <linux/device.h>
 #include <linux/writeback.h>
 
 #define show_inode_state(state)					\
-- 
1.7.9.1

