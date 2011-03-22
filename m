Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1CVI1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:27:48 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46702 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1CVI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:27:39 -0400
X-Auth-Info: tYa63Ui8hUkKhj3DzebrSF+WdrmqYeRkAwwB06olvbA=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v6 6/6] powerpc, tqm5200: update tqm5200_defconfig to fit for charon board.
Date: Tue, 22 Mar 2011 09:27:32 +0100
Message-Id: <1300782452-528-7-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300782452-528-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added:

CONFIG_MTD_OF_PARTS
CONFIG_MTD_PLATRAM
CONFIG_FIXED_PHY
CONFIG_SENSORS_LM80
CONFIG_MFD_SM501
CONFIG_FB
CONFIG_FB_FOREIGN_ENDIAN
CONFIG_FB_SM501
CONFIG_FRAMEBUFFER_CONSOLE
CONFIG_RTC_DRV_DS1374

Signed-off-by: Heiko Schocher <hs@denx.de>
cc: Wolfram Sang <w.sang@pengutronix.de>
cc: Grant Likely <grant.likely@secretlab.ca>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Wolfgang Denk <wd@denx.de>
cc: Paul Mundt <lethal@linux-sh.org>
---
- changes since v1:
  added Grant Likely to cc
- changes for v6:
  - new in this version, therefore patch
    "powerpc, mpc5200: update mpc5200_defconfig to fit for charon board."
    removed.
    As this board is tqm5200 based, added necessary changes
    to the tqm5200_defconfig. In previous patchserie I added
    the changes to mpc5200_defconfig, as Wolfram Sang mentioned,
    but as tqm5200_defconfig is in mainline, and the board is
    tqm5200 based, I think, thats the appropriate place, as
    new defconfigs are not accepted. Paul, before applying
    this patch series, this patch should get an Acked by
    from a powerpc maintainer...
  - repost the complete patchserie as Paul Mundt suggested

 arch/powerpc/configs/52xx/tqm5200_defconfig |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 959cd2c..716a37b 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -1,9 +1,10 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
+CONFIG_SPARSE_IRQ=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
@@ -17,7 +18,6 @@ CONFIG_PPC_MPC5200_SIMPLE=y
 CONFIG_PPC_MPC5200_BUGFIX=y
 # CONFIG_PPC_PMAC is not set
 CONFIG_PPC_BESTCOMM=y
-CONFIG_SPARSE_IRQ=y
 CONFIG_PM=y
 # CONFIG_PCI is not set
 CONFIG_NET=y
@@ -38,17 +38,18 @@ CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
 CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_MTD_PLATRAM=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=32768
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
@@ -56,13 +57,11 @@ CONFIG_PATA_MPC52xx=y
 CONFIG_PATA_PLATFORM=y
 CONFIG_NETDEVICES=y
 CONFIG_LXT_PHY=y
+CONFIG_FIXED_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_FEC_MPC52xx=y
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
-# CONFIG_INPUT is not set
-# CONFIG_SERIO is not set
-# CONFIG_VT is not set
 CONFIG_SERIAL_MPC52xx=y
 CONFIG_SERIAL_MPC52xx_CONSOLE=y
 CONFIG_SERIAL_MPC52xx_CONSOLE_BAUD=115200
@@ -70,7 +69,13 @@ CONFIG_SERIAL_MPC52xx_CONSOLE_BAUD=115200
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MPC=y
+CONFIG_SENSORS_LM80=y
 CONFIG_WATCHDOG=y
+CONFIG_MFD_SM501=y
+CONFIG_FB=y
+CONFIG_FB_FOREIGN_ENDIAN=y
+CONFIG_FB_SM501=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_DEVICEFS=y
 # CONFIG_USB_DEVICE_CLASS is not set
@@ -80,10 +85,10 @@ CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
 CONFIG_USB_STORAGE=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1307=y
+CONFIG_RTC_DRV_DS1374=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_INOTIFY=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
@@ -102,7 +107,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_PCBC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-- 
1.7.4

