Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0LAKvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:51:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0LAKva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:51:30 -0500
From: Bernhard Walle <walle@corscience.de>
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Wed,  1 Dec 2010 11:51:14 +0100
Message-Id: <1291200674-25630-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:D21LUfa0isaUmUnzlsUzHllBlIGxUJCICPkEIokv7Lb
 kyqvIsjv3ahYkjwMywzfgLYXwbOM3f1oYKGLLkP9xhXSgg1bX4
 yfcSCpfg6bvfFAB5RSXthcIesEkRjwWfzvUI6iJEY0/SGNaH9D
 wyL1WvkG3YGHf/NzSDrKCSVXmiyoMP5HJEhWr4nICyc4oiM5tX
 58ca5uM7TmtJGe9xFa4Tw==
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
index ea1bec3..d3d1155 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -543,6 +543,7 @@ static const struct file_operations spidev_fops = {
 	.write =	spidev_write,
 	.read =		spidev_read,
 	.unlocked_ioctl = spidev_ioctl,
+	.compat_ioctl = spidev_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
 };
-- 
1.7.1

