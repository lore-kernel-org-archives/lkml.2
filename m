Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab1DIQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 12:56:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40160 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1DIQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 12:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gcd67WmdyAJOjJ9cdOiAkwV8GtJtaYzoIqWPz31RA2gZaT4HrfuqlGf9LifcaIsb2Y
         fye4moOzoFfCRXAFuPoGo4dIuBbjAf+lGwHd129dW3JWpy5nw7njDmHL9OtEEpQm9kDK
         C3nTPPxM0JCZDB6mUK/2hKd4Tx85gwaC9c9Fs=
From: wanlong.gao@gmail.com
To: geert@linux-m68k.org, starvik@axis.com, jesper.nilsson@axis.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] 2.6.39-rc2:Removed the unused variable for build warnings
Date: Sun, 10 Apr 2011 00:55:17 +0800
Message-Id: <1302368117-32350-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Removed the unused variable for avoiding the build warnings.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/cris/arch-v32/kernel/ptrace.c |    2 --
 drivers/mfd/wl1273-core.c          |    1 -
 drivers/net/cris/eth_v10.c         |    1 -
 drivers/regulator/wm831x-dcdc.c    |    2 --
 drivers/scsi/atari_NCR5380.c       |    1 -
 fs/xfs/linux-2.6/xfs_buf.c         |    2 --
 6 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 511ece9..42ed6c7
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -115,8 +115,6 @@ void user_disable_single_step(struct task_struct *child)
 void
 ptrace_disable(struct task_struct *child)
 {
-	unsigned long tmp;
-
 	/* Deconfigure SPC and S-bit. */
 	user_disable_single_step(child);
 	put_reg(child, PT_SPC, 0);
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index 04914f2..37af778
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -153,7 +153,6 @@ out:
  */
 static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
 {
-	u16 val;
 	int r;
 
 	if (volume > WL1273_MAX_VOLUME)
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 9d267d3..f3b7741
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1132,7 +1132,6 @@ static irqreturn_t
 e100rxtx_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = netdev_priv(dev);
 	unsigned long irqbits;
 
 	/*
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index e93453b..a0982e8
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -600,7 +600,6 @@ err:
 static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
@@ -776,7 +775,6 @@ err:
 static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index ea439f9..24652f1
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -914,7 +914,6 @@ static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
 	SETUP_HOSTDATA(cmd->device->host);
 	Scsi_Cmnd *tmp;
-	int oldto;
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5ea4020..a125b32
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -657,8 +657,6 @@ xfs_buf_readahead(
 	xfs_off_t		ioff,
 	size_t			isize)
 {
-	struct backing_dev_info *bdi;
-
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-- 
1.7.3

