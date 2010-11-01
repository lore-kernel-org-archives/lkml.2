Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0KARIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:08:25 -0400
Received: from king.tilera.com ([72.1.168.226]:2790 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0KARIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:08:24 -0400
Message-Id: <201011011708.oA1H8KD5008871@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 1 Nov 2010 12:46:10 -0400
Subject: [PATCH] arch/tile: mark "hardwall" device as non-seekable
To: linux-kernel@vger.kernel.org, arnd@arndb.de
X-OriginalArrivalTime: 01 Nov 2010 17:08:21.0201 (UTC) FILETIME=[62CA1C10:01CB79E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd's recent patch series tagged this device with noop_llseek,
conservatively.  In fact, it should be no_llseek, which we arrange
for by opening the device with nonseekable_open().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/hardwall.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 1e54a78..db5e610 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -768,13 +768,13 @@ static int hardwall_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations dev_hardwall_fops = {
+	.open           = nonseekable_open,
 	.unlocked_ioctl = hardwall_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = hardwall_compat_ioctl,
 #endif
 	.flush          = hardwall_flush,
 	.release        = hardwall_release,
-	.llseek		= noop_llseek,
 };
 
 static struct cdev hardwall_dev;
-- 
1.6.5.2

