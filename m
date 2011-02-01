Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1BAJDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:03:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1BAJDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:03:01 -0500
From: Bernhard Walle <walle@corscience.de>
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Tue,  1 Feb 2011 10:02:46 +0100
Message-Id: <1296550966-4015-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:LOjAbWTIcKRBlES1PT5yJgSWRkPcWQvcZHHnJQbs3RH
 NWD/2Vk2PcDd0NbgYU04DYOpc5+SBYtqBfK7/9SGJ/OH1azr2p
 7Efp/XNYlJAwJxh4JC/hkrSzkgDXRRKvi+dgyJAVe7M0N5z+AY
 mvQub/FRzk4NYezPlKicYX2tOx/fuL80+sf1q5zPAEugfrlSLm
 2i2UF1EpZ/7cjRKg39Vgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the compat_ioctl for operations on /dev/spi* so that 32 bit
userspace applications can access SPI. As far as I can see all data
structure are already prepared for that, so no additional conversion has
to be done.

My use case is MIPS with N32 userspace ABI and toolchain, and that was
also the platform where I tested it successfully (Cavium Octeon).

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/spi/spidev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 4e6245e..bb24ad8 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -543,6 +543,7 @@ static const struct file_operations spidev_fops = {
 	.write =	spidev_write,
 	.read =		spidev_read,
 	.unlocked_ioctl = spidev_ioctl,
+	.compat_ioctl = spidev_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
 	.llseek =	no_llseek,
-- 
1.7.1

