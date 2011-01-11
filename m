Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1AKPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:33:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab1AKPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:33:38 -0500
From: Bernhard Walle <walle@corscience.de>
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Tue, 11 Jan 2011 16:32:52 +0100
Message-Id: <1294759972-10028-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:OnlNUjN5KJr6vjLYbPORv4R/VEY+uGyyu6/CieB3Z6x
 /pff8IsinoqdShQVOP5AHXbYf87gJJV8PAxvacnXItmGcWktSr
 GpJluAr4eJ5+L1Ild6P05GQv81tTTAXuv3p4MWK+o3YjgMOJph
 6iS1Z+PUo3sn7AGtfE5cJ/tTS77/y54Nx/omQRFs2gMMnr3Mvp
 n7H8KcdZjlNPBdikS9/2Q==
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

