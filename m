Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab2CMJqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:46:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49253 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab2CMJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:46:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="171955172"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 0/3] Introduce simple_open()
Date: Tue, 13 Mar 2012 02:46:25 -0700
Message-Id: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that if I want to tweak debugfs file ops I need to copy
the implementation of default_open() in fs/debugfs/file.c. I went
to look for an exported function that would be common across all
debugfs users but I couldn't find any.

This patchset moves default_open() to libfs so that other filesystems
can use it (although almost 99% of users are debugfs clients). Andrew
has picked up the first patch but I'm including it here for
completeness.

This is based on linux-next at next-20120302

Changes since v1:
 * Fixed coccinelle script
 * Included mega patch to move all current users

Cc: <linux-fsdevel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>

Stephen Boyd (3):
  libfs: Add simple_open()
  coccinelle: semantic patch for simple_open()
  simple_open: Automatically convert to simple_open()

 arch/arm/mach-msm/smd_debug.c                   |    8 +----
 arch/arm/plat-mxc/audmux-v2.c                   |    8 +----
 arch/x86/kernel/kdebugfs.c                      |    9 +----
 drivers/acpi/ec_sys.c                           |    8 +----
 drivers/base/regmap/regmap-debugfs.c            |   12 ++-----
 drivers/bluetooth/btmrvl_debugfs.c              |   26 ++++++--------
 drivers/char/virtio_console.c                   |    8 +----
 drivers/dma/coh901318.c                         |    9 +----
 drivers/gpu/drm/i915/i915_debugfs.c             |   14 ++------
 drivers/hid/hid-picolcd.c                       |   22 ++----------
 drivers/hid/hid-wiimote-debug.c                 |    8 +----
 drivers/idle/i7300_idle.c                       |    8 +----
 drivers/iommu/omap-iommu-debug.c                |   10 ++----
 drivers/mfd/aat2870-core.c                      |    9 +----
 drivers/mfd/ab3100-core.c                       |    8 +----
 drivers/misc/ibmasm/ibmasmfs.c                  |    8 +----
 drivers/mtd/ubi/debug.c                         |   10 +-----
 drivers/net/caif/caif_spi.c                     |   10 ++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   12 +------
 drivers/net/wimax/i2400m/debugfs.c              |   15 ++------
 drivers/net/wireless/ath/ath5k/debug.c          |   23 +++++-------
 drivers/net/wireless/ath/ath6kl/debug.c         |   44 ++++++++++-------------
 drivers/net/wireless/ath/ath9k/debug.c          |   37 +++++++++----------
 drivers/net/wireless/ath/ath9k/dfs_debug.c      |    9 +----
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |   26 ++++++--------
 drivers/net/wireless/ath/ath9k/rc.c             |    8 +----
 drivers/net/wireless/ath/carl9170/debug.c       |    7 +---
 drivers/net/wireless/b43/debugfs.c              |    8 +----
 drivers/net/wireless/b43legacy/debugfs.c        |    8 +----
 drivers/net/wireless/iwlegacy/3945-rs.c         |    8 +----
 drivers/net/wireless/iwlegacy/4965-rs.c         |   12 ++-----
 drivers/net/wireless/iwlegacy/debug.c           |   12 ++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   11 ++----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   12 ++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c   |   12 ++-----
 drivers/net/wireless/iwmc3200wifi/debugfs.c     |   14 +++-----
 drivers/net/wireless/iwmc3200wifi/sdio.c        |    9 +----
 drivers/net/wireless/libertas/debugfs.c         |    8 +----
 drivers/net/wireless/mwifiex/debugfs.c          |   18 ++--------
 drivers/net/wireless/wl1251/debugfs.c           |   10 ++----
 drivers/net/wireless/wl12xx/debugfs.c           |   34 ++++++++----------
 drivers/oprofile/oprofilefs.c                   |   14 ++------
 drivers/remoteproc/remoteproc_debugfs.c         |   13 ++-----
 drivers/scsi/lpfc/lpfc_debugfs.c                |    9 +----
 drivers/spi/spi-dw.c                            |    8 +----
 drivers/tty/serial/mfd.c                        |    9 ++---
 drivers/tty/serial/pch_uart.c                   |    8 ++---
 drivers/usb/core/inode.c                        |   10 +-----
 drivers/usb/host/ehci-dbg.c                     |    9 +----
 drivers/uwb/uwb-debug.c                         |    9 +----
 fs/debugfs/file.c                               |   14 ++------
 fs/dlm/debug_fs.c                               |   12 +------
 fs/libfs.c                                      |    8 +++++
 fs/pstore/inode.c                               |    8 +----
 include/linux/fs.h                              |    1 +
 kernel/trace/blktrace.c                         |   18 ++--------
 net/mac80211/debugfs.c                          |   16 +++------
 net/wireless/debugfs.c                          |    8 +----
 scripts/coccinelle/api/simple_open.cocci        |   34 ++++++++++++++++++
 sound/soc/soc-core.c                            |    8 +----
 sound/soc/soc-dapm.c                            |   16 ++-------
 61 files changed, 210 insertions(+), 574 deletions(-)
 create mode 100644 scripts/coccinelle/api/simple_open.cocci

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

