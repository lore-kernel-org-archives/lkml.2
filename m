Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2AKJ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:27:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45861 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2AKJ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:27:23 -0500
Message-ID: <1326274036.8938.3.camel@phoenix>
Subject: [PATCH] mfd: Fix section mismatch warning for da9052-spi
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 11 Jan 2012 17:27:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __devinit annotation for da9052_spi_probe to fix below build warning:

WARNING: drivers/built-in.o(.text+0x349b4): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init()
The function da9052_spi_probe() references
the function __devinit da9052_device_init().
This is often because da9052_spi_probe lacks a __devinit
annotation or the annotation of da9052_device_init is wrong.

Also add __devexit annotation for da9052_spi_remove because we have
__devexit_p around it in the remove callback.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da9052-spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index cdbc7ca..2693c87 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -21,7 +21,7 @@
 
 #include <linux/mfd/da9052/da9052.h>
 
-static int da9052_spi_probe(struct spi_device *spi)
+static int __devinit da9052_spi_probe(struct spi_device *spi)
 {
 	int ret;
 	const struct spi_device_id *id = spi_get_device_id(spi);
@@ -61,7 +61,7 @@ err:
 	return ret;
 }
 
-static int da9052_spi_remove(struct spi_device *spi)
+static int __devexit da9052_spi_remove(struct spi_device *spi)
 {
 	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
 
-- 
1.7.5.4



